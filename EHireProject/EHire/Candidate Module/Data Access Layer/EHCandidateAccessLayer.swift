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
    class func addCandidate(technologyName:String, interviewDate:NSDate) -> Candidate
    {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        let entityDescription = EHCoreDataHelper.createEntity("Candidate", managedObjectContext: appDelegate.managedObjectContext)
        let managedObject:Candidate = Candidate(entity:entityDescription!, insertIntoManagedObjectContext:appDelegate.managedObjectContext) as Candidate
        EHCoreDataHelper.saveToCoreData(managedObject)
        return managedObject
    }
    
    class func removeCandidate(candidate:Candidate)
    {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.managedObjectContext.deleteObject(candidate)
        EHCoreDataHelper.saveToCoreData(candidate)
    }

    
}
