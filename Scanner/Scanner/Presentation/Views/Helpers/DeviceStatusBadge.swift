//
//  DeviceStatusBadge.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//


import SwiftUI

struct DeviceStatusBadge: View {
    let status: DeviceStatus

    var body: some View {
        Text(status.text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.primaryText)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.backgroundColor)
            .cornerRadius(8)
    }
}

extension DeviceStatus {
    var text: String {
        switch self {
        case .discovered: return "discovered"
        case .connecting: return "connecting..."
        case .connected:  return "connected"
        case .failed:     return "failed"
        case .disconnected: return "disconnected"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .connected:
            return .success
        case .connecting:
            return .primaryApp
        case .failed:
            return .error
        case .discovered, .disconnected:
            return .disabledText
        }
    }
}
