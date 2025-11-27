//
//  FrostedCard.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct FrostedCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(.white.opacity(0.1))
            .frame(minHeight: 60)
            .cornerRadius(15)
            .shadow(color: .white.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
