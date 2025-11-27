//
//  ScanSession.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation

struct ScanSession: Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let type: ScanSessionType
}
