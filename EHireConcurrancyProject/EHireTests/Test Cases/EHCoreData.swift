//
//  EHCoreData.swift
//  EHire
//  This class is mainly used for core data stack stack
//  and i created persistent store type as Inmemory
//  Created by padalingam agasthian on 21/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.

import XCTest

@testable import EHire

class EHCoreData: XCTestCase
{
    //MARK: - Core Date Properties
    
    lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = NSBundle.mainBundle().URLForResource("EHire", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? =
    {
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application’s saved data."
        do
        {
            var persistenceStore = try coordinator?.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        }
        catch
        {
            print("Problem in creating a persistence store")
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? =
    {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil
        {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //MARK: - Overridden Methods
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        managedObjectContext = nil
    }

    func testExample()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //MARK: - Performance Measure

    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock
        {
            // Put the code you want to measure the time of here.
        }
    }

}
