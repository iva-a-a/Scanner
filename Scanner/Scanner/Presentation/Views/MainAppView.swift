//
//  MainAppView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI

struct MainAppView: View {

    var body: some View {
        TabView {
            
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "antenna.radiowaves.left.and.right")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
        .accentColor(.primaryApp)
    }
}
