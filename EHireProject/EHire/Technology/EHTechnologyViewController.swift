//
//  ViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 09/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnologyViewController: NSViewController,NSOutlineViewDelegate,NSOutlineViewDataSource,DataCommunicator,FeedbackDelegate {
    
    @IBOutlet weak var sourceList: NSOutlineView!
   
    var sourceListArray = [EHTechnology]()
    @IBOutlet weak var contentViewOfSourceList: NSView!
    
    var candidatesView:EHCandidateController?
    
    var addTechnology:EHAddTechnology?
    
    var contentPopOver : EHPopOverController?
   
    var popOver:NSPopover = NSPopover()
    
    var selectedTechnology:Int?
    
    var isCandidatesViewLoaded = false
    
    var feedbackViewController:EHFeedbackViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        getSourceListContent()
    }
    
    //PRAGMAMARK: - outlineview datasource  methods
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject
    {
        if let parent = item
            
        {
            switch parent
            {
            case let technology as EHTechnology :
                
                return technology.interviewDates[index]
                
            default :
                
                print("case not found")
            }
            
        }
        return sourceListArray[index]
        
    }
    
    
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool
    {
        if item is EHTechnology{
            
            let technology = item as! EHTechnology
            
            return (technology.interviewDates.count) > 0 ? true : false
        }
        
        return false
    }
    
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int
    {
        if let parent = item
            
        {
            switch parent
            {
            case let technology as EHTechnology :
                
                return technology.interviewDates.count
                
            default :
                
                print("case not found")
            }
            
        }
        return sourceListArray.count
        
    }
    
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        
        switch item{
            
        case  _ as EHTechnology:
            
            print("Its a Technology ")
            
            if isCandidatesViewLoaded{
                
                candidatesView?.view.removeFromSuperview()
                
                print("Removed")
                
                isCandidatesViewLoaded = false
                
            }
            
            
            
        case  _ as EHInterviewDate:
            
            if !isCandidatesViewLoaded{
                
                print("Loaded")
            
            candidatesView = self.storyboard?.instantiateControllerWithIdentifier("candidateObject") as? EHCandidateController
                
            candidatesView?.delegate = self
            
                self.contentViewOfSourceList.addSubview((candidatesView?.view)!)
                
                isCandidatesViewLoaded = true
                
                
            
            }
            
            
            
        default:
            
            print("Never")
            
     }
        
        return true
    }
    
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView?
    {
        
        
        let cell:NSTableCellView?
        if item is EHInterviewDate
        {
            let child = sourceList.makeViewWithIdentifier("child", owner: nil) as! EHInterviewDateCustomCell
            
            let x  = item as! EHInterviewDate
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let dateString = dateFormatter.stringFromDate(x.scheduleInterviewDate)
            child.lblName.stringValue = dateString
            
            cell = child
            
            
        }
        else
        {
            let parent = sourceList.makeViewWithIdentifier("Parent", owner: nil) as! EHTechnologyCustomCell
            
            let x = item as! EHTechnology
            parent.lblParent.stringValue = x.technologyName
            cell = parent
            
        }
        
        return cell
        
    }
    
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat
    {
        
        
        return 50
    
    }
    
   //MARK: - Custom Protocol methods
    
    func sendData<T>(sendingData: T,sender:String)
    {
        
        print(sender)
        
        switch sender{
            
        case "EHire.EHAddTechnology": // adding technology
            
            let newTechnology = sendingData as! String
            let firstTechnology = EHTechnology(technology:newTechnology)
            sourceListArray .append(firstTechnology)
            print(sourceListArray.count)
            addTechnologyAndInterviewDateTocoreData(nil, content: newTechnology)
            sourceList.reloadData()
            
            
        case "EHire.EHPopOverController": // adding interview dates
            
            
            let scheduledDate = sendingData as! NSDate
            let technology = sourceListArray[selectedTechnology!]
            technology.interviewDates.append(EHInterviewDate(date:scheduledDate))
            
            self.sourceList.reloadData()
            addTechnologyAndInterviewDateTocoreData(technology, content: scheduledDate)
            
        default:
            
            print("Nouthing")
            
        }
        
    }
    //PRAGMAMARK: - Segue
    
    override  func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        
        print("Coming here Segue")
        
        addTechnology = segue.destinationController as? EHAddTechnology
        
        self.addTechnology!.delegate = self
        
    }
    
    //PRAGMAMARK: - Button Action
    @IBAction func deleteSelectedDate(sender: NSButton)
    {
        
        
        let selectedChildCell = sender.superview as! EHInterviewDateCustomCell
        
        let selectedDate = self.sourceList.itemAtRow(self.sourceList.rowForView(selectedChildCell)) as! EHInterviewDate
        
        
        let technologyObject = self.sourceList.parentForItem(selectedDate) as! EHTechnology
        
        var count = 0
        for aInterviewDate in technologyObject.interviewDates
        {
            if selectedDate == aInterviewDate
            {
                technologyObject.interviewDates.removeAtIndex(count)
            }
            count++
        }
        
        self.sourceList.reloadData()
        deleteInterviewDateFromCoreData(selectedDate)
    }
    
    
    @IBAction func deleteSelectedTechnology(sender: AnyObject)
    {
        let item = self.sourceList.itemAtRow(self.sourceList.selectedRow)
        
        print(item)
        
        if let someItem = item
        {
            switch someItem
            {
                
            case let technologyObject as EHTechnology:
                
                
                sourceListArray.removeAtIndex(self.sourceList.selectedRow)
                
                self.sourceList.reloadData()
                
                deleteTechnologyFromCoreData(technologyObject.technologyName)
                
            default:
                
                print("Never")
            }
            
        }
    }
    
    @IBAction func addDateAction(button: NSButton)
    {
        popOver = NSPopover()
        
        let selectedTechView = button.superview as! EHTechnologyCustomCell
        
        
        selectedTechnology  =  getTechnologyIndex(selectedTechView)
        
        print (selectedTechnology)
        
        popOver.behavior = NSPopoverBehavior.Transient
        
        contentPopOver = self.storyboard?.instantiateControllerWithIdentifier("popover") as? EHPopOverController
        
        popOver.contentViewController = contentPopOver
        
        contentPopOver!.delegate = self
        
        popOver.showRelativeToRect(button.bounds, ofView:button, preferredEdge:NSRectEdge.MaxX)
        
        print(contentPopOver?.scheduleDatePicker.dateValue)
        
    }
    
    func getTechnologyIndex(inView :EHTechnologyCustomCell) -> Int{
        var selectedIndex = 0
        let selectedTechName = inView.textField?.stringValue
        for var index = 0; index < sourceListArray.count; ++index {
            
            let aTech = sourceListArray[index]  as EHTechnology
            if selectedTechName == aTech.technologyName
            {
                selectedIndex = index
            }
        }
        return selectedIndex
    }
    
    //PRAGMAMARK:- Coredata
    
    func getSourceListContent(){
        
        if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
            let context = appDel.managedObjectContext
            let technologyEntity = EHCoreDataHelper.createEntity("Technology", moc: context)
            
            let records = EHCoreDataHelper.fetchRecords(nil, sortDes: nil, entity: technologyEntity!, moc: context)
            if records?.count > 0{
                
                for aRec in records!{
                    
                    let aTechnologyEntity = aRec as! Technology
                    let childrens = aTechnologyEntity.interviewDates
                    let arr = childrens!.allObjects
                    
                    //  mapping coredata content to our custom model
                    let technologyModel = EHTechnology(technology: aTechnologyEntity.technologyName!)
                    
                    for object in arr
                    {
                        let indate = object as! Date
                        
                        let dateObject = EHInterviewDate(date: indate.interviewDate!)
                        technologyModel.interviewDates.append(dateObject)
                    }
                    sourceListArray.append(technologyModel)
                }
            }
            sourceList.reloadData()
            
        }
    }
    
    func addTechnologyAndInterviewDateTocoreData(sender : AnyObject?,content:AnyObject){
        
        if sender == nil {
            // Adding technology in to coredata
            if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
                let entity1 = EHCoreDataHelper.createEntity("Technology", moc: appDel.managedObjectContext)
                let newTechnology:Technology = Technology(entity:entity1!, insertIntoManagedObjectContext:appDel.managedObjectContext) as Technology
                newTechnology.technologyName = content as? String
                EHCoreDataHelper.saveToCoreData(newTechnology)
            }
            
        }
        else {
            if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
                let moc = appDel.managedObjectContext
                let name:String = (sender?.technologyName)!
                let predi = NSPredicate(format: "technologyName = %@",name)
                let technologyRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predi, sortDes: nil, entityName: "Technology", moc: moc)
                
                let entity2 = EHCoreDataHelper.createEntity("Date", moc: moc)
                for aTechnology in technologyRecords!
                {
                    let dateEntity:Date = Date(entity:entity2!, insertIntoManagedObjectContext:moc) as Date
                    
                    dateEntity.interviewDate = content as? NSDate
                    let technology = aTechnology as! Technology
                    
                    let newSet = NSMutableSet(set: technology.interviewDates!)
                    newSet.addObject(dateEntity)
                    technology.interviewDates = newSet
                    EHCoreDataHelper.saveToCoreData(technology)
                }
            }
        }
    }
    
    func deleteTechnologyFromCoreData(inTechnologyName:String) {
        let appDel = NSApplication.sharedApplication().delegate as! AppDelegate
        
        // deleting technology from coredata
        let predi = NSPredicate(format: "technologyName = %@",inTechnologyName)
        let records = EHCoreDataHelper.fetchRecordsWithPredicate(predi, sortDes: nil, entityName: "Technology", moc: appDel.managedObjectContext)
        
        for aRec in records!{
            let aTechnology = aRec as! Technology
            appDel.managedObjectContext.deleteObject(aTechnology)
            EHCoreDataHelper.saveToCoreData(aTechnology)
        }
    }
    
    func deleteInterviewDateFromCoreData(inInterviewdate:EHInterviewDate) {
        
        let appDel = NSApplication.sharedApplication().delegate as! AppDelegate
        // creating predicate to filter the fetching result from core data
        let predi = NSPredicate(format: "interviewDate = %@",(inInterviewdate.scheduleInterviewDate))
        
        let fetchResults =  EHCoreDataHelper.fetchRecordsWithPredicate(predi, sortDes: nil, entityName: "Date", moc: appDel.managedObjectContext)
        
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for aInterviewDate in managedObjects {
                appDel.managedObjectContext.deleteObject(aInterviewDate)
                EHCoreDataHelper.saveToCoreData(aInterviewDate)
            }
        }
    }
    
    func showFeedbackViewController(){
        
        print("Implement")
        
        for views in self.view.subviews{
            
            views.removeFromSuperview()
            
        }
        
        feedbackViewController = self.storyboard?.instantiateControllerWithIdentifier("feedback") as? EHFeedbackViewController
        
        self.view.addSubview((feedbackViewController?.view)!)
        
        
        
    }
    
}


