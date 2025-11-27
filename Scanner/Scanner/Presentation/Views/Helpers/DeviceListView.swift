//
//  DeviceListView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DevicesListView: View {
    let devices: [Device]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(devices) { device in
                    NavigationLink {
                        DeviceDetailsView(device: device)
                    } label: {
                        DeviceCard(device: device)
                            .contentShape(Rectangle())
                            .frame(minHeight: 70)
                    }
                }
            }
            .padding()
        }
    }
}
