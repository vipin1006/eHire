//
//  EHCandidateAccessLayer.swift
//  EHire
//
//  Created by Pratibha Sawargi on 08/01/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHCandidateAccessLayer: NSObject
{
    class func addCandidate(name:String,experience:String,phoneNumber:String,requisition:String,interviewTime:NSDate, technologyName:String, interviewDate:NSDate) -> Candidate
    {
        
        let entityDescription = EHCoreDataHelper.createEntity("Candidate", managedObjectContext: EHCoreDataStack.sharedInstance.managedObjectContext)
        let managedObject:Candidate = Candidate(entity:entityDescription!, insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext) as Candidate
        managedObject.name = name
        managedObject.phoneNumber = phoneNumber
        managedObject.experience =  experience
        managedObject.interviewTime = interviewTime
        managedObject.requisition = requisition
        managedObject.technologyName = technologyName
        managedObject.interviewDate = interviewDate

        EHCoreDataHelper.saveToCoreData(managedObject)
        return managedObject
    }
    
    class func removeCandidate(candidate:Candidate)
    {
        EHCoreDataStack.sharedInstance.managedObjectContext.deleteObject(candidate)
        EHCoreDataHelper.saveToCoreData(candidate)

    }

    
}
