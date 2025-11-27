//
//  DeviceRepository.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
import CoreData

final class DeviceRepository: DeviceRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveDevices(_ devices: [Device], to sessionId: UUID) async throws {
 
        try await context.perform {

            let request: NSFetchRequest<ScanSessionEntity> = ScanSessionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)

            guard let sessionEntity = try self.context.fetch(request).first else {
                throw NSError(domain: "SessionNotFound", code: 404)
            }

            devices.forEach {
                _ = DeviceMapper.toEntity($0, context: self.context, session: sessionEntity)
            }

            try self.context.save()
        }
    }

    func fetchDevices(for sessionId: UUID) async throws -> [Device] {
        try await context.perform {
            let request: NSFetchRequest<DeviceEntity> = DeviceEntity.fetchRequest()
            request.predicate = NSPredicate(format: "scanSession.id == %@", sessionId as CVarArg)

            let result = try self.context.fetch(request)
            return result.map(DeviceMapper.toDomain(_:))
        }
    }

    func deleteDevices(for sessionId: UUID) async throws {
        try await context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceEntity")
            request.predicate = NSPredicate(format: "scanSession.id == %@", sessionId as CVarArg)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try self.context.execute(deleteRequest)

            try self.context.save()
        }
    }

    func deleteAllDevices() async throws {
        try await context.perform { [self] in
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            try self.context.execute(deleteRequest)
            try context.save()
        }
    }
}
