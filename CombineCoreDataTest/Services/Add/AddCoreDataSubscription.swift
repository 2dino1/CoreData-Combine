//
//  AddCoreDataSubscription.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 22/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import CoreData
import Combine

final class AddCoreDataSubscription<S: Subscriber>: Subscription where S.Failure == Error, S.Input == Never {
    // MARK: - Properties
    private var subscriber: S?
    private let context: NSManagedObjectContext
    private var currentDemand: Subscribers.Demand
    
    // MARK: - Init
    init(context: NSManagedObjectContext, subscriber: S) {
        self.context = context
        self.subscriber = subscriber
        self.currentDemand = .none
    }
    
    // MARK: - Public Methods
    func request(_ demand: Subscribers.Demand) {
        defer {
            self.cancel()
            self.currentDemand -= 1
        }
        
        self.currentDemand += demand
        guard self.currentDemand > 0 else { return }
        
        guard self.context.hasChanges else {
            self.subscriber?.receive(completion: .finished)
            return
        }
        
        do {
            try self.context.save()
            self.subscriber?.receive(completion: .finished)
        } catch (let error) {
            self.subscriber?.receive(completion: .failure(error))
        }
    }
    
    func cancel() {
        self.subscriber = nil
    }
}
