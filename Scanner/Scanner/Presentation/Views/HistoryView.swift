//
//  HistoryView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI
struct HistoryView: View {

    @StateObject private var vm: HistoryViewModel

    init(factory: ViewModelFactory = ViewModelFactory()) {
        _vm = StateObject(wrappedValue: factory.makeHistoryViewModel())
    }

    var body: some View {
        NavigationView {
            List(vm.sessions) { session in
                NavigationLink(
                    destination: SessionDevicesView(session: session, vm: vm)
                ) {
                    VStack(alignment: .leading) {
                        Text(session.type.rawValue.capitalized)
                            .font(.headline)
                        Text("Start: \(session.startDate.formatted())")
                            .font(.subheadline)
                        Text("End: \(session.endDate.formatted())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("History")
            .task { await vm.loadSessions() }
        }
    }
}
