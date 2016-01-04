//
//  EHTechnologyDataLayer.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnologyDataLayer: NSObject {
    
    static var technologyArray = [Technology]()
   static let managedObjectContext =  EHCoreDataStack.sharedInstance.managedObjectContext

    //PRAGMAMARK:- Coredata
    // This method loads the saved data from Core data
    class func getSourceListContent() -> NSArray{
        
        let records = EHCoreDataHelper.fetchRecordsWithPredicate(nil, sortDescriptor: nil, entityName: "Technology", managedObjectContext: managedObjectContext)
        
        if records?.count > 0{
            for aRec in records!{
                let aTechnologyEntity = aRec as! Technology
                technologyArray.append(aTechnologyEntity)
            }
        }
        return technologyArray as [Technology]
    }
    
    
    class  func addTechnologyToCoreData(techObjectToAdd:Technology){
        managedObjectContext.insertObject(techObjectToAdd)
        EHCoreDataHelper.saveToCoreData(techObjectToAdd)
    }
    
    class func addInterviewDateToCoreData(parenttechnology
        :Technology, dateToAdd: Date){
            
        parenttechnology.interviewDates?.addObject(dateToAdd)
            
            let newDateSet = NSMutableSet(set: parenttechnology.interviewDates!)
            newDateSet.addObject(dateToAdd)
            parenttechnology.interviewDates = newDateSet
            EHCoreDataHelper.saveToCoreData(parenttechnology)
            
          }
    
    
    class func deleteTechnologyFromCoreData(technologyToDelete : Technology) {
        managedObjectContext.deleteObject(technologyToDelete)
        EHCoreDataHelper.saveToCoreData(technologyToDelete)
    }
    
    class func deleteInterviewDateFromCoreData(inInterviewdate:Date) {
        
        // creating predicate to filter the fetching result from core data
        let predicate = NSPredicate(format: "interviewDate = %@",(inInterviewdate.interviewDate)!)
        
        let fetchResults =  EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Date", managedObjectContext: managedObjectContext)
        
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for aInterviewDate in managedObjects {
                managedObjectContext.deleteObject(aInterviewDate)
                EHCoreDataHelper.saveToCoreData(aInterviewDate)
            }
        }
    }

}
