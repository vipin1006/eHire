//
//  EHCandidateAccessLayer.swift
//  EHire
//
//  Created by Pratibha Sawargi on 08/01/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa
typealias ReturnClosure = ()->Void
typealias CandidateReturn = (newCandidate : Candidate) -> Void
typealias CandidateListReturn = (recordsArray:NSArray)-> Void
class EHCandidateAccessLayer: NSObject
{
    var tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
    var managedObjectContext : NSManagedObjectContext?
    
    func getCandiadteList(technologyName:String,interviewDate:NSDate,andCallBack:CandidateListReturn){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                
                let predicate = NSPredicate(format:"technologyName = %@ AND interviewDate = %@" , technologyName,interviewDate)
                if let records = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: String(Candidate), managedObjectContext: self.managedObjectContext!){
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        
                        andCallBack(recordsArray:records)
                        
                })
                }else{
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            let emptyArray = []
                            andCallBack(recordsArray:emptyArray)
                            
                    })
                }
                
        }
       
    }
    
    func addCandidate(name:String,experience:NSNumber?,phoneNumber:String,requisition:String,interviewTime:NSDate, technologyName:String, interviewDate:NSDate,andCallBack:CandidateReturn)

    {
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        
        tempContext.performBlock(
            { () -> Void in
                
                
               
                let managedObject:Candidate = (NSEntityDescription.insertNewObjectForEntityForName(String(Candidate), inManagedObjectContext: self.managedObjectContext!) as? Candidate)!
                managedObject.name = name
                managedObject.phoneNumber = phoneNumber
                managedObject.experience =  experience
                managedObject.interviewTime = interviewTime
                managedObject.requisition = requisition
                managedObject.technologyName = technologyName
                managedObject.interviewDate = interviewDate
                do
                {

                try self.managedObjectContext!.save()
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        
                       andCallBack(newCandidate: managedObject)
                })
            }
            
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
                
                
        })
        

    }
    
    func removeCandidate(candidate:Candidate)
    {
        self.managedObjectContext!.deleteObject(candidate)
        EHCoreDataHelper.saveToCoreData(candidate)

    }

    
}
