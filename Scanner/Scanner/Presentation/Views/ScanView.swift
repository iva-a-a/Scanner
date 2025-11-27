//
//  ScanView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI
import SwiftUI

struct ScanView: View {

    @StateObject private var vm: ScanViewModel
    @State private var navigateToResults = false
    @State private var completedSessionId: UUID?

    init() {
        _vm = StateObject(wrappedValue: ViewModelFactory().makeScanViewModel())
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.2), .black.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {

                    if vm.isScanning {
                        ScanProgressView(remainingTime: vm.remainingTime)
                    } else {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                    }

                    Button(vm.isScanning ? "Stop" : "Start scanning") {
                        Task {
                            vm.isScanning ? await vm.stopScanning() : await vm.startScanning()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.isScanning ? .red : .blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .onAppear {
                vm.onScanFinished = { sessionId in
                    completedSessionId = sessionId
                    navigateToResults = true
                }
            }
            .background(
                NavigationLink(
                    destination: ScanResultsView(sessionId: completedSessionId ?? UUID(), vm: vm),
                    isActive: $navigateToResults
                ) { EmptyView() }
            )
            .navigationTitle("Device Search")
        }
    }
}
