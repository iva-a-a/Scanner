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
                NavigationLink {
                    SessionDetailsView(sessionId: session.id)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Scanner: " + session.type.rawValue.capitalized)
                            .font(.headline)
                            .foregroundColor(.primaryText)

                        Text("Start: \(session.startDate.formatted())")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("End: \(session.endDate.formatted())")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("History")
            .task { await vm.loadSessions() }
            .scanAlerts(using: vm.errorHandler)
        }
    }
}
