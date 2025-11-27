//
//  ScanSessionRepositoryProtocol.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation

protocol ScanSessionRepositoryProtocol {
    func createSession(type: ScanSessionType) async throws -> UUID
    func updateSessionEndDate(_ id: UUID, endDate: Date) async throws
    func fetchSessions() async throws -> [ScanSession]
    func deleteSession(id: UUID) async throws
    func deleteAllSessions() async throws
}
