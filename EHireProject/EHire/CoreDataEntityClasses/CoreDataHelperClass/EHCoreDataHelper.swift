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
    
    
    //MARK: - Method to save data in coredata
    
    class  func saveToCoreData(managedobj:NSManagedObject)->Bool{
        
        do
        {
          try  managedobj.managedObjectContext?.save()
        }
            
        catch
        {
            return false
        }
        
        return true
    }
    
    

       // PRAGMAMARK: - Method to fetch data from coredata
    
      
    class func fetchRecordsWithPredicate(predicate:NSPredicate?,sortDescriptor:NSSortDescriptor?,entityName:String,managedObjectContext:NSManagedObjectContext) -> NSArray?
    {
        
        var records:[AnyObject]? = nil
        
        let fetch = NSFetchRequest(entityName: entityName)
        if predicate != nil{
            fetch.predicate = predicate
        }
        
        do{
            records = try managedObjectContext.executeFetchRequest(fetch)
        }
            
        catch{
        }
        
        if records?.count > 0{
            return records
        }
        
        return nil
        
    }
    
    class func deleteEntity(managedObjectContext:NSManagedObjectContext,managedObject:NSManagedObject) {
       
            managedObjectContext.deleteObject(managedObject)
        
       
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