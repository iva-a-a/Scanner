//
//  LottieView.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()

        let animation = LottieAnimation.named(animationName)
        let animationView = LottieAnimationView(animation: animation)

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
