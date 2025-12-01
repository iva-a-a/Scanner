//
//  ScanErrorHandler.swift
//  Scanner
//
//  Created by Alena Ivanova on 28.11.2025.
//


import Foundation
import SwiftUI
internal import Combine

@MainActor
final class ScanErrorHandler: ObservableObject {

    @Published var alert: ScanAlert?

    func handle(_ error: ScanError) {
        alert = ScanAlert(title: error.title, message: error.localizedDescription)
    }

    func handleSuccess(devicesCount: Int) {
        alert = ScanAlert(
            title: "Scan completed",
            message: "Devices found: \(devicesCount)"
        )
    }

    func reset() {
        alert = nil
    }
}
