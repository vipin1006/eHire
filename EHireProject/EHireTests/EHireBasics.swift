//
//  EHireBasics.swift
//  EHire
//
//  Created by padalingam agasthian on 17/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

class EHireBasics: XCTestCase {
    
    var application: NSApplication?
    var managedObjectContext: NSManagedObjectContext?

    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        application = NSApplication.sharedApplication()
        let modelURL = NSBundle.mainBundle().URLForResource("EHire", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOfURL:modelURL!)
        let persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        XCTAssertNotNil(persistentCoordinator, "Can not create a persistent co ordinator")
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = persistentCoordinator
    }
    
    func testApplication()
    {
        XCTAssertNotNil(application, "Can not create a application object")
    }
    
    func testTechnologyEntity()
    {
        let technology = NSEntityDescription.entityForName("Technology", inManagedObjectContext: self.managedObjectContext!)
        XCTAssertNotNil(technology, "Technology entity is not created")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
