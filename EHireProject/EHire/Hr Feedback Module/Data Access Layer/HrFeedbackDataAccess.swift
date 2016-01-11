//
//  HrFeedbackDataAccess.swift
//  EHire
//
//  Created by ajaybabu singineedi on 23/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class HrFeedbackDataAccess: NSObject {
    
  
  
     
    class func saveHrFeedbackOfCandidate(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        
    HrFeedbackDataAccess.candidateProfessionalInfo(candidate, candidateInfo: candidateInfo)
    
    HrFeedbackDataAccess.candidatePersonalInfo( candidate, candidateInfo: candidateInfo)
        
    HrFeedbackDataAccess.candidatePreviousEmploymentInfo(candidate, candidateInfo: candidateInfo)
        
    HrFeedbackDataAccess.candidateEducationQualificationInfo(candidate, candidateInfo: candidateInfo)
        
    HrFeedbackDataAccess.candidateDocumentsInfo(candidate, candidateInfo: candidateInfo)
        
    HrFeedbackDataAccess.candidateMiscellaneousInfo(candidate, candidateInfo: candidateInfo)
        
        do
        {
            try candidate.managedObjectContext?.save()
            
            print("Candidate Complete Details are \(candidate)")
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }
    
  class  func candidateProfessionalInfo(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        let professionalInfo = CandidateBasicProfessionalInfo(entity:EHCoreDataHelper.createEntity("CandidateBasicProfessionalInfo", managedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)!,insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
        professionalInfo.primarySkill =  candidateInfo["candidateSkillOrTechnology"] as? String
        professionalInfo.companyName =   candidateInfo["companyName"] as? String
        professionalInfo.currentDesignation = candidateInfo["currentDesignation"] as? String
        professionalInfo.currentJobType = candidateInfo["currentJobType"] as? String
        professionalInfo.officialEmailId = candidateInfo["officialMailid"] as? String
        professionalInfo.employmentGap   = candidateInfo["EmploymentGap"] as? String
        professionalInfo.officialNoticePeriod = candidateInfo["candidateNoticePeriod"] as? String
        professionalInfo.totalITExperience =  NSNumber(float: candidateInfo["candidateTotalItExperience"] as! Float)
        professionalInfo.relevantITExperience = NSNumber(float: candidateInfo["candidateRelevantItExperience"] as! Float)
      
         professionalInfo.fixedSalary = candidateInfo["currentFixedSalary"] as? Float
        
        professionalInfo.variableSalary = candidateInfo["currentSalaryVariable"] as? Float
        
        candidate.professionalInfo = professionalInfo
        
    }
    
  class  func candidatePersonalInfo(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        let personalInfo = CandidatePersonalInfo(entity:EHCoreDataHelper.createEntity("CandidatePersonalInfo", managedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)!,insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
        
        personalInfo.currentLocation = candidateInfo["candidateCurrentLocation"] as? String
        personalInfo.visaTypeAndValidity = candidateInfo["visaTypeAndValidity"] as? String
        personalInfo.passport = candidateInfo["isVisaAvailable"] as? NSNumber
        
        candidate.personalInfo = personalInfo

    }
    
  class  func candidatePreviousEmploymentInfo(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        let previousEmplyomentInfo = CandidatePreviousEmploymentInfo(entity:EHCoreDataHelper.createEntity("CandidatePreviousEmploymentInfo", managedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)!,insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
        
        previousEmplyomentInfo.previousCompany = candidateInfo["companyName"] as? String
        previousEmplyomentInfo.previousCompanyDesignation = candidateInfo["lastDesignation"] as? String
        previousEmplyomentInfo.employmentStartsFrom = candidateInfo["previousEmployerFromDate"] as? NSDate
        previousEmplyomentInfo.employmentEnd = candidateInfo["previousEmployerToDate"] as? NSDate
        
        candidate.previousEmployment = previousEmplyomentInfo
        
    }
    
  class  func candidateEducationQualificationInfo(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        let qualificationInfo = CandidateQualification(entity:EHCoreDataHelper.createEntity("CandidateQualification", managedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)!,insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
        
        qualificationInfo.highestEducation =  candidateInfo["highestEducationQualificationTitle"] as? String
        
        qualificationInfo.educationGap =  candidateInfo["educationGapDetails"] as? String
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        qualificationInfo.educationStartFrom = candidateInfo["highestEducationFromDate"] as? NSDate
        
       
        
        qualificationInfo.educationEnd = candidateInfo["highestEducationToDate"] as? NSDate
        
        print(qualificationInfo.educationStartFrom)
        
        print(qualificationInfo.educationEnd)
        
        qualificationInfo.university = candidateInfo["highestEducationBoardOrUniversity"] as? String
        
        qualificationInfo.percentage = NSNumber(float: candidateInfo["highestEducationPercentage"] as! Float)
        
       
        
        candidate.educationQualification = qualificationInfo
    }

 class   func candidateDocumentsInfo(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        let documentsInfo = CandidateDocuments(entity:EHCoreDataHelper.createEntity("CandidateDocuments", managedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)!,insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
        
        documentsInfo.missingDocumentsOfEmploymentAndEducation = candidateInfo["missingDocuments"] as? String
        documentsInfo.documentsOfEmploymentAndEducationPresent = candidateInfo["isAnyDocumentMissing"] as? NSNumber
        
        candidate.documentDetails = documentsInfo
    }
    
    class func candidateMiscellaneousInfo(candidate:Candidate,candidateInfo:[String:AnyObject])
    {
        
        
        
        let miscellaneousInfo = CandidateMiscellaneous(entity:EHCoreDataHelper.createEntity("CandidateMiscellaneous", managedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)!,insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
        miscellaneousInfo.businessUnit = candidateInfo["candidateBusinessUnit"] as? String
        miscellaneousInfo.leavePlanInSixMonths = candidateInfo["leavePlanReasons"] as? String
        miscellaneousInfo.reasonForJobChange = candidateInfo["jobChangeReasons"] as? String
        miscellaneousInfo.joiningPeriod = candidateInfo["candidateJoinngPeriod"] as? String
        miscellaneousInfo.interviewedBy = candidateInfo["inetrviewedBy"] as? String
        miscellaneousInfo.legalObligationWithCurrentEmployer = candidateInfo["LegalObligations"] as? String
        miscellaneousInfo.candidateRequestForRelocation = candidateInfo["isRelocationRequested"] as? NSNumber
        miscellaneousInfo.backgroundVerification = candidateInfo["backgroundCheck"] as? NSNumber
        miscellaneousInfo.wasInterviewedBefore = candidateInfo["isInterviewedBefore"] as? NSNumber
        miscellaneousInfo.anyLeavePlanInSixMonths = candidateInfo["isAnyLeavePlans"] as? NSNumber
        miscellaneousInfo.anyLegalObligationWithCurrentEmployer = candidateInfo["anyLegalObligations"] as? NSNumber
        miscellaneousInfo.expectedSalary = candidateInfo["expectedSalary"] as? Float
        miscellaneousInfo.questionsByCandidate = candidateInfo["questionsAskedByCandidate"] as? String
       
        miscellaneousInfo.anyPendingBonusFromCurrentEmployer =
            
            String(candidateInfo["entitledBonus"])
        
        miscellaneousInfo.wasInterviewdBeforeOn = candidateInfo["pastInterviewdDate"] as? NSDate
        
        miscellaneousInfo.isHrFormSubmitted = candidateInfo["isHrFormSubmitted"] as? NSNumber
        
        candidate.name =  candidateInfo["candidateName"] as? String
        
        candidate.miscellaneousInfo = miscellaneousInfo
    
    }
 
 
}
