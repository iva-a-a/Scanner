//
//  DetailRow.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondaryText)

            Spacer()

            Text(value)
                .foregroundColor(.primaryText)
        }
        .padding(.vertical, 4)
    }
}
