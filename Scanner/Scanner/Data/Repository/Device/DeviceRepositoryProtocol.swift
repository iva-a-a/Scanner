//
//  DeviceRepositoryProtocol.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation

protocol DeviceRepositoryProtocol {
    func saveDevices(_ devices: [Device], to sessionId: UUID) async throws
    func deleteDevices(for sessionId: UUID) async throws
    func deleteAllDevices() async throws
    func fetchDevices(for sessionId: UUID, matching text: String) async throws -> [Device]
}
