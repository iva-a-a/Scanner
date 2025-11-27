//
//  DeviceIcon.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DeviceIcon: View {
    var size: CGFloat = 28

    var body: some View {
        Image(systemName: "antenna.radiowaves.left.and.right")
            .font(.system(size: size))
            .foregroundStyle(.blue)
            .frame(minHeight: size)
    }
}
