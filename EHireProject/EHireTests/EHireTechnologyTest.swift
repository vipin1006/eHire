//
//  EHireTechnologyTest.swift
//  EHire
//
//  Created by padalingam agasthian on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

class EHireTechnologyTest: EHCoreData
{

    var technology: Technology?
    var date : Date?
    var entityTechnology:NSEntityDescription?
    var entityDate:NSEntityDescription?
    
    override func setUp()
    {
        super.setUp()
        entityTechnology = NSEntityDescription.entityForName("Technology", inManagedObjectContext: managedObjectContext!)
        technology = Technology(entity: entityTechnology!, insertIntoManagedObjectContext: managedObjectContext)
        entityDate = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedObjectContext!)
        date = Date(entity: entityDate!, insertIntoManagedObjectContext: managedObjectContext)
        XCTAssertNotNil(entityTechnology, "Technology Entity description is not created")
        XCTAssertNotNil(technology, "Technology Entity is not created")
        XCTAssertNotNil(entityDate, "Date Entity description is not created")
        XCTAssertNotNil(date, "Date Entity is not created")
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    override func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock
        {
            // Put the code you want to measure the time of here.
        }
    }
}
