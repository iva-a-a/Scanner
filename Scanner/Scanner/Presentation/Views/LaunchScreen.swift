//
//  LaunchScreen.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI
import Lottie
import SwiftUI

struct LaunchScreen: View {

    @State private var isActive = false

    var body: some View {
        if isActive {
            MainAppView()
        } else {
            VStack {
                LottieView(animationName:"networkLoading")
                    .frame(height: 200)

                Text("Network Analyzer")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .foregroundColor(.primaryApp)

                Text("Scanning Wi-Fi & Bluetooth")
                    .font(.headline)
                    .foregroundColor(.secondaryText)
                    .padding(.top, 4)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { isActive = true }
                }
            }
        }
    }
}
