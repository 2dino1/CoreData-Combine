//
//  DeleteCoreDataSubscribers.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 02/01/2021.
//  Copyright © 2021 Sima Vlad Grigore. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class DeleteCoreDataSubscriber<Input, Failure: Error>: Subscriber, Cancellable {
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
