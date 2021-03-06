//
//  AddCoreDataSubscriber.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 22/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import CoreData
import Combine

final class SaveCoreDataSubscriber<Input, Failure: Error>: Subscriber, Cancellable {
    // MARK: - Properties
    private var subscription: Subscription?
    private let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
    
    // MARK: - Init
    init(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void) {
        self.receiveCompletion = receiveCompletion
    }
    
    // MARK: - Public Methods
    func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.max(1))
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        self.receiveCompletion(completion)
    }
    
    func cancel() {
        self.subscription?.cancel()
        self.subscription = nil
    }
}
