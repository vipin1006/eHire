//
//  EHCoreDataHelper.swift
//  EHire
//
//  Created by Vipin Nambiar on 30/11/15.
//  Copyright © 2015 Pavithra G. Jayanna. All rights reserved.
//

import Foundation
import CoreData

class EHCoreDataHelper {
    
    
    // PRAGMAMARK: - Method to save data in coredata
    
    class  func saveToCoreData(managedobj:NSManagedObject)->String{
        
        do
        {
          try  managedobj.managedObjectContext?.save()
        }
            
        catch
        {
            return "Error when Saving"
        }
        
        return "Saved"
    }
    
    
    // PRAGMAMARK: - Method to fetch data from coredata
    
    class func fetchRecords(predicate:NSPredicate?,sortDescriptor:NSSortDescriptor?,entity:NSEntityDescription,managedObjectContext:NSManagedObjectContext) -> NSArray?
    {
        var records:[AnyObject]? = nil
        
        let fetch = NSFetchRequest()
        
        fetch.entity = entity
        
        if let x = predicate
        {
            fetch.predicate = x
        }
        
        if let y = sortDescriptor
        {
            fetch.sortDescriptors = [y]
        }
        
        do
        {
            records = try managedObjectContext.executeFetchRequest(fetch)
        }
            
        catch
        {
            print("error when fetching")
        }
        
        if records?.count > 0
        {
          return records
        }
        else
        {
            return nil
        }
        
    }
    
    class func fetchRecordsWithPredicate(predicate:NSPredicate?,sortDescriptor:NSSortDescriptor?,entityName:String,managedObjectContext:NSManagedObjectContext) -> NSArray?
    {
        
        var records:[AnyObject]? = nil
        
        let fetch = NSFetchRequest(entityName: entityName)
        
        fetch.predicate = predicate
        
        do
        {
          records = try managedObjectContext.executeFetchRequest(fetch)
        }
            
        catch
        {
            print("error when fetching")
        }
        
        if records?.count > 0
        {
          return records
        }
        else
        {
            return nil
        }
    }
    
     // PRAGMAMARK: - Method to create NSManaged Object in coredata
    class func createEntity(name:String,managedObjectContext:NSManagedObjectContext)->NSEntityDescription?
      {
        
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext:managedObjectContext)
        if entity != nil
        {
            return entity
        }
            
        else
        {
            return nil
        }
    }
}