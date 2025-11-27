//
//  BluetoothService.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
import CoreBluetooth

final class BluetoothService: NSObject, BluetoothServiceProtocol {

    private var centralManager: CBCentralManager?
    private var scanning = false
    private var pendingScan = false
    private var scanTimeout: TimeInterval = 15

    var onDeviceFound: ((Device) -> Void)?
    var onScanCompleted: (() -> Void)?
    var onBluetoothDisabled: (() -> Void)?

    override init() {
        super.init()
    }

    private func configureBluetooth() {
        centralManager = CBCentralManager(
            delegate: self,
            queue: DispatchQueue.global(qos: .userInitiated)
        )
    }

    func startScan(timeout: TimeInterval = 15) {
        scanTimeout = timeout

        if centralManager == nil {
            configureBluetooth()
            pendingScan = true
            return
        }

        guard let manager = centralManager else { return }

        if manager.state == .poweredOn {
            beginScan()
        } else {
            pendingScan = true
        }
    }

    func stopScan() {
        guard scanning else { return }
        scanning = false

        centralManager?.stopScan()
        onScanCompleted?()
    }

    private func beginScan() {
        scanning = true
        centralManager?.scanForPeripherals(withServices: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + scanTimeout) { [weak self] in
            self?.stopScan()
        }
    }
}

extension BluetoothService: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if pendingScan {
                pendingScan = false
                beginScan()
            }

        case .poweredOff, .unauthorized:
            onBluetoothDisabled?()

        case .unsupported, .resetting, .unknown:
            break

        @unknown default:
            break
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        let device = Device(
            id: UUID(),
            name: peripheral.name,
            identifier: peripheral.identifier.uuidString,
            secondaryIdentifier: nil,
            rssi: RSSI.intValue,
            status: .discovered,
            source: .bluetooth,
            scanSessionId: UUID() // VM заменит на фактический sessionId
        )

        onDeviceFound?(device)
    }
}
