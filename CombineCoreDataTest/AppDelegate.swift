//
//  AppDelegate.swift
//  CombineCoreDataTest
//
//  Created by Sima Vlad Grigore on 20/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import UIKit
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    private var subscriber: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        self.insertPerson()
        (0...6).publisher.subscribe(IntSubscriber())
        
        [1, 2, 3].publisher
            .print()
            .flatMap({ int in
                return Array(repeating: int, count: 2).publisher
            })
            .sink(receiveValue: { value in
                print("got: \(value)")
            })
        
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func insertPerson() {
        CoreDataHandler.shatedInstance().persistenceContainer.performBackgroundTask { (context) in
            let person = Person(context: context)
            person.name = "Sima"
            person.surname = "Vlad"
            person.age = 35
            
            let publisher = AddCoreDataPublisher(context: context)
            self.subscriber = publisher.addCoreDataSink(receiveCompletion: { (completionResult) in
                switch completionResult {
                case .finished:
                    print("Finished with success")
                case .failure(let error):
                    print("Finished with error \(error)")
                }
            }, receiveValue: {})
        }
    }
}

final class SecondViewController {
    func viewDidLoad() {
        CoreDataHandler.shatedInstance().mainContext
    }
}

class IntSubscriber: Subscriber {
  typealias Input = Int
  typealias Failure = Never

  func receive(subscription: Subscription) {
    print("Received subscription")
    subscription.request(.unlimited)
  }

  func receive(_ input: Input) -> Subscribers.Demand {
    print("Received input: \(input)")
    return .none
  }

  func receive(completion: Subscribers.Completion<Never>) {
    print("Received completion: \(completion)")
  }
}
