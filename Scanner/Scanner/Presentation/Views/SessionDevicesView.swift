//
//  SessionDevicesView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct SessionDevicesView: View {

    let session: ScanSession
    @ObservedObject var vm: HistoryViewModel
    @State private var devices: [Device] = []

    var body: some View {
        DevicesListView(devices: devices)
            .navigationTitle("Devices")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                devices = await vm.loadDevices(for: session)
            }
    }
}

