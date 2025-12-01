//
//  ScanViewModel.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
internal import Combine
import QuartzCore

@MainActor
final class ScanViewModel: ObservableObject {

    @Published var devices: [Device] = []
    @Published var isScanning = false
    @Published var progress: Double = 0
    @Published var errorHandler: ScanErrorHandler

    private let sessionRepo: ScanSessionRepositoryProtocol
    private let deviceRepo: DeviceRepositoryProtocol
    private let scanService: ScanServiceProtocol

    private var sessionId: UUID?
    private var displayLink: CADisplayLink?
    private var scanDuration: Double = 15
    private var scanStartTime: Date?

    private var requestedTimeout: Int = 15
    private var scanRequested = false

    private var cancellables = Set<AnyCancellable>()

    var onScanFinished: ((UUID) -> Void)?

    init(
        sessionRepo: ScanSessionRepositoryProtocol,
        deviceRepo: DeviceRepositoryProtocol,
        scanService: ScanServiceProtocol,
        errorHandler: ScanErrorHandler
    ) {
        self.sessionRepo = sessionRepo
        self.deviceRepo = deviceRepo
        self.scanService = scanService
        self.errorHandler = errorHandler

        bind()
    }

    private func bind() {

        scanService.scanStarted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                guard self.scanRequested else { return }

                Task {
                    do {
                        self.sessionId = try await self.sessionRepo.createSession(type: .combined)

                        self.scanStartTime = Date()
                        self.scanDuration = Double(self.requestedTimeout)
                        self.isScanning = true
                        self.startSmoothProgress()

                    } catch {
                        self.scanService.stopScan()
                        self.errorHandler.handle(.scanFailed("Failed to create session"))
                    }
                }
            }
            .store(in: &cancellables)

        scanService.deviceFound
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                guard let self else { return }

                if let index = self.devices.firstIndex(where: { $0.identifier == device.identifier }) {
                    self.devices[index] = device
                } else {
                    self.devices.append(device)
                }
            }
            .store(in: &cancellables)

        scanService.errorOccurred
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                self.stopScanning()
                self.errorHandler.handle(error)
            }
            .store(in: &cancellables)

        scanService.scanCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                Task { await self?.handleScanCompleted() }
            }
            .store(in: &cancellables)
    }

    func startScanning(timeout: Int = 15) {
        devices.removeAll()
        progress = 0
        displayLink?.invalidate()
        scanStartTime = nil
        isScanning = false
        sessionId = nil

        scanRequested = true
        requestedTimeout = timeout

        scanService.startScan(timeout: TimeInterval(timeout))
    }

    func stopScanning() {
        displayLink?.invalidate()
        scanService.stopScan()
        isScanning = false
        scanRequested = false
    }

    private func startSmoothProgress() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateProgress() {
        guard let start = scanStartTime, isScanning else { return }
        let elapsed = Date().timeIntervalSince(start)
        progress = min(1.0, elapsed / scanDuration)

        if progress >= 1.0 {
            displayLink?.invalidate()
        }
    }

    private func handleScanCompleted() async {
        displayLink?.invalidate()
        isScanning = false
        scanRequested = false

        guard let sessionId else { return }

        do {
            try await deviceRepo.saveDevices(devices, to: sessionId)
            try await sessionRepo.updateSessionEndDate(sessionId, endDate: Date())

            errorHandler.handleSuccess(devicesCount: devices.count)
            onScanFinished?(sessionId)

        } catch {
            errorHandler.handle(.savingFailed)
        }
    }
}
