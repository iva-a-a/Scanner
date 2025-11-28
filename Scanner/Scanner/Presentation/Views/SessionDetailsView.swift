//
//  SessionDetailsView.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//

import SwiftUI

struct SessionDetailsView: View {

    @StateObject private var vm: SessionDetailsViewModel
    
    init(sessionId: UUID, factory: ViewModelFactory = ViewModelFactory()) {
        _vm = StateObject(wrappedValue: factory.makeSessionDetailsViewModel(sessionId: sessionId))
    }

    var body: some View {
        DevicesListView(
            devices: vm.devices,
            onConnect: { vm.connect($0) },
            onDisconnect: { vm.disconnect($0) }
        )
        .task { await vm.loadDevices() }
        .navigationTitle("Devices")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.ignoresSafeArea())
        .onAppear {
            vm.syncStatuses()
        }
    }
}
