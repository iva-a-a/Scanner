//
//  HistoryViewModel.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import Foundation
internal import Combine

@MainActor
final class HistoryViewModel: ObservableObject {

    @Published var sessions: [ScanSession] = []
    @Published var isLoading = false

    // Фильтры
    @Published var searchText: String = ""
    @Published var startDate: Date?
    @Published var endDate: Date?

    private let sessionRepo: ScanSessionRepositoryProtocol
    private let deviceRepo: DeviceRepositoryProtocol

    init(
        sessionRepo: ScanSessionRepositoryProtocol,
        deviceRepo: DeviceRepositoryProtocol
    ) {
        self.sessionRepo = sessionRepo
        self.deviceRepo = deviceRepo
    }

    // MARK: - Публичные методы

    func loadSessions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            var all = try await sessionRepo.fetchSessions()

            if let startDate {
                all = all.filter { $0.startDate >= startDate }
            }
            if let endDate {
                all = all.filter { $0.endDate <= endDate }
            }

            if !searchText.isEmpty {
                let filtered = try await filterSessionsByDeviceName(
                    sessions: all,
                    name: searchText
                )
                sessions = filtered
            } else {
                sessions = all
            }

        } catch {
            print("HistoryViewModel.loadSessions error: \(error)")
            sessions = []
        }
    }

    /// Отдаёт устройства для конкретной сессии (для экрана SessionDevicesView)
    func loadDevices(for session: ScanSession) async -> [Device] {
        do {
            return try await deviceRepo.fetchDevices(for: session.id)
        } catch {
            print("HistoryViewModel.loadDevices error: \(error)")
            return []
        }
    }

    private func filterSessionsByDeviceName(
        sessions: [ScanSession],
        name: String
    ) async throws -> [ScanSession] {

        let lowercased = name.lowercased()

        var result: [ScanSession] = []

        for session in sessions {
            let devices = try await deviceRepo.fetchDevices(for: session.id)
            let match = devices.contains { device in
                (device.name ?? "").lowercased().contains(lowercased)
            }
            if match {
                result.append(session)
            }
        }
        return result
    }
}
