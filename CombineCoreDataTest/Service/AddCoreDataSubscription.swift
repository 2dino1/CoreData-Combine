//
//  AddCoreDataSubscription.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 22/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import CoreData
import Combine

final class AddCoreDataSubscription<S: Subscriber>: Subscription where S.Failure == Error, S.Input == Void {
    // MARK: - Properties
    var subscriber: S?
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func request(_ demand: Subscribers.Demand) {
        defer { self.cancel() }
        guard demand > 0 else { return }
        
        guard self.context.hasChanges else {
            self.subscriber?.receive(completion: .finished)
            return
        }
        
        do {
            try self.context.save()
            self.subscriber?.receive(completion: .finished)
        } catch let error {
            self.subscriber?.receive(completion: .failure(error))
        }
    }
    
    func cancel() {
        self.subscriber = nil
    }
}
