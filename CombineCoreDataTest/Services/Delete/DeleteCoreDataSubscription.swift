//
//  DeleteCoreDataSubscription.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 02/01/2021.
//  Copyright © 2021 Sima Vlad Grigore. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class DeleteCoreDataSubscription<S: Subscriber>: Subscription, Cancellable where S.Input == Never, S.Failure == Error {
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private let objectIDs: [NSManagedObjectID]
    private let entityName: String
    private var subscriber: S?
    private var currentDemand: Subscribers.Demand
    
    // MARK: - Init
    init(context: NSManagedObjectContext, objectIDs: [NSManagedObjectID], entityName: String, subscriber: S) {
        self.context = context
        self.objectIDs = objectIDs
        self.entityName = entityName
        self.subscriber = subscriber
        self.currentDemand = .none
    }
    
    // MARK: - Public Methods
    func request(_ demand: Subscribers.Demand) {
        defer { self.cancel() }
        
        self.currentDemand += demand
        guard self.currentDemand > 0 else { return }
        self.currentDemand -= 1
        
        let deleteRequest = NSBatchDeleteRequest(objectIDs: self.objectIDs)
        
        do {
            try self.context.execute(deleteRequest)
            self.subscriber?.receive(completion: .finished)
        } catch (let error) {
            self.subscriber?.receive(completion: .failure(error))
        }
    }
    
    func cancel() {
        self.subscriber = nil
    }
}
