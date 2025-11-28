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
    private var peripherals: [String: CBPeripheral] = [:]
    private var scanTimeout: TimeInterval = 15
    private var pendingScan = false
    private var scanning = false

    let scanStarted = PassthroughSubject<Void, Never>()
    let scanCompleted = PassthroughSubject<Void, Never>()
    let deviceFound = PassthroughSubject<Device, Never>()
    let errorOccured = PassthroughSubject<ScanError, Never>()
    let deviceStatusChanged = PassthroughSubject<(String, DeviceStatus), Never>()

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

    func connect(to identifier: String) {
        guard let p = peripherals[identifier] else { return }
        centralManager?.connect(p, options: nil)
        deviceStatusChanged.send((identifier, .connecting))
    }

    func disconnect(from identifier: String) {
        guard let p = peripherals[identifier] else { return }
        centralManager?.cancelPeripheralConnection(p)
        deviceStatusChanged.send((identifier, .disconnected))
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
        default:
            break
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
        let identifier = peripheral.identifier.uuidString
        peripherals[identifier] = peripheral

        let device = Device(
            id: UUID(),
            name: peripheral.name,
            identifier: identifier,
            secondaryIdentifier: nil,
            rssi: RSSI.intValue,
            status: .discovered,
            source: .bluetooth,
            scanSessionId: UUID()
        )

        deviceFound.send(device)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let id = peripheral.identifier.uuidString
        deviceStatusChanged.send((id, .connected))
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let id = peripheral.identifier.uuidString
        deviceStatusChanged.send((id, .failed))
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let id = peripheral.identifier.uuidString
        deviceStatusChanged.send((id, .disconnected))
    }
}

extension BluetoothService {
    func currentStatus(for identifier: String) -> DeviceStatus {
        guard let peripheral = peripherals[identifier] else {
            return .disconnected
        }

        switch peripheral.state {
        case .connected: return .connected
        case .connecting: return .connecting
        case .disconnecting: return .disconnected
        default: return .disconnected
        }
    }
}
