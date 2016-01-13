//
//  TechnicalFeedbackDataAccess.swift
//  EHire
//
//  Created by Tharani P on 23/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnicalFeedbackDataAccess: NSObject
{
    let coreDataStack = EHCoreDataStack.sharedInstance
    
    func insertIntoTechnicalFeedback(technicalFeedbackmodel : EHTechnicalFeedbackModel, selectedCandidate : Candidate) -> Bool
    {
        let technicalFeedbackentity = EHCoreDataHelper.createEntity("TechnicalFeedBack", managedObjectContext: selectedCandidate.managedObjectContext!)
        let technicalFeedback       = TechnicalFeedBack(entity:technicalFeedbackentity!, insertIntoManagedObjectContext:selectedCandidate.managedObjectContext!)
        
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnCandidate,  forKey: "commentsOnCandidate")
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnTechnology,  forKey: "commentsOnTechnology")
        technicalFeedback.setValue(technicalFeedbackmodel.techLeadName,          forKey: "techLeadName")
        technicalFeedback.setValue(technicalFeedbackmodel.modeOfInterview,       forKey: "modeOfInterview")
        technicalFeedback.setValue(technicalFeedbackmodel.recommendation,        forKey: "recommendation")
        technicalFeedback.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        technicalFeedback.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnTechnical)!), forKey: "ratingOnTechnical")
        technicalFeedback.setValue(selectedCandidate, forKey: "candidate")
        selectedCandidate.interviewedByTechLeads?.setByAddingObject(technicalFeedback)
        technicalFeedback.setValue((selectedCandidate.interviewedByTechLeads?.count)!, forKey: "id")
        technicalFeedback.candidateSkills = NSMutableSet(array: technicalFeedbackmodel.skills!)
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        technicalFeedback.setValue(technicalFeedbackmodel.isFeedbackSubmitted, forKey: "isFeedbackSubmitted")
    
        EHCoreDataHelper.saveToCoreData(selectedCandidate)
    
        return true
    }
    
    func updateManagerFeedback(candidate:Candidate,technicalFeedback:TechnicalFeedBack,technicalFeedbackmodel : EHTechnicalFeedbackModel)->Bool
    {
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnCandidate, forKey: "commentsOnCandidate")
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnTechnology, forKey: "commentsOnTechnology")
        technicalFeedback.setValue(NSMutableSet(array: (technicalFeedbackmodel.skills)!), forKey: "candidateSkills")
        
        technicalFeedback.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        technicalFeedback.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnTechnical)!), forKey: "ratingOnTechnical")
        technicalFeedback.setValue(technicalFeedbackmodel.modeOfInterview, forKey: "modeOfInterview")
        technicalFeedback.setValue(technicalFeedbackmodel.recommendation, forKey: "recommendation")
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        technicalFeedback.setValue(technicalFeedbackmodel.techLeadName, forKey: "techLeadName")
        technicalFeedback.setValue(candidate, forKey: "candidate")
        technicalFeedback.setValue(technicalFeedbackmodel.isFeedbackSubmitted, forKey: "isFeedbackSubmitted")
        candidate.interviewedByTechLeads?.setByAddingObject(technicalFeedback)
        return EHCoreDataHelper.saveToCoreData(candidate)
    }

}

