//
//  SessionDetailsViewModel.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//

import Foundation
internal import Combine

@MainActor
final class SessionDetailsViewModel: ObservableObject {

    @Published var devices: [Device] = []
    @Published var isLoading = false
    @Published var errorHandler: ScanErrorHandler
    @Published var searchText: String = ""

    private let sessionId: UUID
    private let deviceRepo: DeviceRepositoryProtocol
    private let bt: BluetoothServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(
        sessionId: UUID,
        deviceRepo: DeviceRepositoryProtocol,
        bt: BluetoothServiceProtocol,
        errorHandler: ScanErrorHandler
    ) {
        self.sessionId = sessionId
        self.deviceRepo = deviceRepo
        self.bt = bt
        self.errorHandler = errorHandler

        bindBluetooth()
        bindSearch()
    }

    func loadDevices() async {
        await search()
    }

    private func bindSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.search() }
            }
            .store(in: &cancellables)
    }

    func search() async {
        isLoading = true
        defer { isLoading = false }

        do {
            devices = try await deviceRepo.fetchDevices(
                for: sessionId,
                matching: searchText
            )

            syncStatuses()

        } catch {
            errorHandler.handle(.scanFailed("Failed to load devices"))
        }
    }

    private func bindBluetooth() {
        bt.deviceStatusChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] identifier, status in
                guard let self else { return }

                if let index = self.devices.firstIndex(where: { $0.identifier == identifier }) {
                    var updated = self.devices[index]
                    updated.status = status
                    self.devices[index] = updated
                }
            }
            .store(in: &cancellables)
    }

    func syncStatuses() {
        for i in devices.indices {
            let id = devices[i].identifier
            let status = bt.currentStatus(for: id)
            devices[i].status = status
        }
    }

    func connect(_ device: Device) {
        bt.connect(to: device.identifier)
    }

    func disconnect(_ device: Device) {
        bt.disconnect(from: device.identifier)
    }
}
