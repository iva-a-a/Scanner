//
//  BluetoothServiceProtocol.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
import CoreBluetooth

protocol BluetoothServiceProtocol: AnyObject {
    var onDeviceFound: ((Device) -> Void)? { get set }
    var onScanCompleted: (() -> Void)? { get set }
    var onBluetoothDisabled: (() -> Void)? { get set }

    func startScan(timeout: TimeInterval)
    func stopScan()
}
