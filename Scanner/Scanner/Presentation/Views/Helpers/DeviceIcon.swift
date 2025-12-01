//
//  DeviceIcon.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import SwiftUI

struct DeviceIcon: View {
    var size: CGFloat = 28
    let source: DeviceSource

    var body: some View {
        Image(systemName: source == .bluetooth ? "antenna.radiowaves.left.and.right" : "wifi")
            .font(.system(size: size))
            .foregroundStyle(Color.primaryApp)
            .frame(minHeight: size)
    }
}
