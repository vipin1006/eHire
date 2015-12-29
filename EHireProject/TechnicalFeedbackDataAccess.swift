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
