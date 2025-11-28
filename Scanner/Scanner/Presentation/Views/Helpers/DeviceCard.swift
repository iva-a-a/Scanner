//
//  DeviceCard.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DeviceCard: View {
    let device: Device
    let onConnect: (() -> Void)?
    let onDisconnect: (() -> Void)?

    var body: some View {
        FrostedCard {
            HStack(spacing: 12) {

                DeviceIcon()

                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name ?? "Unknown device")
                        .foregroundColor(.primaryText)
                        .font(.headline)

                    Text(device.identifier)
                        .foregroundColor(.secondaryText)
                        .font(.caption)

                    DeviceStatusBadge(status: device.status)
                        .padding(.top, 2)
                }

                Spacer()

                if device.status == .connected {
                    Button {
                        onDisconnect?()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.error)
                    }
                    .buttonStyle(.borderless)

                } else if device.status == .connecting {
                    ProgressView()
                        .scaleEffect(0.7)

                } else {
                    Button {
                        onConnect?()
                    } label: {
                        Image(systemName: "link.badge.plus")
                            .foregroundColor(.primaryApp)
                    }
                    .buttonStyle(.borderless)
                }

            }
            .frame(minHeight: 70)
        }
    }
}
