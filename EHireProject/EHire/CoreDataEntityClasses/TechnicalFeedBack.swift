//
//  TechnicalFeedBack.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Foundation
import CoreData


class TechnicalFeedBack: NSManagedObject {

    class func technicalFeedbackDetails(candidateDetails : [String : Any])-> Bool
    {
       let appDelegate = AppDelegate.getDelegate()
       let technicalFeedbackEntity = EHCoreDataHelper.createEntity("TechnicalFeedBack", managedObjectContext: appDelegate.managedObjectContext)
       let technicalFeedbackDetails = TechnicalFeedBack(entity: technicalFeedbackEntity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
        technicalFeedbackDetails.commentsOnCandidate = candidateDetails["commentsOfCandidate"] as? String
        technicalFeedbackDetails.commentsOnTechnology = candidateDetails["commentsOnTechnology"] as? String
      return EHCoreDataHelper.saveToCoreData(technicalFeedbackDetails)
    }

}
