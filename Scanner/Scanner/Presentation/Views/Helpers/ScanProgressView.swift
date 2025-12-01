//
//  ScanProgressView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI
import Lottie

struct ScanProgressView: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 16) {
            
            LottieView(animationName: "radar")
                .frame(height: 180)

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(.secondaryApp)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.horizontal, 30)

            Text("\(Int(progress * 100))%")
                .foregroundColor(.secondaryApp)
                .font(.headline)
        }
    }
}
