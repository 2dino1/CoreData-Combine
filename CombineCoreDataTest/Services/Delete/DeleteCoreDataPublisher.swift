//
//  DeleteCoreDataPublisher.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 02/01/2021.
//  Copyright © 2021 Sima Vlad Grigore. All rights reserved.
//

import Foundation
import Combine
import CoreData

extension DeleteCoreDataPublisher {
    func deleteCoreDataSink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void) -> AnyCancellable {
        
        let subscriber = DeleteCoreDataSubscriber<Self.Output, Self.Failure>(receiveCompletion: receiveCompletion)
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}

struct DeleteCoreDataPublisher: Publisher {
    typealias Output = Never
    typealias Failure = Error
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private let objectIDs: [NSManagedObjectID]
    private let entityName: String
    
    // MARK: - Init
    init(context: NSManagedObjectContext, objectIDs: [NSManagedObjectID], entityName: String) {
        self.context = context
        self.objectIDs = objectIDs
        self.entityName = entityName
    }
    
    // MARK: - Public Methods
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = DeleteCoreDataSubscription(context: self.context, objectIDs: self.objectIDs, entityName: self.entityName, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
