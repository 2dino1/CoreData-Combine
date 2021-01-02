//
//  FetchCoreDataPublisher.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 02/01/2021.
//  Copyright © 2021 Sima Vlad Grigore. All rights reserved.
//

import Foundation
import Combine
import CoreData

extension FetchCoreDataPublisher {
    func fetchCoreDataSink(receiveValue: @escaping(Self.Output) -> Void,
                           receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void) -> AnyCancellable {
        
        let subscriber = FetchCoreDataSubscriber<Self.Output, Self.Failure>(receiveValue: receiveValue,
                                                                            receiveCompletion: receiveCompletion)
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}

struct FetchCoreDataPublisher<FetchResultType: NSFetchRequestResult>: Publisher {
    typealias Output = [FetchResultType]
    typealias Failure = Error
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private let entityName: String
    
    // MARK: - Init
    init(context: NSManagedObjectContext, entityName: String) {
        self.context = context
        self.entityName = entityName
    }
    
    // MARK: - Public Methods
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = FetchCoreDataSubscription<S, FetchResultType>(context: self.context, entityName: self.entityName, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
