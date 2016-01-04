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
        technicalFeedback.setValue(selectedCandidate, forKey: "candidate")
        technicalFeedback.candidateSkills = NSMutableSet(array: technicalFeedbackmodel.skills!)
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        
        let candidateDecription = EHCoreDataHelper.createEntity("Candidate", managedObjectContext: selectedCandidate.managedObjectContext!)
        let candidateObject:Candidate = Candidate(entity:candidateDecription!, insertIntoManagedObjectContext:coreDataStack.managedObjectContext) as Candidate
        candidateObject.name = technicalFeedbackmodel.candidate?.name
        
        selectedCandidate.interviewedByTechLeads?.addObject(technicalFeedback)
        EHCoreDataHelper.saveToCoreData(selectedCandidate)
      
        return true
    }
    
    func fetchFeedback(selectedCandidate : Candidate)->[AnyObject]
    {
        let predicate = NSPredicate(format:"candidate.name = %@", (selectedCandidate.name)!)
        
        let feedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "TechnicalFeedBack", managedObjectContext: selectedCandidate.managedObjectContext!)
        if feedbackRecords != nil
        {
         return feedbackRecords as! [AnyObject]
        }
        return []
    }
}
