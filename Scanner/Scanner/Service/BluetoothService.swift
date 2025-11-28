//
//  BluetoothService.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import CoreBluetooth
internal import Combine
import Foundation

final class BluetoothService: NSObject, BluetoothServiceProtocol {

    private var centralManager: CBCentralManager?
    private var scanning = false
    private var pendingScan = false
    private var scanTimeout: TimeInterval = 15

    let scanStarted = PassthroughSubject<Void, Never>()
    let scanCompleted = PassthroughSubject<Void, Never>()
    let deviceFound = PassthroughSubject<Device, Never>()
    let errorOccured = PassthroughSubject<ScanError, Never>()

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
        }

        guard let manager = centralManager else { return }

        pendingScan = true
        handleBluetoothState(manager.state)
    }

    func stopScan() {
        guard scanning else { return }
        scanning = false

        centralManager?.stopScan()
        scanCompleted.send()
    }

    private func beginScan() {
        scanning = true
        scanStarted.send()

        centralManager?.scanForPeripherals(withServices: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + scanTimeout) { [weak self] in
            self?.stopScan()
        }
    }

    private func handleBluetoothState(_ state: CBManagerState) {
        guard pendingScan else { return }

        switch state {
        case .poweredOn:
            pendingScan = false
            beginScan()
        case .poweredOff:
            pendingScan = false
            errorOccured.send(.bluetoothPoweredOff)
        case .unauthorized:
            pendingScan = false
            errorOccured.send(.permissionDenied)
        case .unsupported:
            pendingScan = false
            errorOccured.send(.bluetoothUnavailable)
        case .resetting, .unknown:
            break
        @unknown default:
            pendingScan = false
            errorOccured.send(.unknown)
        }
    }
}

extension BluetoothService: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        handleBluetoothState(central.state)
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
            scanSessionId: UUID()
        )
        deviceFound.send(device)
    }
}
