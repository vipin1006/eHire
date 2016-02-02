//
//  EHTechnologyDataLayer.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

enum CoreDataError : ErrorType
{
    case ReadError,FetchError,RemoveError,EditError,Success
}

typealias InsertHandler     = (error:CoreDataError)->Void
typealias DeleteHandler     = (error:CoreDataError)->Void
typealias TechnologyHandler = (newTechnology : Technology,error:CoreDataError) -> Void
typealias SourlistHandler = (newArray:NSArray,error:CoreDataError)-> Void

class EHTechnologyDataLayer: NSObject
{
    var technologyArray = [Technology]()
    var managedObjectContext : NSManagedObjectContext?
   
    //PRAGMAMARK:- Coredata
    
    /// This method is useful for reading a Technology
    /// List from persistent storage and put in the technologyArray.
    ///
    ///
    /// - Parameter completion: The call back will happen
    ///   once global queue complete the fetching and return back to main thread
    ///
    /// - Note: This will execute only viewDidLoad of EHTechnologyViewController
    func getTechnologyListWith(completion:SourlistHandler)
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
                completion(newArray: self.technologyArray as [Technology],error:CoreDataError.Success)
                })
        }
        
    }
    
    /// This method is useful for create a empty Technology Entity
    /// and put in the technologyArray
    ///
    ///
    /// - Parameter name: Use to have technologyName from ViewController
    ///
    /// - Parameter completion: The call back will happen
    ///   once global queue complete the creation and return back to main thread
    func createEntityWith(name:String, completion:TechnologyHandler)
    {
        self.managedObjectContext!.performBlock(
        { () -> Void in
            let entityTechnology         = NSEntityDescription.entityForName("Technology",
                inManagedObjectContext: self.managedObjectContext!)
            let technology = Technology(entity: entityTechnology!,
                insertIntoManagedObjectContext: self.managedObjectContext!)
            technology.technologyName = ""
            completion(newTechnology: technology,error:CoreDataError.Success)
        })

    }
    
    
    /// This function is used to persist the empty technology which is
    /// selected from ViewController
    ///
    ///
    /// - Parameter technologyEntity: Contains the selected entity
    ///
    /// - Parameter completion: The call back will happen
    ///   once global queue complete the insertion and return back to main thread
    func addTechnologyTo(technologyEntity:Technology,completion:InsertHandler)
    {
        technologyEntity.managedObjectContext?.performBlock(
            { () -> Void in
                do
                {
                    try technologyEntity.managedObjectContext!.save()
                    completion(error: CoreDataError.Success)
                }
                catch _ as NSError
                {
                    completion(error: CoreDataError.EditError)
                }
            })
    }
    
    ///  This function is used to persist the new date entity for the
    ///  selected technology
    ///
    ///
    /// - Parameter technologyEntity: Contains the selected entity
    /// - Parameter withDate: Contains the date which used wish add
    /// - Parameter andCompletion: The call back will happen
    ///   once global queue complete the insertion and return back to main thread
    /// - Note tempContext is mainly used for concurrency
    func addInterviewDateFor(technologyEntity:Technology, withDate: NSDate,andCompletion:InsertHandler)
    {
        let tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        tempContext.parentContext = self.managedObjectContext
        tempContext.performBlock(
            { () -> Void in
                let dateEntity = NSEntityDescription.insertNewObjectForEntityForName(String(Date), inManagedObjectContext: tempContext) as? Date
                dateEntity?.interviewDate = withDate
                let emplyeeObjectId = technologyEntity.objectID
                dateEntity?.technologies?.addObject(tempContext.objectWithID(emplyeeObjectId))
                do
                {
                    try tempContext.save()
                    dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                             andCompletion(error: CoreDataError.Success)
                    })
                    
                }
                catch _ as NSError
                {
                    andCompletion(error: CoreDataError.EditError)
                }
        })
    }
    
    ///  This function is used to remove the technology entity
    ///
    /// - Parameter technologyEntity: Contains the selected entity
    /// - Parameter Completion: The call back will happen after deletion
    ///   once the global queue complete the deletion and return back to main thread
    /// - Note dispatch is mainly used for concurrency
    func removeTechnolgy(technologyEntity:Technology,completion:DeleteHandler)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        { () -> Void in
            technologyEntity.managedObjectContext!.deleteObject(technologyEntity)
            do
            {
                try technologyEntity.managedObjectContext!.save()
                dispatch_sync(dispatch_get_main_queue()
                ,{ () -> Void in
                           completion(error: CoreDataError.Success)
                })
            }
            catch _ as NSError
            {
                completion(error: CoreDataError.RemoveError)
            }
        }
        
    }
    
    ///  This function is used to remove the selected date entity from the
    ///   technology entity
    /// - Parameter technologyEntity: Contains the selected entity
    /// - Parameter forInterview: Contains the date which used wish remove
    /// - Parameter andCompletion: The call back will happen
    ///   once the global queue complete the deletion and return back to main thread
    /// - Note dispatch is mainly used for concurrency
    func removeInterviewDateFrom(technologyObject:Technology,forInterview:Date,andCompletion:DeleteHandler)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                forInterview.managedObjectContext?.deleteObject(forInterview)
                    do
                    {
                       try technologyObject.managedObjectContext?.save()
                            dispatch_sync(dispatch_get_main_queue()
                            ,{ () -> Void in
                        
                            andCompletion(error: CoreDataError.Success)
                            })
                    }
                    catch _ as NSError
                    {
                        andCompletion(error: CoreDataError.RemoveError)
                    }
            }
        }
    
}
