//
//  ScanServiceProtocol.swift
//  Scanner
//
//  Created by Alena Ivanova on 01.12.2025.
//


internal import Combine
import Foundation

protocol ScanServiceProtocol {
    var scanStarted: PassthroughSubject<Void, Never> { get }
    var scanCompleted: PassthroughSubject<Void, Never> { get }
    var deviceFound: PassthroughSubject<Device, Never> { get }
    var errorOccurred: PassthroughSubject<ScanError, Never> { get }

    func startScan(timeout: TimeInterval)
    func stopScan()
}
