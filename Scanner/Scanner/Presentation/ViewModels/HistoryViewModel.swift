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
    @Published var errorHandler: ScanErrorHandler
    
    @Published var searchText: String = ""
    @Published var startDate: Date?
    @Published var endDate: Date?

    private let sessionRepo: ScanSessionRepositoryProtocol
    private let deviceRepo: DeviceRepositoryProtocol

    init(
        sessionRepo: ScanSessionRepositoryProtocol,
        deviceRepo: DeviceRepositoryProtocol,
        errorHandler: ScanErrorHandler
    ) {
        self.sessionRepo = sessionRepo
        self.deviceRepo = deviceRepo
        self.errorHandler = errorHandler
    }

    func loadSessions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            var all = try await sessionRepo.fetchSessions()

            if let startDate { all = all.filter { $0.startDate >= startDate } }
            if let endDate   { all = all.filter { $0.endDate   <= endDate } }

            if !searchText.isEmpty {
                let ids = try await deviceRepo.fetchSessionIdsMatchingDeviceName(searchText)
                all = all.filter { ids.contains($0.id) }
            }

            sessions = all

        } catch {
            errorHandler.handle(.scanFailed("History upload error"))
            sessions = []
        }
    }

    func loadDevices(for session: ScanSession) async -> [Device] {
        do {
            return try await deviceRepo.fetchDevices(for: session.id)
        } catch {
            errorHandler.handle(.scanFailed("Device loading error"))
            return []
        }
    }
}
