//
//  EHTechnologyDataLayer.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnologyDataLayer: NSObject {
    
    static var technologyArray = [EHTechnology]()
   static let managedObjectContext =  EHCoreDataStack.sharedInstance.managedObjectContext

    //PRAGMAMARK:- Coredata
    // This method loads the saved data from Core data
    class func getSourceListContent() -> NSArray{
        
        //let technologyEntity = EHCoreDataHelper.createEntity("Technology", managedObjectContext: context)
       
        
        let records = EHCoreDataHelper.fetchRecordsWithPredicate(nil, sortDescriptor: nil, entityName: "Technology", managedObjectContext: managedObjectContext)
        
        if records?.count > 0{
            
            
            for aRec in records!{
                
                let aTechnologyEntity = aRec as! Technology
                let children = aTechnologyEntity.interviewDates
                
                //  mapping coredata content to our custom model
                let technologyModel = EHTechnology(technology: aTechnologyEntity.technologyName!)
                
                for object in children!
                {
                    let inDate = object as! Date
                    
                    let dateObject = EHInterviewDate(date: inDate.interviewDate!)
                    technologyModel.interviewDates.append(dateObject)
                }
                technologyArray.append(technologyModel)
            }
        }
        
        return technologyArray as [EHTechnology]
    }
    
    
    class  func addTechnologyToCoreData(techName:String){
        
        //if the sender is nil, there is no parent. THat means a new techonlogy is being added.
        // Adding a new technology in to coredata
        let newTechnologyEntityDescription = EHCoreDataHelper.createEntity("Technology", managedObjectContext: managedObjectContext)
        let newTechnologyManagedObject:Technology = Technology(entity:newTechnologyEntityDescription!, insertIntoManagedObjectContext:managedObjectContext) as Technology
        newTechnologyManagedObject.technologyName = techName
        EHCoreDataHelper.saveToCoreData(newTechnologyManagedObject)
        
    }
    
    class func addInterviewDateToCoreData(parentTechnologyName:String , dateToAdd: NSDate){
        
        let predicate = NSPredicate(format: "technologyName = %@",parentTechnologyName)
        let technologyRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Technology", managedObjectContext: managedObjectContext)
        
        let newDateEntityDescription = EHCoreDataHelper.createEntity("Date", managedObjectContext: managedObjectContext)
        for item in technologyRecords!
        {
            let newDateManagedObject:Date = Date(entity:newDateEntityDescription!, insertIntoManagedObjectContext:managedObjectContext) as Date
            
            newDateManagedObject.interviewDate = dateToAdd
            let technology = item as! Technology
            
            let newDateSet = NSMutableSet(set: technology.interviewDates!)
            newDateSet.addObject(newDateManagedObject)
            technology.interviewDates = newDateSet
            EHCoreDataHelper.saveToCoreData(technology)
        }
        
        
    }
    
    
    class func deleteTechnologyFromCoreData(inTechnologyName:String) {
        
        // deleting technology from coredata
        let predicate = NSPredicate(format: "technologyName = %@",inTechnologyName)
        let records = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Technology", managedObjectContext: managedObjectContext)
        
        for record in records!{
            let aTechnology = record as! Technology
            managedObjectContext.deleteObject(aTechnology)
            EHCoreDataHelper.saveToCoreData(aTechnology)
        }
    }
    
    class func deleteInterviewDateFromCoreData(inInterviewdate:EHInterviewDate) {
        
        // creating predicate to filter the fetching result from core data
        let predicate = NSPredicate(format: "interviewDate = %@",(inInterviewdate.scheduleInterviewDate))
        
        let fetchResults =  EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Date", managedObjectContext: managedObjectContext)
        
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for aInterviewDate in managedObjects {
                managedObjectContext.deleteObject(aInterviewDate)
                EHCoreDataHelper.saveToCoreData(aInterviewDate)
            }
        }
    }

}
