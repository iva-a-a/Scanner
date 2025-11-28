//
//  ScanSessionRepository.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation
import CoreData

final class ScanSessionRepository: ScanSessionRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createSession(type: ScanSessionType) async throws -> UUID {
        try await context.perform {
            let entity = ScanSessionEntity(context: self.context)
            entity.id = UUID()
            entity.startDate = Date()
            entity.type = type.rawValue
            
            try self.context.save()
            return entity.id!
        }
    }

    func updateSessionEndDate(_ id: UUID, endDate: Date) async throws {
        try await context.perform {
            let request: NSFetchRequest<ScanSessionEntity> = ScanSessionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            if let entity = try self.context.fetch(request).first {
                entity.endDate = endDate
                try self.context.save()
            }
        }
    }

    func fetchSessions() async throws -> [ScanSession] {
        let result = try await context.perform {
            let request: NSFetchRequest<ScanSessionEntity> = ScanSessionEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "startDate", ascending: false)
            ]

            return try self.context.fetch(request)
        }
        return result.map(ScanSessionMapper.toDomain)
    }

    func deleteSession(id: UUID) async throws {
        try await context.perform {
            let request: NSFetchRequest<ScanSessionEntity> = ScanSessionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            if let entity = try self.context.fetch(request).first {
                self.context.delete(entity)
                try self.context.save()
            }
        }
    }

    func deleteAllSessions() async throws {
        try await context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ScanSessionEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            try self.context.execute(deleteRequest)
            try self.context.save()
        }
    }
}
