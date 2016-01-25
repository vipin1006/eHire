//
//  EHireTechnicalFeedBackTest.swift
//  EHire
//  Here we can perform a crud operation based on the TechnicalFeedBack Model
//  Created by padalingam agasthian on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

class EHireTechnicalFeedBackTest: EHCoreData
{
    //MARK: - Property For Test
    
    var candidate         : Candidate?
    var technicalFeedBack : TechnicalFeedBack?
    var skillSet          : SkillSet?
    
    var entityCandidate   : NSEntityDescription?
    var entityTechnical   : NSEntityDescription?
    var entitySkillSet    : NSEntityDescription?
    
    //MARK: - Overridden Methods
    
    override func setUp()
    {
        super.setUp()
        entityCandidate   = NSEntityDescription.entityForName("Candidate",
            inManagedObjectContext: managedObjectContext!)
        entityTechnical   = NSEntityDescription.entityForName("TechnicalFeedBack",
            inManagedObjectContext: managedObjectContext!)
        entitySkillSet    = NSEntityDescription.entityForName("SkillSet",
            inManagedObjectContext: managedObjectContext!)
        
        candidate         = Candidate(entity: entityCandidate!,
            insertIntoManagedObjectContext: managedObjectContext)
        technicalFeedBack = TechnicalFeedBack(entity: entityTechnical!,
            insertIntoManagedObjectContext: managedObjectContext)
        skillSet          = SkillSet(entity: entitySkillSet!,
            insertIntoManagedObjectContext: managedObjectContext)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    //MARK: - Crud For TechnicalFeedBack
    
    func testCandidateInsertion()
    {
        candidate?.name            = "Peter"
        candidate?.interviewDate   = NSDate()
        candidate?.interviewTime   = NSDate()
        candidate?.requisition     = ""
        candidate?.technologyName  = "Java"
        self.saveTechnicalFeedBack()
    }
    
    func testTechnicalFeedBackInsertion()
    {
        technicalFeedBack?.commentsOnTechnology = "Good In Technical"
        technicalFeedBack?.commentsOnCandidate  = "Good"
        technicalFeedBack?.ratingOnTechnical    = NSNumber.init(int: 4)
        technicalFeedBack?.ratingOnCandidate    = NSNumber.init(int: 4)
        technicalFeedBack?.modeOfInterview      = "Face To Face"
        technicalFeedBack?.designation          = "SE"
        technicalFeedBack?.recommendation       = ""
        technicalFeedBack?.techLeadName         = "Vineet Kumar"
        technicalFeedBack?.candidate            = candidate
        candidate?.interviewedByTechLeads?.setByAddingObject(technicalFeedBack!)
        self.saveTechnicalFeedBack()
    }
    
    func testSkillSetInsertion()
    {
        skillSet?.skillName   = "JSP"
        skillSet?.skillRating = NSNumber.init(int: 4)
        skillSet?.techLead    = technicalFeedBack
        technicalFeedBack?.candidateSkills?.setByAddingObject(skillSet!)
        self.saveTechnicalFeedBack()
    }
    
    func saveTechnicalFeedBack()
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
    
    func testTechnicalFeedBackRetrival()
    {
        let fetchRequest = NSFetchRequest(entityName: "TechnicalFeedBack")
        do
        {
            let technicalFeedBackList = try managedObjectContext?.executeFetchRequest(fetchRequest)
            if technicalFeedBackList == nil
            {
                XCTFail("Manager FeedBack List is nil")
            }
            else
            {
                for technicalFeedBack in (technicalFeedBackList as? [NSManagedObject])!
                {
                    print(technicalFeedBack)
                }
            }
        }
        catch
        {
            XCTFail("Retrival is failed")
        }
    }
    
    func testTechnicalFeedBackEdit()
    {
        technicalFeedBack?.commentsOnTechnology = "Good In Technical"
        technicalFeedBack?.commentsOnCandidate  = "Good"
        technicalFeedBack?.ratingOnTechnical    = NSNumber.init(int: 4)
        technicalFeedBack?.ratingOnCandidate    = NSNumber.init(int: 4)
        technicalFeedBack?.modeOfInterview      = "Face To Face"
        technicalFeedBack?.designation          = "PM"
        technicalFeedBack?.recommendation       = "Nil"
        technicalFeedBack?.techLeadName         = "Vineet Kumar"
        technicalFeedBack?.candidate            = candidate
        candidate?.interviewedByTechLeads?.setByAddingObject(technicalFeedBack!)
        self.saveTechnicalFeedBack()
    }
    
    func testTechnicalFeedBackDeletion()
    {
        managedObjectContext?.deleteObject(technicalFeedBack!)
        self.saveTechnicalFeedBack()
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
