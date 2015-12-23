//
//  Candidate.swift
//  EHire
//
//  Created by ajaybabu singineedi on 23/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Foundation
import CoreData


class Candidate: NSManagedObject {

// Insert code here to add functionality to your managed object subclass...
// Insert code here to add functionality to your managed object subclass...
    class func getCandidateInformation(candidateInfo:[String:AnyObject]) -> Bool
    {
        
        let appDelegate = AppDelegate.getAppdelegate()
        
        let entity = NSEntityDescription.entityForName("Candidate", inManagedObjectContext:appDelegate.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! Candidate
        person.name = candidateInfo["CandidateName"] as? String
        //person.interviewTime = candidateInfo["CandidateInterviewTime"] as? NSDate
        return EHCoreDataHelper.saveToCoreData(person)
        
        
    }

}
