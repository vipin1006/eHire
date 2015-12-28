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
    
    func testTechnologyInsertion()
    {
        technology?.technologyName = "Java"
        date?.interviewDate = NSDate()
        technology?.interviewDates?.setByAddingObject(date!)
        date?.technologies?.setByAddingObject(technology!)
        self.saveTechnology()
    }
    
    func saveTechnology()
    {
        do
        {
            try managedObjectContext?.save()
        }
        catch
        {
            XCTFail("Insertion got failure")
        }
    }
    
    func testTechnologyRetrival()
    {
        let fetchRequest = NSFetchRequest(entityName: "Technology")
        do
        {
            let technologyList = try managedObjectContext?.executeFetchRequest(fetchRequest)
            if technologyList == nil
            {
                XCTFail("BossList is nil")
            }
            else
            {
                for technologyRetrival in (technologyList as? [NSManagedObject])!
                {
                    print(technologyRetrival)
                }
            }
        }
        catch
        {
            XCTFail("Retrival is failed")
        }
    }
    
    func testTechnologyEdit()
    {
        technology?.technologyName = "C++"
        date?.interviewDate = NSDate()
        technology?.interviewDates?.setByAddingObject(date!)
        date?.technologies?.setByAddingObject(technology!)
        self.saveTechnology()
    }
    
    func testTechnologyDeletion()
    {
        managedObjectContext?.deleteObject(technology!)
        self.saveTechnology()
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
