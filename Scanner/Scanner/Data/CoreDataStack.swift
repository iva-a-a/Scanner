//
//  CoreDataStack.swift
//  Scanner
//
//  Created by Alena Ivanova on 27.11.2025.
//


import Foundation
import CoreData

final class CoreDataStack {

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: "Scanner")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
