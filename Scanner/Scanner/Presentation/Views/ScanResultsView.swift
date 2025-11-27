//
//  ScanResultsView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct ScanResultsView: View {
    let sessionId: UUID
    @ObservedObject var vm: ScanViewModel

    var body: some View {
        DevicesListView(devices: vm.devices)
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
    }
}
