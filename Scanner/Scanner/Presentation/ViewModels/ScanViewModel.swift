//
//  ScanViewModel.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import Foundation
internal import Combine
//
//@MainActor
//final class ScanViewModel: ObservableObject {
//
//    @Published var devices: [Device] = []
//    @Published var isScanning = false
//
//    private let sessionRepo: ScanSessionRepositoryProtocol
//    private let deviceRepo: DeviceRepositoryProtocol
//    private let bt: BluetoothServiceProtocol
//    private let lan: LanScanServiceProtocol
//
//    private var sessionId: UUID?
//
//    init(
//        sessionRepo: ScanSessionRepositoryProtocol,
//        deviceRepo: DeviceRepositoryProtocol,
//        bt: BluetoothServiceProtocol,
//        lan: LanScanServiceProtocol
//    ) {
//        self.sessionRepo = sessionRepo
//        self.deviceRepo = deviceRepo
//        self.bt = bt
//        self.lan = lan
//
//        setupCallbacks()
//    }
//
//    private func setupCallbacks() {
//        bt.onDeviceFound = { [weak self] device in
//            guard let self else { return }
//            self.devices.append(device)
//        }
//
//        lan.onDeviceFound = { [weak self] device in
//            guard let self else { return }
//            self.devices.append(device)
//        }
//    }
//
//    func startScanning(type: ScanSessionType) async {
//        isScanning = true
//
//        do {
//            let newSessionId = try await sessionRepo.createSession(type: type)
//            sessionId = newSessionId
//
//            switch type {
//            case .bluetooth:
//                bt.startScan(timeout: 15)
//            case .lan:
//                lan.startScan()
//            case .combined:
//                bt.startScan(timeout: 15)
//                lan.startScan()
//            }
//
//        } catch {
//            print("startScanning error: \(error)")
//            isScanning = false
//        }
//    }
//
//    func stopScanning() async {
//        isScanning = false
//        bt.stopScan()
//        lan.stopScan()
//
//        guard let sessionId else { return }
//
//        do {
//            try await deviceRepo.saveDevices(devices, to: sessionId)
//            try await sessionRepo.updateSessionEndDate(sessionId, endDate: Date())
//        } catch {
//            print("stopScanning error: \(error)")
//        }
//    }
//}
import Foundation
@MainActor
final class ScanViewModel: ObservableObject {

    @Published var devices: [Device] = []
    @Published var isScanning = false
    @Published var remainingTime: Int = 0

    private let sessionRepo: ScanSessionRepositoryProtocol
    private let deviceRepo: DeviceRepositoryProtocol
    private let bt: BluetoothServiceProtocol

    private var sessionId: UUID?
    private var countdownTimer: Timer?

    // Экран скажет что делать, когда сканирование закончено
    var onScanFinished: ((UUID) -> Void)?

    init(
        sessionRepo: ScanSessionRepositoryProtocol,
        deviceRepo: DeviceRepositoryProtocol,
        bt: BluetoothServiceProtocol
    ) {
        self.sessionRepo = sessionRepo
        self.deviceRepo = deviceRepo
        self.bt = bt
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        bt.onDeviceFound = { [weak self] device in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.devices.append(device)
            }
        }

        bt.onScanCompleted = { [weak self] in
            Task { @MainActor in
                await self?.handleScanCompleted()
            }
        }

        bt.onBluetoothDisabled = { [weak self] in
            Task { @MainActor in
                self?.isScanning = false
            }
        }
    }


    // MARK: - Start scan

    func startScanning(timeout: Int = 15) async {
        devices.removeAll()
        isScanning = true
        remainingTime = timeout

        do {
            let newSession = try await sessionRepo.createSession(type: .bluetooth)
            sessionId = newSession

            startCountdown(seconds: timeout)
            bt.startScan(timeout: TimeInterval(timeout))

        } catch {
            isScanning = false
        }
    }

    // MARK: - Countdown

    private func startCountdown(seconds: Int) {
        countdownTimer?.invalidate()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] t in
            guard let self else { return }
            self.remainingTime -= 1

            if self.remainingTime <= 0 {
                t.invalidate()
            }
        }
    }

    // MARK: - Stop scan

    func stopScanning() async {
        countdownTimer?.invalidate()
        bt.stopScan()
        await handleScanCompleted()
    }

    // MARK: - Save & navigate

    private func handleScanCompleted() async {
        countdownTimer?.invalidate()
        isScanning = false

        guard let sessionId else { return }

        do {
            try await deviceRepo.saveDevices(devices, to: sessionId)
            try await sessionRepo.updateSessionEndDate(sessionId, endDate: Date())

            onScanFinished?(sessionId)

        } catch {
            print("Saving error:", error)
        }
    }
}
