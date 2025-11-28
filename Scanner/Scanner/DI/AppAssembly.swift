//
//  AppAssembly.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import Swinject
import CoreData

final class AppAssembly {

    static let shared = AppAssembly()
    let container = Container()
    
    private init() {
        registerCoreData()
        registerRepositories()
        registerServices()
    }

    private func registerCoreData() {
        container.register(CoreDataStack.self) { _ in
            CoreDataStack()
        }
        .inObjectScope(.container)
        
        container.register(NSManagedObjectContext.self) { r in
            r.resolve(CoreDataStack.self)!.context
        }
    }

    private func registerRepositories() {
        container.register(ScanSessionRepositoryProtocol.self) { r in
            ScanSessionRepository(context: r.resolve(NSManagedObjectContext.self)!)
        }

        container.register(DeviceRepositoryProtocol.self) { r in
            DeviceRepository(context: r.resolve(NSManagedObjectContext.self)!)
        }
    }

    private func registerServices() {
        container.register(BluetoothServiceProtocol.self) { _ in
            BluetoothService()
        }
        .inObjectScope(.container)
        
        container.register(ScanErrorHandler.self) { _ in
            ScanErrorHandler()
        }
        .inObjectScope(.container)
    }
}
