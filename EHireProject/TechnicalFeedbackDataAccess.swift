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
        technicalFeedback.setValue(NSNumber(int: technicalFeedbackmodel.ratingOnCandidate!), forKey: "ratingOnCandidate")
        technicalFeedback.setValue(NSNumber(int: technicalFeedbackmodel.ratingOnTechnical!), forKey: "ratingOnTechnical")
        technicalFeedback.setValue(technicalFeedbackmodel.recommendation, forKey: "recommendation")
        technicalFeedback.setValue(selectedCandidate, forKey: "candidate")
        technicalFeedback.candidateSkills = NSMutableSet(array: technicalFeedbackmodel.skills!)
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        selectedCandidate.interviewedByTechLeads?.setByAddingObject(technicalFeedback)
        technicalFeedback.setValue((selectedCandidate.interviewedByTechLeads?.count)!+1, forKey: "id")
        EHCoreDataHelper.saveToCoreData(selectedCandidate)
        return true
    }
}
