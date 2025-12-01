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
            .background(Color.surface)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
    }
}
