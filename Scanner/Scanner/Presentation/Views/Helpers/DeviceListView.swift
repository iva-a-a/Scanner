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
