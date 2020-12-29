//
//  AddCoreDataPublisher.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 22/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import CoreData
import Combine

extension Publisher {
    func addCoreDataSink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void,
                         receiveValue: @escaping (Self.Output) -> Void) -> AnyCancellable {
        
        let subscriber = AddCoreDataSubscriber(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}

struct AddCoreDataPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Error
    
    // MARK: - Properties
    let context: NSManagedObjectContext
    
    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = AddCoreDataSubscription<S>(context: self.context)
        subscriber.receive(subscription: subscription)
    }
}
