//
//  BluetoothServiceProtocol.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
internal import Combine

protocol BluetoothServiceProtocol: AnyObject {
    var scanStarted: PassthroughSubject<Void, Never> { get }
    var scanCompleted: PassthroughSubject<Void, Never> { get }
    var deviceFound: PassthroughSubject<Device, Never> { get }
    var errorOccured: PassthroughSubject<ScanError, Never> { get }

    func startScan(timeout: TimeInterval)
    func stopScan()
}
