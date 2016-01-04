//
//  EHireDateTest.swift
//  EHire
//  Here we can perform a curd operation based on the Date Model
//  Created by padalingam agasthian on 28/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

class EHireDateTest: EHCoreData
{
    //MARK: - Property For Test
    
    var technology      : Technology?
    var date            : Date?
    
    var entityTechnology: NSEntityDescription?
    var entityDate      : NSEntityDescription?
    
    //MARK: - Overridden Methods
    
    override func setUp()
    {
        super.setUp()
        entityTechnology = NSEntityDescription.entityForName("Technology",
            inManagedObjectContext: managedObjectContext!)
        entityDate       = NSEntityDescription.entityForName("Date",
            inManagedObjectContext: managedObjectContext!)
        technology       = Technology(entity: entityTechnology!,
            insertIntoManagedObjectContext: managedObjectContext)
        date             = Date(entity: entityDate!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        XCTAssertNotNil(entityTechnology, "Technology Entity description is not created")
        XCTAssertNotNil(technology,       "Technology Entity is not created")
        XCTAssertNotNil(entityDate,       "Date Entity description is not created")
        XCTAssertNotNil(date,             "Date Entity is not created")
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - Date Curd Operation
    
    func testDateInsertion()
    {
        technology?.technologyName = "Java"
        date?.interviewDate        = NSDate()
        technology?.interviewDates?.setByAddingObject(date!)
        date?.technologies?.setByAddingObject(technology!)
        self.saveDate()
    }
    
    func saveDate()
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
    
    func testDateRetrival()
    {
        let fetchRequest = NSFetchRequest(entityName: "Date")
        do
        {
            let dateList = try managedObjectContext?.executeFetchRequest(fetchRequest)
            if dateList == nil
            {
                XCTFail("DateList is nil")
            }
            else
            {
                for dateRetrival in (dateList as? [NSManagedObject])!
                {
                    print(dateRetrival)
                }
            }
        }
        catch
        {
            XCTFail("Retrival is failed")
        }
    }
    
    func testDateEdit()
    {
        technology?.technologyName = "C++"
        date?.interviewDate        = NSDate()
        technology?.interviewDates?.setByAddingObject(date!)
        date?.technologies?.setByAddingObject(technology!)
        self.saveDate()
    }
    
    func testDateDeletion()
    {
        managedObjectContext?.deleteObject(date!)
        self.saveDate()
    }
    
    //MARK: - Performance Test
    
    override func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock
        {
                // Put the code you want to measure the time of here.
        }
    }

}
