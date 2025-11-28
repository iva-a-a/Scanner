//
//  ScanAlertViewModifier.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//


import SwiftUI

struct ScanAlertViewModifier: ViewModifier {

    @ObservedObject var handler: ScanErrorHandler

    func body(content: Content) -> some View {
        content
            .alert(item: Binding(
                get: { handler.alert },
                set: { handler.alert = $0 }
            )) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

extension View {
    func scanAlerts(using handler: ScanErrorHandler) -> some View {
        modifier(ScanAlertViewModifier(handler: handler))
    }
}
