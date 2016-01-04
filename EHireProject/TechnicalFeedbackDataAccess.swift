//
//  TechnicalFeedbackDataAccess.swift
//  EHire
//
//  Created by Tharani P on 23/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class TechnicalFeedbackDataAccess: NSObject
{
    let coreDataStack = EHCoreDataStack.sharedInstance
    
    func insertIntoTechnicalFeedback(technicalFeedbackmodel : EHTechnicalFeedbackModel, selectedCandidate : Candidate) -> Bool
    {
        let technicalFeedbackentity = EHCoreDataHelper.createEntity("TechnicalFeedBack", managedObjectContext: selectedCandidate.managedObjectContext!)
        let technicalFeedback = TechnicalFeedBack(entity:technicalFeedbackentity!, insertIntoManagedObjectContext:selectedCandidate.managedObjectContext!)
        
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnCandidate, forKey: "commentsOnCandidate")
        
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnTechnology, forKey: "commentsOnTechnology")
        
        technicalFeedback.setValue(technicalFeedbackmodel.techLeadName, forKey: "techLeadName")
        
        technicalFeedback.setValue(technicalFeedbackmodel.modeOfInterview, forKey: "modeOfInterview")
        
        technicalFeedback.setValue(NSNumber(integer: technicalFeedbackmodel.ratingOnCandidate!), forKey: "ratingOnCandidate")
        
        technicalFeedback.setValue(NSNumber(integer: technicalFeedbackmodel.ratingOnTechnical!), forKey: "ratingOnTechnical")
        
        technicalFeedback.setValue(technicalFeedbackmodel.recommendation, forKey: "recommendation")
        
        let candidateDecription = EHCoreDataHelper.createEntity("Candidate", managedObjectContext: coreDataStack.managedObjectContext)
        let candidateObject:Candidate = Candidate(entity:candidateDecription!, insertIntoManagedObjectContext:coreDataStack.managedObjectContext) as Candidate
        candidateObject.name = technicalFeedbackmodel.candidate?.name
        
        technicalFeedback.setValue(selectedCandidate, forKey: "candidate")

        technicalFeedback.candidateSkills = NSMutableSet(array: technicalFeedbackmodel.skills!)
        
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        print(selectedCandidate)
        selectedCandidate.interviewedByTechLeads?.addObject(technicalFeedback)
        EHCoreDataHelper.saveToCoreData(selectedCandidate)
      
        return true
    }
    
    func fetchManagerFeedback(selectedCandidate : Candidate)->[AnyObject]
    {
        let predicate = NSPredicate(format:"candidate.name = %@", (selectedCandidate.name)!)
        
        let feedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "TechnicalFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        if feedbackRecords!.count > 0
        {
        return feedbackRecords as! [AnyObject]
        }
        return []
    }
    
    class func technicalFeedbackDetails(candidateDetails : [String : Any])-> Bool
    {
        let coreDataInstance = EHCoreDataStack.sharedInstance
        let technicalFeedbackEntity = EHCoreDataHelper.createEntity("TechnicalFeedBack", managedObjectContext: coreDataInstance.managedObjectContext)
        let technicalFeedbackDetails = TechnicalFeedBack(entity: technicalFeedbackEntity!, insertIntoManagedObjectContext: coreDataInstance.managedObjectContext)
       
        technicalFeedbackDetails.modeOfInterview = candidateDetails["modeOfInterview"] as? String
        technicalFeedbackDetails.commentsOnCandidate = candidateDetails["commentsOfCandidate"] as? String
        technicalFeedbackDetails.ratingOnTechnical = candidateDetails["assessmentOnTechnologyStarView"] as? NSNumber
        technicalFeedbackDetails.ratingOnCandidate = candidateDetails["assessmentOfCandidateStarView"] as? NSNumber
        technicalFeedbackDetails.commentsOnTechnology = candidateDetails["commentsOnTechnology"] as? String
        technicalFeedbackDetails.recommendation = candidateDetails["recommendation"] as? String
        technicalFeedbackDetails.designation = candidateDetails["designation"] as? String
        technicalFeedbackDetails.techLeadName = candidateDetails["interviewedBy"] as? String
      //  let techFeedback = EHTechnicalFeedbackViewController()
        
      //  technicalFeedbackDetails.candidateSkills = NSSet( array: techFeedback.skillsAndRatingsTitleArray as [AnyObject])
          
        return EHCoreDataHelper.saveToCoreData(technicalFeedbackDetails)
    }
}
