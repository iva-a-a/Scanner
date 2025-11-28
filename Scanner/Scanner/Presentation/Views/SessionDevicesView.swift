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
    @State private var searchText: String = ""

    var filteredDevices: [Device] {
        guard !searchText.isEmpty else { return devices }
        let lower = searchText.lowercased()
        return devices.filter { ($0.name ?? "").lowercased().contains(lower) }
    }

    var body: some View {
        DevicesListView(devices: filteredDevices)
            .navigationTitle("Devices")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search devices")
            .task {
                devices = await vm.loadDevices(for: session)
            }
    }
}
