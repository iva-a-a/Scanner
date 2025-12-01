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

    private let sessionRepo: ScanSessionRepositoryProtocol

    init(
        sessionRepo: ScanSessionRepositoryProtocol,
        errorHandler: ScanErrorHandler
    ) {
        self.sessionRepo = sessionRepo
        self.errorHandler = errorHandler
    }

    func loadSessions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            sessions = try await sessionRepo.fetchSessions()
        } catch {
            errorHandler.handle(.scanFailed("Failed to load history"))
            sessions = []
        }
    }
}
