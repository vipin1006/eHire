//
//  HrFeedBack.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Foundation
import CoreData


class HrFeedBack: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func hrFeedbackInfo(candidateInfo:[String:AnyObject])->Bool
    {
        
        let appDelegate = AppDelegate.getAppdelegate()
        let managedObjectContext = appDelegate.managedObjectContext
        let hrFeedbackEntity = EHCoreDataHelper.createEntity("HrFeedBack", managedObjectContext: managedObjectContext)
        let candidateHrFeedback = HrFeedBack(entity:hrFeedbackEntity!, insertIntoManagedObjectContext: managedObjectContext)
        
        candidateHrFeedback.businessUnit = candidateInfo["candidateBusinessUnit"] as? String
        candidateHrFeedback.currentEmployerName = candidateInfo["companyName"] as? String
        candidateHrFeedback.currentEmployerFromDate = candidateInfo["previousEmployerFromDate"] as? NSDate
        candidateHrFeedback.currentEmployerToDate = candidateInfo["previousEmployerToDate"] as? NSDate
        candidateHrFeedback.currentLocation = candidateInfo["candidateCurrentLocation"] as? String
        candidateHrFeedback.currentJobType = candidateInfo["currentJobType"] as? String
        candidateHrFeedback.currentDesignation = candidateInfo["currentDesignation"] as? String
        candidateHrFeedback.mobile = candidateInfo["candidateMobile"] as? String
        candidateHrFeedback.emailId = candidateInfo["officialMailid"] as? String
        candidateHrFeedback.educationGap = candidateInfo["educationGapDetails"] as? String
        candidateHrFeedback.reasonFromJobchange = candidateInfo["jobChangeReasons"] as? String
       // candidateHrFeedback.totalItExperience = candidateInfo["candidateTotalItExperience"] as? String
       // candidateHrFeedback.relevantItExperience = candidateInfo["candidateRelevantItExperience"] as? String
        candidateHrFeedback.highestEducationQualificationTitle = candidateInfo["highestEducationQualificationTitle"] as? String
        candidateHrFeedback.highestEducationFromDate = candidateInfo["highestEducationFromDate"] as? String
        candidateHrFeedback.highestEducationToDate = candidateInfo["highestEducationToDate"] as? String
        candidateHrFeedback.highestEducationUniversity = candidateInfo["highestEducationBoardOrUniversity"] as? String
        candidateHrFeedback.highestEducationPercentage = candidateInfo["highestEducationPercentage"] as? String
        candidateHrFeedback.emailId = candidateInfo["highestEducationPercentage"] as? String
        candidateHrFeedback.officialNoticePeriod = candidateInfo["candidateNoticePeriod"] as? String
        candidateHrFeedback.joiningPeriod = candidateInfo["candidateJoinngPeriod"] as? String
        candidateHrFeedback.isAgreeBackgroundCheck = candidateInfo["backgroundCheck"] as? Int
        candidateHrFeedback.isAnyLeavePlan = String(candidateInfo["isAnyLeavePlans"] as? NSNumber)
        candidateHrFeedback.isAnyrelocationRequest = candidateInfo["isRelocationRequested"] as? NSNumber
        candidateHrFeedback.isInterviewPast = String(candidateInfo["isInterviewedBefore"] as? NSNumber)
        candidateHrFeedback.isLegalObligationWithCurrentCompany = candidateInfo["anyLegalObligations"] as? NSNumber
        candidateHrFeedback.isPassportAvailable = candidateInfo["isVisaAvailable"] as? NSNumber
        
        return HrFeedbackDataAccess.saveHrFeedbackForCandidate(candidateHrFeedback)
        
    }
    


}
