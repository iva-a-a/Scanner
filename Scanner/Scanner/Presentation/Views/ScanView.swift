//
//  ScanView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI

struct ScanView: View {

    @StateObject private var vm: ScanViewModel

    init() {
        _vm = StateObject(wrappedValue: ViewModelFactory().makeScanViewModel())
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.background, .backgroudGradient],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    if vm.isScanning {
                        ScanProgressView(progress: vm.progress)
                    } else {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 80))
                            .foregroundColor(.surface)
                            .padding(.top, 20)
                    }
                    
                    
                    Button(vm.isScanning ? "Stop" : "Start scanning") {
                        Task {
                            vm.isScanning ? vm.stopScanning() : vm.startScanning()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.isScanning ? .error : .secondaryApp)
                    .foregroundColor(.surfaceElevated)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Device Search")
        }
        .scanAlerts(using: vm.errorHandler)
    }
}
