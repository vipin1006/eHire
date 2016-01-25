//
//  CoreDataStack.swift
//  EHire
//
//  Created by Vipin Nambiar on 13/01/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa
typealias InitCallBack = ()->Void

class CoreDataStack: NSObject {
    var modelName,dataStoreName: NSString!
    var initCallBack           : InitCallBack?
    var privateContext,managedObjectContext : NSManagedObjectContext?
    
    init(modelName:NSString,dataStoreName:NSString, andCallBack:InitCallBack)
    {
        super.init()
        self.modelName = modelName
        self.dataStoreName = dataStoreName
        self.initCallBack = andCallBack
        self.initializeCoreData()
        
    }
    
    func initializeCoreData()
    {
        if managedObjectContext != nil
        {
            return
        }
        let modelURL         = NSBundle.mainBundle().URLForResource(String(self.modelName), withExtension: "momd")
        let mom              = NSManagedObjectModel(contentsOfURL: modelURL!)
        let cordinator       = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        managedObjectContext = NSManagedObjectContext(concurrencyType:.MainQueueConcurrencyType)
        privateContext       = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        privateContext?.persistentStoreCoordinator = cordinator
        managedObjectContext?.parentContext        = privateContext
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
            { () -> Void in
                let persistentStoreCordinator = self.privateContext?.persistentStoreCoordinator
                var options                   = [NSObject:AnyObject]()
                options[NSMigratePersistentStoresAutomaticallyOption] = true
                options[NSInferMappingModelAutomaticallyOption]       = true
                options[NSSQLitePragmasOption]                        = ["journal_mode":"DELETE"]
                let fileManager = NSFileManager.defaultManager()
                let documentURL = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask).last
                let storeURL    = documentURL?.URLByAppendingPathComponent(String(self.dataStoreName))
                do
                {
                    try  persistentStoreCordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mocDidSaveNotification:"), name: NSManagedObjectContextDidSaveNotification, object: nil)
                if !(self.initCallBack != nil)
                {
                    return
                }
                dispatch_sync(dispatch_get_main_queue(),
                    { () -> Void in
                        self.initCallBack!()
                })
                
        }
    }
    
    func mocDidSaveNotification(notification:NSNotification)
    {
        let savedContext = notification.object
        if savedContext?.parentContext == nil
        {
            return
        }
        if self.privateContext?.persistentStoreCoordinator != savedContext?.persistentStoreCoordinator
        {
            return
        }
        savedContext?.parentContext!?.performBlock({ () -> Void in
            savedContext?.parentContext??.mergeChangesFromContextDidSaveNotification(notification)
            do
            {
                try savedContext?.parentContext?!.save()
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        })
    }
}
