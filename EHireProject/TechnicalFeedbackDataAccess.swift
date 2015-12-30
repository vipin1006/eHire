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
//    var commentsOnCandidate: String?
//    var commentsOnTechnology: String?
//    var techLeadName: String?
//    var modeOfInterview: String?
//    var ratingOnCandidate: Int16?
//    var ratingOnTechnical: Int16?
//    var recommendation: String?
//    var candidate: EHCandidateDetails?
//    var skills : [EHSkillSetModel] = []
//    var designation: String?
    let coreDataStack = EHCoreDataStack.sharedInstance
    
    func insertIntoTechnicalFeedback(technicalFeedbackmodel : EHTechnicalFeedbackModel) -> Bool
    {
        let technicalFeedbackentity = EHCoreDataHelper.createEntity("TechnicalFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        let technicalFeedback = TechnicalFeedBack(entity:technicalFeedbackentity!, insertIntoManagedObjectContext:coreDataStack.managedObjectContext)
        
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnCandidate, forKey: "commentsOnCandidate")
        
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnTechnology, forKey: "commentsOnTechnology")
        
        technicalFeedback.setValue(technicalFeedbackmodel.techLeadName, forKey: "techLeadName")
        
        technicalFeedback.setValue(technicalFeedbackmodel.modeOfInterview, forKey: "modeOfInterview")
        
        technicalFeedback.setValue(NSNumber(integer: technicalFeedbackmodel.ratingOnCandidate!), forKey: "ratingOnCandidate")
        
        technicalFeedback.setValue(NSNumber(integer: technicalFeedbackmodel.ratingOnTechnical!), forKey: "ratingOnTechnical")
        
        technicalFeedback.setValue(technicalFeedbackmodel.recommendation, forKey: "recommendation")
        
       // technicalFeedback.setValue(technicalFeedbackmodel.candidate, forKey: "candidate")
        
        technicalFeedback.candidateSkills?.setByAddingObjectsFromArray(technicalFeedbackmodel.skills!)
        print(technicalFeedback.candidateSkills)
        
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        
        EHCoreDataHelper.saveToCoreData(technicalFeedback)
       
       // fetchFromTechnicalFeedback(technicalFeedbackmodel)
        
        return true
    }
    
    func fetchFromTechnicalFeedback(technicalFeedbackmodel : EHTechnicalFeedbackModel) -> [AnyObject]
    {
        let predicate = NSPredicate(format:"name = %@" , (technicalFeedbackmodel.candidate?.name)!)
        
        let technicalFeedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "TechnicalFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        print(technicalFeedbackRecords)
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
