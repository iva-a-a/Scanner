//
//  ScanError.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//

import Foundation

enum ScanError: LocalizedError, Identifiable {
    var id: String { localizedDescription }

    case bluetoothUnavailable
    case bluetoothPoweredOff
    case networkAccessDenied
    case scanFailed(String)
    case savingFailed
    case permissionDenied
    case unknown

    var errorDescription: String? {
        switch self {
        case .bluetoothUnavailable:
            return "Bluetooth is not available on the device."
        case .bluetoothPoweredOff:
            return "Bluetooth is off."
        case .networkAccessDenied:
            return "There is no access to the local network."
        case .savingFailed:
            return "Data saving error."
        case .permissionDenied:
            return "Access is denied."
        case .scanFailed(let msg):
            return "Scan error: \(msg)"
        case .unknown:
            return "Unknown error."
        }
    }

    var title: String {
        switch self {
        case .scanFailed: return "Error"
        case .savingFailed: return "Saving error"
        case .bluetoothPoweredOff: return "Bluetooth error"
        case .bluetoothUnavailable: return "Bluetooth is unavailable"
        case .networkAccessDenied: return "No access"
        case .permissionDenied: return "Access is denied"
        case .unknown: return "Unknown error"
        }
    }
}
