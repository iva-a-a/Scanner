//
//  ScanSessionMapper.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation

enum ScanSessionMapper {

    static func toDomain(_ entity: ScanSessionEntity) -> ScanSession {
        ScanSession(
            id: entity.id ?? UUID(),
            startDate: entity.startDate ?? Date(),
            endDate: entity.endDate ?? Date(),
            type: ScanSessionType(rawValue: entity.type ?? "bluetooth") ?? .bluetooth
        )
    }
}
