//
//  ScanAlertViewModifier.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//


import SwiftUI

struct ScanAlertViewModifier: ViewModifier {

    @Binding var alert: ScanAlert?

    func body(content: Content) -> some View {
        content
            .alert(item: $alert) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

extension View {
    func scanAlerts(using alert: Binding<ScanAlert?>) -> some View {
        self.modifier(ScanAlertViewModifier(alert: alert))
    }
}
