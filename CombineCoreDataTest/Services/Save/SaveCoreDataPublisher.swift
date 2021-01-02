//
//  AddCoreDataPublisher.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 22/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import CoreData
import Combine

extension SaveCoreDataPublisher {
    func saveCoreDataSink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void) -> AnyCancellable {
        
        let subscriber = SaveCoreDataSubscriber<Self.Output, Self.Failure>(receiveCompletion: receiveCompletion)
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}

struct SaveCoreDataPublisher: Publisher {
    typealias Output = Never
    typealias Failure = Error
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Method
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = SaveCoreDataSubscription<S>(context: self.context, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
