//
//  DeviceCard.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DeviceCard: View {
    let device: Device

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
                }

                Spacer()

                if let rssi = device.rssi {
                    Text("\(rssi) dBm")
                        .foregroundColor(.success)
                        .font(.caption)
                }
            }
            .frame(minHeight: 70)
        }
    }
}
