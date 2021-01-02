//
//  FetchCoreDataSubscription.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 02/01/2021.
//  Copyright © 2021 Sima Vlad Grigore. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class FetchCoreDataSubscription<S: Subscriber, FetchResultType: NSFetchRequestResult>: Subscription, Cancellable where S.Failure == Error, S.Input == [FetchResultType] {
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private let entityName: String
    private var subscriber: S?
    private var currentDemand: Subscribers.Demand
    
    // MARK: - Init
    init(context: NSManagedObjectContext, entityName: String, subscriber: S) {
        self.context = context
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
        
        let fetchRequest = NSFetchRequest<FetchResultType>(entityName: entityName)
        do {
            let result = try self.context.fetch(fetchRequest)
            self.currentDemand += self.subscriber?.receive(result) ?? .none
        } catch (let error){
            self.subscriber?.receive(completion: .failure(error))
            return
        }
        
        guard self.currentDemand > 0 else { return }
        self.subscriber?.receive(completion: .finished)
        self.currentDemand -= 1
    }
    
    func cancel() {
        self.subscriber = nil
    }
}
