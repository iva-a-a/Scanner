//
//  NetworkAnalyzerApp.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import SwiftUI
import Swinject

@main
struct NetworkAnalyzerApp: App {

    let container = AppAssembly.shared.container

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
        }
    }
}
