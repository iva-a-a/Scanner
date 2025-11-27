//
//  ViewModelFactory.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


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
            bt: container.resolve(BluetoothServiceProtocol.self)!
        )
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(
            sessionRepo: container.resolve(ScanSessionRepositoryProtocol.self)!,
            deviceRepo: container.resolve(DeviceRepositoryProtocol.self)!
        )
    }
}
