//
//  EHireManagerFeedBackTest.swift
//  EHire
//  Here we can perform a curd operation based on the ManagerFeedBack Model
//  Created by padalingam agasthian on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

class EHireManagerFeedBackTest: EHCoreData
{
    //MARK:- Property For Test
    var candidate       : Candidate?
    var managerFeedBack : ManagerFeedBack?
    var skillSet        : SkillSet?
    
    var entityCandidate : NSEntityDescription?
    var entityManager   : NSEntityDescription?
    var entitySkillSet  : NSEntityDescription?
    
    //MARK: - Overridden Methods
    
    override func setUp()
    {
        super.setUp()
        entityCandidate  = NSEntityDescription.entityForName("Candidate",
            inManagedObjectContext: managedObjectContext!)
         entityManager   = NSEntityDescription.entityForName("ManagerFeedBack",
            inManagedObjectContext: managedObjectContext!)
        entitySkillSet   = NSEntityDescription.entityForName("SkillSet",
            inManagedObjectContext: managedObjectContext!)
        
        candidate        = Candidate(entity: entityCandidate!,
            insertIntoManagedObjectContext: managedObjectContext)
        managerFeedBack  = ManagerFeedBack(entity: entityManager!,
            insertIntoManagedObjectContext: managedObjectContext)
        skillSet         = SkillSet(entity: entitySkillSet!,
            insertIntoManagedObjectContext: managedObjectContext)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    //MARK: - Curd Test For ManagerFeedback
    
    func testCandidateInsertion()
    {
        candidate?.name            = "Peter"
        candidate?.interviewDate   = NSDate()
        candidate?.interviewTime   = NSDate()
        candidate?.requisition     = ""
        candidate?.technologyName  = "Java"
        self.saveManagerFeedBack()
    }
    
    func testManagerFeedBackInsertion()
    {
        managerFeedBack?.commentsOnCandidate  = "Communication Skills is less"
        managerFeedBack?.commentsOnTechnology = "Technology Skills is ok"
        managerFeedBack?.commitments          = ""
        managerFeedBack?.designation          = "SE"
        managerFeedBack?.grossAnnualSalary    = NSNumber.init(int: 300000)
        managerFeedBack?.isCgDeviation        = NSNumber.init(int: 0)
        managerFeedBack?.jestificationForHire = ""
        managerFeedBack?.managerName          = "Pavithra"
        managerFeedBack?.jestificationForHire = "Good Technical knowledge"
        managerFeedBack?.modeOfInterview      = "Face To Face"
        managerFeedBack?.ratingOnCandidate    = NSNumber.init(int: 4)
        managerFeedBack?.ratingOnTechnical    = NSNumber.init(int: 4)
        managerFeedBack?.recommendation       = "Over all performance is fine"
        managerFeedBack?.recommendedCg        = "Nil"
        managerFeedBack?.candidate            = candidate
        candidate?.interviewedByManagers?.setByAddingObject(managerFeedBack!)
        self.saveManagerFeedBack()
    }
    
    func testSkillSetInsertion()
    {
        skillSet?.skillName   = "JSP"
        skillSet?.skillRating = NSNumber.init(int: 4)
        skillSet?.manager     = managerFeedBack
        managerFeedBack?.candidateSkills?.setByAddingObject(skillSet!)
        self.saveManagerFeedBack()
    }
    
    func saveManagerFeedBack()
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
    
    func testManagerFeedBackRetrival()
    {
        let fetchRequest = NSFetchRequest(entityName: "ManagerFeedBack")
        do
        {
            let managerFeedBackList = try managedObjectContext?.executeFetchRequest(fetchRequest)
            if managerFeedBackList == nil
            {
                XCTFail("Manager FeedBack List is nil")
            }
            else
            {
                for managerFeedBack in (managerFeedBackList as? [NSManagedObject])!
                {
                    print(managerFeedBack)
                }
            }
        }
        catch
        {
            XCTFail("Retrival is failed")
        }
    }
    
    func testCandidateEdit()
    {
        managerFeedBack?.commentsOnCandidate  = "Communication Skills is less"
        managerFeedBack?.commentsOnTechnology = "Technology Skills is ok"
        managerFeedBack?.commitments          = ""
        managerFeedBack?.designation          = "PM"
        managerFeedBack?.grossAnnualSalary    = NSNumber.init(int: 300000)
        managerFeedBack?.isCgDeviation        = NSNumber.init(int: 0)
        managerFeedBack?.jestificationForHire = ""
        managerFeedBack?.managerName          = "Pavithra"
        managerFeedBack?.jestificationForHire = "Good Technical knowledge"
        managerFeedBack?.modeOfInterview      = "Face To Face"
        managerFeedBack?.ratingOnCandidate    = NSNumber.init(int: 4)
        managerFeedBack?.ratingOnTechnical    = NSNumber.init(int: 4)
        managerFeedBack?.recommendation       = "Over all performance is fine"
        managerFeedBack?.recommendedCg        = "Nil"
        managerFeedBack?.candidate            = candidate
        candidate?.interviewedByManagers?.setByAddingObject(managerFeedBack!)
        self.saveManagerFeedBack()
    }
    
    func testCandidateDeletion()
    {
        managedObjectContext?.deleteObject(managerFeedBack!)
        self.saveManagerFeedBack()
    }

   //MARK: - Performace Test

    override func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock
        {
            // Put the code you want to measure the time of here.
        }
    }

}
