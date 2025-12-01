//
//  ScanService.swift
//  Scanner
//
//  Created by Alena Ivanova on 01.12.2025.
//


import Foundation
internal import Combine

final class ScanService: ScanServiceProtocol {

    let scanStarted = PassthroughSubject<Void, Never>()
    let scanCompleted = PassthroughSubject<Void, Never>()
    let deviceFound = PassthroughSubject<Device, Never>()
    let errorOccurred = PassthroughSubject<ScanError, Never>()

    private let bt: BluetoothServiceProtocol
    private let lan: LANServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    private var btFinished = false
    private var lanFinished = false
    private var scanTimeout: TimeInterval = 15

    init(bt: BluetoothServiceProtocol, lan: LANServiceProtocol) {
        self.bt = bt
        self.lan = lan
        bind()
    }

    private func bind() {

        bt.scanStarted
            .sink { [weak self] _ in self?.scanStarted.send() }
            .store(in: &cancellables)

        lan.scanStarted
            .sink { [weak self] _ in self?.scanStarted.send() }
            .store(in: &cancellables)

        bt.deviceFound
            .sink { [weak self] device in self?.deviceFound.send(device) }
            .store(in: &cancellables)

        lan.deviceFound
            .sink { [weak self] device in self?.deviceFound.send(device) }
            .store(in: &cancellables)

        bt.errorOccured
            .sink { [weak self] error in
                self?.errorOccurred.send(error)
            }
            .store(in: &cancellables)

        lan.errorOccurred
            .sink { [weak self] error in
                self?.errorOccurred.send(error)
            }
            .store(in: &cancellables)

        bt.scanCompleted
            .sink { [weak self] _ in
                self?.btFinished = true
                self?.checkScanFinished()
            }
            .store(in: &cancellables)

        lan.scanCompleted
            .sink { [weak self] _ in
                self?.lanFinished = true
                self?.checkScanFinished()
            }
            .store(in: &cancellables)
    }

    private func checkScanFinished() {
        if btFinished && lanFinished {
            scanCompleted.send()
        }
    }

    func startScan(timeout: TimeInterval) {
        scanTimeout = timeout
        btFinished = false
        lanFinished = false

        bt.startScan(timeout: timeout)
        lan.startScan(timeout: timeout)
    }

    func stopScan() {
        bt.stopScan()
        lan.stopScan()
    }
}
