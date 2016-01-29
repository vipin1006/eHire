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

class EHTechnologyDataLayer: NSObject
{
    var technologyArray = [Technology]()
    var managedObjectContext : NSManagedObjectContext?
   
    //PRAGMAMARK:- Coredata
    func getSourceListContent(callBack:SourlistContentReturn)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        { () -> Void in
            let records = EHCoreDataHelper.fetchRecordsWithPredicate(nil, sortDescriptor: nil, entityName: "Technology", managedObjectContext: self.managedObjectContext!)
            self.technologyArray.removeAll()
            if records?.count > 0
            {
                for aRec in records!
                {
                let aTechnologyEntity = aRec as! Technology
                self.technologyArray.append(aTechnologyEntity)
                }
            }
            dispatch_sync(dispatch_get_main_queue()
               ,{ () -> Void in
                      callBack(newArray: self.technologyArray as [Technology])
                })
        }
        
    }
    
    func createNewtech(name:String, andCallBack:TechnologyReturn)
    {
        self.managedObjectContext!.performBlock(
        { () -> Void in
            let entityTechnology         = NSEntityDescription.entityForName("Technology",
                inManagedObjectContext: self.managedObjectContext!)
            let technology = Technology(entity: entityTechnology!,
                insertIntoManagedObjectContext: self.managedObjectContext!)
            technology.technologyName = ""
            andCallBack(newTechnology: technology)
        })

    }
    
    func addTechnologyToCoreData(techObjectToAdd:Technology,andCallBack:InsertReturn)
    {
        techObjectToAdd.managedObjectContext?.performBlock(
            { () -> Void in
                do
                {
                    try techObjectToAdd.managedObjectContext!.save()
                    andCallBack()
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
            })
    }
    
    
    func addInterviewDateToCoreData( parenttechnology:Technology, dateToAdd: NSDate,andCallBack:InsertReturn)
    {
        let tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        tempContext.parentContext = self.managedObjectContext
        tempContext.performBlock(
            { () -> Void in
                let dateEntity = NSEntityDescription.insertNewObjectForEntityForName(String(Date), inManagedObjectContext: tempContext) as? Date
                dateEntity?.interviewDate = dateToAdd
                let emplyeeObjectId = parenttechnology.objectID
                dateEntity?.technologies?.addObject(tempContext.objectWithID(emplyeeObjectId))
                do
                {
                    try tempContext.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            andCallBack()
                    })
                    
                }
                catch
                {
                    print("Error in insertion")
                }
        })
    }
    
    
    func deleteTechnologyFromCoreData(technologyToDelete : Technology,andCallBack:InsertReturn)
    {
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
        }
        
    }
    
    func deleteInterviewDateFromCoreData(technologyObject:Technology,inInterviewdate:Date,andCallBack:InsertReturn)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                inInterviewdate.managedObjectContext?.deleteObject(inInterviewdate)
                    do
                    {
                       try technologyObject.managedObjectContext?.save()
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
    
}
