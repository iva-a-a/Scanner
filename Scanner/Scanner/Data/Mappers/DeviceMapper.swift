//
//  DeviceMapper.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import CoreData

enum DeviceMapper {

    static func toEntity(_ device: Device, context: NSManagedObjectContext, session: ScanSessionEntity) -> DeviceEntity {
        let entity = DeviceEntity(context: context)
        entity.id = device.id
        entity.name = device.name
        entity.identifier = device.identifier
        entity.secondaryIdentifier = device.secondaryIdentifier
        entity.rssi = Int64(device.rssi ?? 0)
        entity.status = device.status.rawValue
        entity.source = device.source.rawValue
        entity.scanSession = session
        return entity
    }

    static func toDomain(_ entity: DeviceEntity) -> Device {
        return Device(
            id: entity.id ?? UUID(),
            name: entity.name,
            identifier: entity.identifier ?? "",
            secondaryIdentifier: entity.secondaryIdentifier,
            rssi: entity.rssi == 0 ? nil : Int(entity.rssi),
            status: DeviceStatus(rawValue: entity.status ?? "discovered") ?? .discovered,
            source: DeviceSource(rawValue: entity.source ?? "bluetooth") ?? .bluetooth,
            scanSessionId: entity.scanSession?.id ?? UUID()
        )
    }
}
