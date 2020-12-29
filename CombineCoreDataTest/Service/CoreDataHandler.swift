//
//  CoreDataService.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 26/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import CoreData

final class CoreDataHandler {
    // MARK: - Properties
    let persistenceContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    private static var sharedDatabaseService: CoreDataHandler {
        let container = NSPersistentContainer(name: "CombineCoreDataTest")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Could not create Persistance Container object with error \(error)")
            }
        }
        
        return CoreDataHandler(persistenceContainer: container, mainContext: container.viewContext)
    }
    
    // MARK: - Init
    private init(persistenceContainer: NSPersistentContainer, mainContext: NSManagedObjectContext) {
        self.persistenceContainer = persistenceContainer
        self.mainContext = mainContext
    }
    
    static func shatedInstance() -> CoreDataHandler {
        return sharedDatabaseService
    }
}
