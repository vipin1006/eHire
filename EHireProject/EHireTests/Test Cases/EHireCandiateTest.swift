//
//  EHireCandiateTest.swift
//  EHire
//  Here we can perform a curd operation based on the Candidate Model
//  Created by padalingam agasthian on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

class EHireCandiateTest: EHCoreData
{
    //MARK: - Property For Core Data Models
    
    var technology        : Technology?
    var candidate         : Candidate?
    var managerFeedBack   : ManagerFeedBack?
    var technicalFeedBack : TechnicalFeedBack?
    var personalInfo      : CandidatePersonalInfo?
    var candidateDocument : CandidateDocuments?
    var previousEmployment: CandidatePreviousEmploymentInfo?
    var basicInfo         : CandidateBasicProfessionalInfo?
    var qualification     : CandidateQualification?
    var miscellaneous     : CandidateMiscellaneous?
    
    //MARK: - Property for EntityDescription
    
    var entityTechnology        : NSEntityDescription?
    var entityCandidate         : NSEntityDescription?
    var entityManager           : NSEntityDescription?
    var entityTechnical         : NSEntityDescription?
    var entityPersonalInfo      : NSEntityDescription?
    var entityDocument          : NSEntityDescription?
    var entityPreviousEmployment: NSEntityDescription?
    var entityBasicInfo         : NSEntityDescription?
    var entityQualification     : NSEntityDescription?
    var entityMiscellaneous     : NSEntityDescription?
    
    //MARK: - Overridden Methods
    
    override func setUp()
    {
        super.setUp()
        entityTechnology         = NSEntityDescription.entityForName("Technology",
            inManagedObjectContext: managedObjectContext!)
        entityCandidate          = NSEntityDescription.entityForName("Candidate",
            inManagedObjectContext: managedObjectContext!)
        entityManager            = NSEntityDescription.entityForName("ManagerFeedBack",
            inManagedObjectContext: managedObjectContext!)
        entityTechnical          = NSEntityDescription.entityForName("TechnicalFeedBack",
            inManagedObjectContext: managedObjectContext!)
        entityPersonalInfo       = NSEntityDescription.entityForName("CandidatePersonalInfo", inManagedObjectContext: managedObjectContext!)
        entityDocument           = NSEntityDescription.entityForName("CandidateDocuments",
            inManagedObjectContext: managedObjectContext!)
        entityPreviousEmployment = NSEntityDescription.entityForName("CandidatePreviousEmploymentInfo",
            inManagedObjectContext: managedObjectContext!)
        entityBasicInfo          = NSEntityDescription.entityForName("CandidateBasicProfessionalInfo", inManagedObjectContext: managedObjectContext!)
        entityQualification      = NSEntityDescription.entityForName("CandidateQualification", inManagedObjectContext: managedObjectContext!)
        
        technology         = Technology(entity: entityTechnology!,
            insertIntoManagedObjectContext: managedObjectContext)
        candidate          = Candidate(entity: entityCandidate!,
            insertIntoManagedObjectContext: managedObjectContext)
        managerFeedBack    = ManagerFeedBack(entity: entityManager!,
            insertIntoManagedObjectContext: managedObjectContext)
        technicalFeedBack  = TechnicalFeedBack(entity: entityTechnical!,
            insertIntoManagedObjectContext: managedObjectContext)
        personalInfo       = CandidatePersonalInfo(entity: entityPersonalInfo!, insertIntoManagedObjectContext: managedObjectContext)
        candidateDocument  = CandidateDocuments(entity: entityDocument!,
            insertIntoManagedObjectContext: managedObjectContext)
        previousEmployment = CandidatePreviousEmploymentInfo(entity: entityPreviousEmployment!, insertIntoManagedObjectContext: managedObjectContext)
        basicInfo          = CandidateBasicProfessionalInfo(entity: entityBasicInfo!, insertIntoManagedObjectContext: managedObjectContext)
        qualification      = CandidateQualification(entity: entityQualification!, insertIntoManagedObjectContext: managedObjectContext)
        
        XCTAssertNotNil(entityTechnology, "Technology Entity description is not created")
        XCTAssertNotNil(technology,       "Technology Entity is not created")
        XCTAssertNotNil(entityManager,    "ManagerFeedBack Entity description is not created")
        XCTAssertNotNil(managerFeedBack,  "ManagerFeedBack Entity is not created")
        XCTAssertNotNil(entityCandidate,  "Candidate Entity description is not created")
        XCTAssertNotNil(candidate,        "Candidate Entity is not created")
        XCTAssertNotNil(entityTechnical,  "Technical Feedback Entity description is not created")
        XCTAssertNotNil(technicalFeedBack,"Technical Feedback is not created")
        XCTAssertNotNil(entityQualification,"Qualification Entity description is not created")
        XCTAssertNotNil(qualification,    "qualification is not created")
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - Technology Curd Operation
    
    func testCandidateInsertion()
    {
        technology?.technologyName = "Java"
        candidate?.name            = "Peter"
        candidate?.interviewDate   = NSDate()
        candidate?.interviewTime   = NSDate()
        candidate?.requisition     = ""
        candidate?.technologyName  = technology?.technologyName
        candidate?.technology      = technology
        technology?.candidates?.setByAddingObject(candidate!)
        self.saveCandidate()
    }
    
    func testTechnicalFeedBackInsertion()
    {
        technicalFeedBack?.commentsOnTechnology = ""
        technicalFeedBack?.commentsOnCandidate  = ""
        technicalFeedBack?.ratingOnTechnical    = NSNumber.init(int: 4)
        technicalFeedBack?.ratingOnCandidate    = NSNumber.init(int: 4)
        technicalFeedBack?.modeOfInterview      = "Face To Face"
        technicalFeedBack?.designation          = "SE"
        technicalFeedBack?.recommendation       = ""
        technicalFeedBack?.techLeadName         = "Vineet Kumar"
        technicalFeedBack?.candidate            = candidate
        candidate?.interviewedByTechLeads?.setByAddingObject(technicalFeedBack!)
        self.saveCandidate()
    }
    
    func testManagerFeedBackInsertion()
    {
        managerFeedBack?.commentsOnCandidate  = "Communication Skills is less"
        managerFeedBack?.commentsOnTechnology = "Technology Skills is ok"
        managerFeedBack?.commitments          = ""
        managerFeedBack?.designation          = "SE"
        managerFeedBack?.jestificationForHire = ""
        managerFeedBack?.managerName          = "Pavithra"
        managerFeedBack?.jestificationForHire = "Good Technical knowledge"
        managerFeedBack?.modeOfInterview      = "Face To Face"
        managerFeedBack?.ratingOnCandidate    = NSNumber.init(int: 4)
        managerFeedBack?.ratingOnTechnical    = NSNumber.init(int: 4)
        managerFeedBack?.grossAnnualSalary    = NSNumber.init(int: 300000)
        managerFeedBack?.isCgDeviation        = NSNumber.init(int: 0)
        managerFeedBack?.recommendation       = "Over all performance is fine"
        managerFeedBack?.recommendedCg        = "Nil"
        managerFeedBack?.candidate            = candidate
        candidate?.interviewedByManagers?.setByAddingObject(managerFeedBack!)
        self.saveCandidate()
    }
    
    func testPersonalInfoInsertion()
    {
        personalInfo?.candidateMobile     = "1234567890"
        personalInfo?.candidateName       = candidate?.name
        personalInfo?.currentLocation     = "Bangalore"
        personalInfo?.passport            = NSNumber.init(int: 1234684)
        personalInfo?.visaTypeAndValidity = ""
        personalInfo?.candidate           = candidate
        candidate?.personalInfo           = personalInfo
        self.saveCandidate()
    }
    
    func testCandidateDocumentInsertion()
    {
        candidateDocument?.documentsOfEmploymentAndEducationPresent = NSNumber.init(int: 4)
        candidateDocument?.missingDocumentsOfEmploymentAndEducation = "Nil"
        candidateDocument?.candidate                                = candidate
        candidate?.documentDetails                                  = candidateDocument
        self.saveCandidate()
    }
    
    func testPreviousEmploymentInsertion()
    {
        previousEmployment?.employmentStartsFrom       = NSDate()
        previousEmployment?.employmentEnd              = NSDate()
        previousEmployment?.previousCompany            = "ABC PVT Ltd"
        previousEmployment?.previousCompanyDesignation = "System Analyst"
        previousEmployment?.candidate                  = candidate
        candidate?.previousEmployment                  = previousEmployment
        self.saveCandidate()
    }
    
    func testBasicInfoInsertion()
    {
        basicInfo?.companyName          = "ABC pvt Ltd"
        basicInfo?.currentDesignation   = "Technical Lead"
        basicInfo?.currentJobType       = "Permanent"
        basicInfo?.employmentGap        = "Nil"
        basicInfo?.fixedSalary          = NSNumber.init(int: 400000)
        basicInfo?.variableSalary       = NSNumber.init(int: 0)
        basicInfo?.relevantITExperience = NSNumber.init(int: 4)
        basicInfo?.totalITExperience    = NSNumber.init(int: 4)
        basicInfo?.officialEmailId      = "peter@exilant.com"
        basicInfo?.officialNoticePeriod = "2 Month"
        basicInfo?.primarySkill         = "Java"
        basicInfo?.candidate            = candidate
        candidate?.professionalInfo     = basicInfo
        self.saveCandidate()
    }
    
    func testQualificationInsertion()
    {
        qualification?.educationStartFrom = NSDate()
        qualification?.educationEnd       = NSDate()
        qualification?.educationGap       = "Nil"
        qualification?.highestEducation   = "Engineering"
        qualification?.candidate          = candidate
        candidate?.educationQualification = qualification
        self.saveCandidate()
    }
    
    func testMiscellaneousInsertion()
    {
        miscellaneous?.anyLeavePlanInSixMonths               = NSNumber.init(int: 0)
        miscellaneous?.anyLegalObligationWithCurrentEmployer = NSNumber.init(int: 0)
        miscellaneous?.backgroundVerification                = NSNumber.init(int: 0)
        miscellaneous?.candidateRequestForRelocation         = NSNumber.init(int: 0)
        miscellaneous?.wasInterviewedBefore                  = NSNumber.init(int: 0)
        miscellaneous?.anyPendingBonusFromCurrentEmployer    = "Nil"
        miscellaneous?.businessUnit                          = "Bangalore"
        miscellaneous?.joiningPeriod                         = "1 month"
        miscellaneous?.interviewedBy                         = "Pavithra"
        miscellaneous?.leavePlanInSixMonths                  = "No"
        miscellaneous?.legalObligationWithCurrentEmployer    = "Nil"
        miscellaneous?.reasonForJobChange                    = "Nil"
        miscellaneous?.wasInterviewdBeforeOn                 = nil
        miscellaneous?.candidate                             = candidate
        candidate?.miscellaneousInfo                         = miscellaneous
        self.saveCandidate()
    }
    
    func saveCandidate()
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
    
    func testCandidateRetrival()
    {
        let fetchRequest = NSFetchRequest(entityName: "Candidate")
        do
        {
            let candidateList = try managedObjectContext?.executeFetchRequest(fetchRequest)
            if candidateList == nil
            {
                XCTFail("Candidate List is nil")
            }
            else
            {
                for candidateRetrival in (candidateList as? [NSManagedObject])!
                {
                    print(candidateRetrival)
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
        basicInfo?.companyName          = "ABC pvt Ltd"
        basicInfo?.currentDesignation   = "Technical Lead"
        basicInfo?.currentJobType       = "Permanent"
        basicInfo?.employmentGap        = "Nil"
        basicInfo?.fixedSalary          = NSNumber.init(int: 400000)
        basicInfo?.variableSalary       = NSNumber.init(int: 0)
        basicInfo?.relevantITExperience = NSNumber.init(int: 4)
        basicInfo?.totalITExperience    = NSNumber.init(int: 4)
        basicInfo?.officialEmailId      = "peter@exilant.com"
        basicInfo?.officialNoticePeriod = "2 Month"
        basicInfo?.primarySkill         = "Java With Spring"
        basicInfo?.candidate            = candidate
        candidate?.professionalInfo     = basicInfo
        self.saveCandidate()
    }
    
    func testCandidateDeletion()
    {
        managedObjectContext?.deleteObject(candidate!)
        self.saveCandidate()
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
