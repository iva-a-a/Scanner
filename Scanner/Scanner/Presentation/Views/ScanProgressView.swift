//
//  ScanProgressView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI
import Lottie
import SwiftUI

struct ScanProgressView: View {
    var remainingTime: Int

    var body: some View {
        VStack {
            LottieView(animationName: "radar")
                .frame(height: 180)

            Text("\(remainingTime) sec. left")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 10)
        }
    }
}
