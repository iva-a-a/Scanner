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
            HStack {
                DeviceIcon()

                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name ?? "Unknown device")
                        .foregroundColor(.white)
                        .font(.headline)

                    Text(device.identifier)
                        .foregroundColor(.gray)
                        .font(.caption)
                }

                Spacer()

                if let rssi = device.rssi {
                    Text("\(rssi) dBm")
                        .foregroundColor(.green.opacity(0.8))
                        .font(.caption)
                }
            }
            .frame(minHeight: 70)
        }
    }
}
