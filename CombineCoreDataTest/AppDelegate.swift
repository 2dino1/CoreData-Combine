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
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        self.insertPerson()
        self.fetchPersons()
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
            
            let publisher = SaveCoreDataPublisher(context: context)
            publisher.sink { (completionResult) in
                
            } receiveValue: { _ in }.store(in: &self.subscribers)
        }
    }
    
    private func fetchPersons() {
        let publisher = FetchCoreDataPublisher<Person>(context: CoreDataHandler.shatedInstance().mainContext, entityName: "Person")
        publisher.fetchCoreDataSink { (values) in
            print("Values \(values)")
        } receiveCompletion: { (completionResult) in
            print("Completion result is \(completionResult)")
        }.store(in: &self.subscribers)
    }
}

//protocol CoreDataConvertible {
//    func fromCoreData(object: NSManagedObject) -> Self
//    func toCoreData() -> Self
//}
//
//class Magic {
//    let objects: [CustomObject] = []
//}

//struct CustomObject: CoreDataConvertible {
//    func transform(object: NSManagedObject) -> CustomObject {
//        let object = CustomObject()
//        return object
//    }
//
//    let id: NSManagedObjectID
//}
//
//extension CustomObject: Equatable {
//
//}
