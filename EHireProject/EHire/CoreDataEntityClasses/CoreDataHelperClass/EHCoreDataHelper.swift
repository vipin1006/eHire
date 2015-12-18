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
        
        do{
            
            try  managedobj.managedObjectContext?.save()
        }
            
        catch{
            
            return "Error when Saving"
        }
        
        return "Saved"
    }
    
    
    // PRAGMAMARK: - Method to fetch data from coredata
    class func fetchRecords(predi:NSPredicate?,sortDes:NSSortDescriptor?,entity:NSEntityDescription,moc:NSManagedObjectContext)->NSArray?{
        
        var records:[AnyObject]? = nil
        
        let fetch = NSFetchRequest()
        
        fetch.entity = entity
        
        if let x = predi {
            
            
            fetch.predicate = x
            
                   }
        
        if let y = sortDes {
            
            
            
            fetch.sortDescriptors = [y]
        }
        
        do{
            
            records = try moc.executeFetchRequest(fetch)
            
            
        }
            
        catch{
            
            print("error when fetching")
        }
        
        if records?.count > 0{
            
            return records
        }
        else{
            
            return nil
        }
        
    }
    
    
    class func fetchRecordsWithPredicate(predi:NSPredicate?,sortDes:NSSortDescriptor?,entityName:String,moc:NSManagedObjectContext)->NSArray?{
        
        var records:[AnyObject]? = nil
        
        let fetch = NSFetchRequest(entityName: entityName)
        
        fetch.predicate = predi
        
        do{
            
            records = try moc.executeFetchRequest(fetch)
            
            
        }
            
        catch{
            
            print("error when fetching")
        }
        
        if records?.count > 0{
            
            return records
        }
        else{
            
            return nil
        }
        
    }
    
     // PRAGMAMARK: - Method to create NSManaged Object in coredata
    class func createEntity(name:String,moc:NSManagedObjectContext)->NSEntityDescription?{
        
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext:moc)
        
        if entity != nil{
            
            return entity
        }
            
        else{
            
            return nil
        }
        
    }
    
}