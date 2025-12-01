//
//  Device.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//

import Foundation

struct Device: Identifiable, Hashable {
    let id: UUID
    let name: String?
    let identifier: String       // UUID (BT) или IP (LAN)
    let secondaryIdentifier: String?  // MAC (LAN)
    let rssi: Int?               // только BT
    var status: DeviceStatus
    let source: DeviceSource
    let scanSessionId: UUID
}
