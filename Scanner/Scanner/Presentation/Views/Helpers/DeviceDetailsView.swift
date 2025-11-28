//
//  DeviceDetailsView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI

struct DeviceDetailsView: View {
    let device: Device

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                DeviceIcon(size: 90)
                    .padding(.top, 40)

                Text(device.name ?? "Unknown device")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)

                FrostedCard {
                    VStack(spacing: 12) {
                        DetailRow(title: "Identifier", value: device.identifier)
                        DetailRow(title: "MAC", value: device.secondaryIdentifier ?? "—")

                        if let rssi = device.rssi {
                            DetailRow(title: "RSSI", value: "\(rssi) dBm")
                        }

                        DetailRow(title: "Source", value: device.source.rawValue)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

