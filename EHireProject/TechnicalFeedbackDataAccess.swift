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
    
    let technicalFeedbackmodel:EHTechnicalFeedbackModel?
    init(managerFeedbackModel:EHTechnicalFeedbackModel)
    {
        self.technicalFeedbackmodel = managerFeedbackModel
    }

    
    func insertIntoTechnicalFeedback() -> Bool
    {
        
        let technicalFeedbackentity = EHCoreDataHelper.createEntity("TechnicalFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        let technicalFeedback:ManagerFeedBack = ManagerFeedBack(entity:technicalFeedbackentity!, insertIntoManagedObjectContext:coreDataStack.managedObjectContext) as ManagerFeedBack
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.commentsOnCandidate, forKey: "commentsOnCandidate")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.commentsOnTechnology, forKey: "commentsOnTechnology")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.techLeadName, forKey: "managerName")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.modeOfInterview, forKey: "modeOfInterview")
        
        technicalFeedback.setValue(NSNumber(short: (self.technicalFeedbackmodel?.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        
        technicalFeedback.setValue(NSNumber(short: (self.technicalFeedbackmodel?.ratingOnTechnical)!), forKey: "ratingOnTechnical")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.recommendation, forKey: "recommendation")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.candidate, forKey: "candidate")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.skillSet, forKey: "candidateSkills")
        
        technicalFeedback.setValue(self.technicalFeedbackmodel?.designation, forKey: "designation")
        
        EHCoreDataHelper.saveToCoreData(technicalFeedback)
        
        return true
    }
    
    func fetchFromTechnicalFeedback() -> [AnyObject]
    {
        let predicate = NSPredicate(format:"name = %@" , (self.technicalFeedbackmodel?.candidate?.name)!)
        
        let technicalFeedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "TechnicalFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        
        return technicalFeedbackRecords as! [AnyObject]
        
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
