//
//  DeviceListView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DevicesListView: View {
    let devices: [Device]
    let onConnect: (Device) -> Void
    let onDisconnect: (Device) -> Void

    var body: some View {
        ScrollView {
            if devices.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(devices) { device in
                        NavigationLink {
                            DeviceDetailsView(device: device)
                        } label: {
                            DeviceCard(
                                device: device,
                                onConnect: { onConnect(device) },
                                onDisconnect: { onDisconnect(device) }
                            )
                            .contentShape(Rectangle())
                            .frame(minHeight: 70)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 32))
                .foregroundColor(.secondary)

            Text("No devices found")
                .font(.headline)
                .foregroundColor(.primaryText)

            Text("Make sure the device is turned on and try scanning again.")
                .font(.subheadline)
                .foregroundColor(.disabledText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}
