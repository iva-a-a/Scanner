//
//  ViewModelFactory.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
import Swinject

final class ViewModelFactory {

    private let container: Container

    init(container: Container = AppAssembly.shared.container) {
        self.container = container
    }

    func makeScanViewModel() -> ScanViewModel {
        ScanViewModel(
            sessionRepo: container.resolve(ScanSessionRepositoryProtocol.self)!,
            deviceRepo: container.resolve(DeviceRepositoryProtocol.self)!,
            scanService: container.resolve(ScanServiceProtocol.self)!,
            errorHandler: container.resolve(ScanErrorHandler.self)!
        )
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(
            sessionRepo: container.resolve(ScanSessionRepositoryProtocol.self)!,
            errorHandler: container.resolve(ScanErrorHandler.self)!
        )
    }
    
    func makeSessionDetailsViewModel(sessionId: UUID) -> SessionDetailsViewModel {
        SessionDetailsViewModel(
            sessionId: sessionId,
            deviceRepo: container.resolve(DeviceRepositoryProtocol.self)!,
            bt: container.resolve(BluetoothServiceProtocol.self)!,
            errorHandler: container.resolve(ScanErrorHandler.self)!
        )
    }
}

