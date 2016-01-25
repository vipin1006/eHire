//
//  EHTechnologyDataLayer.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

typealias InsertReturn = ()->Void
typealias TechnologyReturn = (newTechnology : Technology) -> Void
typealias SourlistContentReturn = (newArray:NSArray)-> Void
class EHTechnologyDataLayer: NSObject {
    
    var technologyArray = [Technology]()
    var tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
    //    static let managedObjectContext = EHCoreDataStack.sharedInstance.managedObjectContext
    var managedObjectContext : NSManagedObjectContext?
    
    
    
    //PRAGMAMARK:- Coredata
    // This method loads the saved data from Core data
    func getSourceListContent(andCallBack:SourlistContentReturn){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
        let records = EHCoreDataHelper.fetchRecordsWithPredicate(nil, sortDescriptor: nil, entityName: "Technology", managedObjectContext: self.managedObjectContext!)
        self.technologyArray.removeAll()
        if records?.count > 0{
            for aRec in records!{
                let aTechnologyEntity = aRec as! Technology
                self.technologyArray.append(aTechnologyEntity)
            }
        }
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                      
                        andCallBack(newArray: self.technologyArray as [Technology])
                        
                })
               
        }
        
    }
    
    
    
    func createNewtech(name:String, andCallBack:TechnologyReturn) {
        //        let tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        //        if tempContext=nil{
        //
        //        }
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        
        tempContext.performBlock(
            { () -> Void in
                
                
                let technology:Technology = (NSEntityDescription.insertNewObjectForEntityForName(String(Technology), inManagedObjectContext: self.tempContext) as? Technology)!
                technology.technologyName = ""
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        
                        andCallBack(newTechnology: technology)
                })
                
                
                
        })
        
        //        let newTechnologyEntityDescription = NSEntityDescription.entityForName(String(Technology), inManagedObjectContext:tempContext)
        //        let technology:Technology = Technology(entity:newTechnologyEntityDescription!, insertIntoManagedObjectContext:tempContext) as Technology
        
    }
    func addTechnologyToCoreData(techObjectToAdd:Technology,andCallBack:InsertReturn){
        
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        tempContext.performBlock(
            { () -> Void in
                
                self.tempContext.insertObject(techObjectToAdd)
                do
                {
                    print(techObjectToAdd)
                    try techObjectToAdd.managedObjectContext!.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            
                            andCallBack()
                    })
                    
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
        })
    }
    
    
    func addInterviewDateToCoreData( parenttechnology:Technology, dateToAdd: NSDate,andCallBack:InsertReturn){
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                
        let newTechnologyEntityDescription = EHCoreDataHelper.createEntity("Date", managedObjectContext:parenttechnology.managedObjectContext!)
        
        
                
                let newDateManagedObject:Date = Date(entity:newTechnologyEntityDescription!, insertIntoManagedObjectContext:parenttechnology.managedObjectContext!
                    ) as Date
                newDateManagedObject.interviewDate = dateToAdd
                

                
                let newDateSet = NSMutableSet(set: parenttechnology.interviewDates!)
                newDateSet.addObject(newDateManagedObject)
                parenttechnology.interviewDates = newDateSet

                do
                {
                    
                    try parenttechnology.managedObjectContext!.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            
                            andCallBack()
                    })
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
        }
        
        
    }
    
    
    func deleteTechnologyFromCoreData(technologyToDelete : Technology,andCallBack:InsertReturn) {
        
//        if tempContext.parentContext == self.managedObjectContext{
//            
//        }else{
//            tempContext.parentContext = self.managedObjectContext
//        }
//        
//        tempContext.performBlock(
//            { () -> Void in
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                technologyToDelete.managedObjectContext!.deleteObject(technologyToDelete)
                
                do
                {
                    
                    try technologyToDelete.managedObjectContext!.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            
                            andCallBack()
                    })
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
//        })
        }
        
    }
    
    func deleteInterviewDateFromCoreData(technologyObject:Technology,inInterviewdate:Date,andCallBack:InsertReturn) {
        
        // creating predicate to filter the fetching result from core data
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                
//                do
//                {
//                    technologyObject.managedObjectContext!.deleteObject(inInterviewdate)
////                    try aInterviewDate.managedObjectContext!.save()
//                    dispatch_sync(dispatch_get_main_queue()
//                        ,{ () -> Void in
//                            
//                            andCallBack()
//                    })
//                    
//                }
//                    
//                catch let error as NSError
//                {
//                    print(error.localizedDescription)
//                }

                let predicate = NSPredicate(format: "interviewDate = %@",(inInterviewdate.interviewDate)!)
                
                let fetchResults =  EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Date", managedObjectContext: inInterviewdate.managedObjectContext!)
                
                do
                {
                    if let managedObjects = fetchResults as? [NSManagedObject]
                    {
                        for aInterviewDate in managedObjects {
                            
                            self.managedObjectContext!.deleteObject(aInterviewDate)
                            try aInterviewDate.managedObjectContext!.save()
                            dispatch_sync(dispatch_get_main_queue()
                                ,{ () -> Void in
                                    
                                    andCallBack()
                            })
                        }
                        
                    }
                    
                }
                    
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
                
        }
        
//        if tempContext.parentContext == self.managedObjectContext{
//            
//        }else{
//            tempContext.parentContext = self.managedObjectContext
//        }
//        
//        tempContext.performBlock(
//            { () -> Void in
//                
//                let predicate = NSPredicate(format: "interviewDate = %@",(inInterviewdate.interviewDate)!)
//                
//                let fetchResults =  EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Date", managedObjectContext: self.tempContext)
//                
//                do
//                {
//                    if let managedObjects = fetchResults as? [NSManagedObject]
//                    {
//                        for aInterviewDate in managedObjects {
//                            self.tempContext.deleteObject(aInterviewDate)
//                            try self.tempContext.save()
//                            dispatch_sync(dispatch_get_main_queue()
//                                ,{ () -> Void in
//                                    
//                                    andCallBack()
//                            })
//                        }
//                        
//                    }
//
//                    
//                }
//                catch let error as NSError
//                {
//                    print(error.localizedDescription)
//                }
//        })
        
    }
    
}
