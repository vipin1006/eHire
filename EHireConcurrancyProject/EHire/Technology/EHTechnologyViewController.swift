//
//  EHTechnologyViewController.swift
//  EHire
//  This is the ViewController for handling Technology list and Dates. This is the delegate for Date popover and AddTechnology sheet.
//  This is a data source for the Outline view.
//
//  Created by ajaybabu singineedi on 09/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa
//typealias InsertReturn = ()->Void
class EHTechnologyViewController: NSViewController,NSOutlineViewDelegate,NSOutlineViewDataSource,DataCommunicator,FeedbackDelegate,NSTextFieldDelegate,FeedbackControllerDelegate{
    
    var managedObjectContext : NSManagedObjectContext?
    
    @IBOutlet weak var welcomeImage: NSImageView!
    // Technology View
    @IBOutlet weak var sourceList: NSOutlineView!
    
    //@IBAction func addDateAction(sender: AnyObject) {
    //}
    //Set the content of source list in the outlineVew as the technology list/array
    var technologyArray = [Technology]()
    
    var selectedTechnologyIndex:Int?
    
    // Add Interview Date
    var datePopOverController : EHPopOverController?
    var datePopOver:NSPopover = NSPopover()
    var contextSelectedTechnologyIndex:Int = -1
    
    //View for listing the canditates
    @IBOutlet weak var candidateView        : NSView!
    @IBOutlet weak var addDate              : NSButton!
    @IBOutlet weak var deleteTechnologyDate : NSButton!
    @IBOutlet weak var addTechnology        : NSButton!
    
    var candidateController:EHCandidateController?
    var isCandidatesViewLoaded = false
    
    let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    //Feedback View related
    var feedbackViewController:EHFeedbackViewController?
    
    var cellTechnology:EHTechnologyCustomCell?
    var lastCellAddedForTechnology:EHTechnologyCustomCell?
    var technologyDataLayer : EHTechnologyDataLayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        technologyDataLayer = EHTechnologyDataLayer()
        technologyDataLayer!.managedObjectContext = self.managedObjectContext!
//    technologyArray = technologyDataLayer!.getSourceListContent() as! [Technology]
        technologyDataLayer?.getSourceListContent({(newArray)->Void in
            self.technologyArray = newArray as! [Technology]
            self.sortedSourceListReload()
            })
    candidateController = self.storyboard?.instantiateControllerWithIdentifier("EHCandidateController") as? EHCandidateController
        
        
        deleteTechnologyDate.toolTip = "Delete Date or Technology"
        deleteTechnologyDate.enabled = false
        addDate.enabled = false
    
        
           //self.sourceList.reloadData()
        
    }
    //Mark : Technology name sorting method
    func sortedSourceListReload()
    {
        technologyArray = technologyArray.sort({$0.technologyName < $1.technologyName})
        print(technologyArray)
        self.sourceList.reloadData()

    }
    
    //PRAGMAMARK: - outlineview datasource  methods
    //This datasource method returns the child at a given index
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject
    {
        // it 'item' is nil, technology has to be returned. Else, item's(technology) child(date) at that index has to be returned.
        if   item != nil
        {
            if item is Technology{
                let technology = item as! Technology
                let allObjectsAraay = technology.interviewDates?.allObjects
                
                return allObjectsAraay![index]
            }
        }
         print(self.technologyArray[0].technologyName)
        return self.technologyArray[index]
    }
    
    
    // This datasource method returns true if the item(technology) has any children(date)
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool
    {
        if item is Technology{
            let technology = item as! Technology
            return (technology.interviewDates!.count) > 0 ? true : false
        }
        return false
    }
//    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
//        return true
//    }
    
    // This datasource method returns the count of items (when called for parent/technology)
    // or number of children(dates) when called for interview dates.
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int
    {
        if   item != nil
        {
            if item is Technology{
                let technology = item as! Technology
                return technology.interviewDates!.count
            }
        }
        return technologyArray.count
    }
    
    //PRAGMAMARK: - outlineview delegate  methods
    //This delegate method sets isCandidatesViewLoaded based on which item (technology/date) is selected.
    
    //
    func outlineViewSelectionIsChanging(notification: NSNotification)
    {
        if let _ = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
        {
            
            addDate.enabled = true
            addTechnology.enabled = false
            
        }
        else
        {
            addDate.enabled = false
            addTechnology.enabled = true
        }
    }
    
    //MARK:- Outline view delegate method
    func outlineViewSelectionDidChange(notification: NSNotification)
    {
        print(notification.object?.selectedRow)
        if let selectedItem = sourceList.itemAtRow((notification.object?.selectedRow)!) as? Technology{
            let notificationObject = notification.object
            cellTechnology = notificationObject?.viewAtColumn(0, row: (notification.object?.selectedRow)!, makeIfNecessary: false) as? EHTechnologyCustomCell
            let textFieldObject = (cellTechnology?.textFieldTechnology)! as NSTextField
            if !textFieldObject.editable{
                deleteTechnologyDate.enabled = true
            }else{
                deleteTechnologyDate.enabled = false
            }
        }
        
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        
        switch item{
            
        case  _ as Technology:
            
            
            if isCandidatesViewLoaded
            {
                
                candidateController?.view.removeFromSuperview()
                NSApp.windows.first?.title = "Window"
                 isCandidatesViewLoaded = false
                welcomeImage.hidden = false
                
                
            }
            
        case  _ as Date:
            
            if !isCandidatesViewLoaded
            {
                
//                candidateController = self.storyboard?.instantiateControllerWithIdentifier("EHCandidateController") as? EHCandidateController
                candidateController?.delegate = self
                 candidateController?.managedObjectContext = self.managedObjectContext
                self.candidateView.addSubview((candidateController?.view)!)
               
                NSApp.windows.first?.title = "List of Candidates"
                //createConstraintsForCandidateController(0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
                
                createConstraintsForController(candidateView, subView: (candidateController?.view)!, leading: 0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
                
                isCandidatesViewLoaded = true
                welcomeImage.hidden = true

            }
            //added
            if let tempItem = item as? Date {
                candidateController?.interviewDate = tempItem.interviewDate
                let techItem = outlineView.parentForItem(item) as? Technology
                candidateController?.technologyName = techItem?.technologyName
                
            }
            
            candidateController!.refresh()
            
        default:
            
            print("Never")
            
        }
        
        return true
    }
    
    // This delgate provides the content for each item (technology/date) of the outline view
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView?
    {
        
        let cell:NSTableCellView?
        if item is Date
        {
            let child = sourceList.makeViewWithIdentifier("child", owner: nil) as! EHInterviewDateCustomCell
            
            let x  = item as! Date
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let dateString = dateFormatter.stringFromDate(x.interviewDate!)
            child.lblName.stringValue = dateString
            cell = child
          
        }
        else
        {
            let parent = sourceList.makeViewWithIdentifier("Parent", owner: nil) as! EHTechnologyCustomCell
            
            let x = item as! Technology
            print(x.technologyName)
            
            if x.technologyName == ""{
                parent.textFieldTechnology.editable = true
                parent.textFieldTechnology.backgroundColor = NSColor.whiteColor()
                
            }else{
                parent.textFieldTechnology.editable = false
                parent.textFieldTechnology.backgroundColor = NSColor.clearColor()
            }
            if let name = x.technologyName{
                parent.textFieldTechnology.stringValue = name
                parent.textFieldTechnology.delegate = self
            }

            cellTechnology = parent
            lastCellAddedForTechnology = parent
            cell = parent
        }
        return cell
    }
    
    //This delegate returns the height of a row for the outlineView.
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat
    {
        return 35
    }
    
  
    
 
    
    
    
    
    //MARK: - Custom Protocol methods
    //This delegate method passed the data from another view controller to this controller as it confirms to the custom DataCommunicator protocol.
    func sendData<T>(sendingData: T,sender:String)
    {
        let scheduledDate = sendingData as! NSDate
        
        func addInterviewDateForTechnology(technology:Technology)
        {
            if isValidInterviewDate(technology.technologyName!,inputDate:scheduledDate){
                
                
                technologyDataLayer!.addInterviewDateToCoreData(technology, dateToAdd: scheduledDate,andCallBack:{()->Void in
                    
                    self.addDate.enabled = false
                    self.addTechnology.enabled = true
                    
                    self.sourceList.reloadData()
                    //sortedSourceListReload()
                    self.sourceList.expandItem(technology, expandChildren: true)
                    })
                
            }
                
            else
            {
                Utility.alertPopup("Error", informativeText: "Interview date cannot be same",isCancelBtnNeeded:false,okCompletionHandler: nil)
            }
            
            datePopOver.close()
        }
        
        if contextSelectedTechnologyIndex != -1
        {
            if let selectedItem = sourceList.itemAtRow(contextSelectedTechnologyIndex) as? Technology
            {
                
                addInterviewDateForTechnology(selectedItem)
            }
        }
        
        if  sourceList.selectedRow != -1
        {
            if let selectedItem = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
            {
                
                
                addInterviewDateForTechnology(selectedItem)
            }
        }
    }
    
    
    //PRAGMAMARK: - Button Actions
    
    @IBAction func addBtnAction(sender: AnyObject) {
        
        if  ((sourceList.itemAtRow(sourceList.selectedRow) as? Technology) != nil){ // adding new date
            
            // Condition to check dates cannot be added when technology is editing
            if !lastCellAddedForTechnology!.textFieldTechnology.editable{
                
                addDateAction(addDate)
            }
        }
            
        else{ // adding new technology
            if technologyArray.count > 0 && lastCellAddedForTechnology?.textFieldTechnology.stringValue == ""{
                Utility.alertPopup("Error", informativeText: "Please provide a name for the new technology before proceeding.",isCancelBtnNeeded:false,okCompletionHandler: nil)
            }else{
                    technologyDataLayer?.createNewtech("", andCallBack:{(newTechnology) -> Void in
                        print(newTechnology.technologyName)
                       
                      
                                
                                self.technologyArray.append(newTechnology)
                                self.reloadTableView()
                        
                        
                        
                        print("name = \(self.technologyArray[0].technologyName)")
//                    self.technologyArray.append(newTechnology)
                    self.deleteTechnologyDate.enabled = false
                })
            }
        }
    }
    
    func reloadTableView(){
        
        print(technologyArray[0].technologyName)

        self.sourceList.reloadData()

    }
    @IBAction func deleteAction(sender: AnyObject) {
        
        //this if statement is added to avoid crash. To be removed once - is disabled when no technology is selected
        if self.sourceList.selectedRow == -1
        {
            Utility.alertPopup("Error", informativeText: "Please select any Item to delete",isCancelBtnNeeded:false,okCompletionHandler: nil)
            return
        }
        
        let selected = self.sourceList.itemAtRow(self.sourceList.selectedRow)
        
        if selected is Technology
        {
            Utility.alertPopup("Alert", informativeText: "Are you sure you want to delete the selected Technology",isCancelBtnNeeded:true,okCompletionHandler: {() -> Void in
                self.deleteItem()
                if self.technologyArray.count == 0
                {
                    
                    self.deleteTechnologyDate.enabled = false
                }
                
            })
            
        }
        else
        {
            Utility.alertPopup("Alert", informativeText: "Are you sure you want to delete the selected Date",isCancelBtnNeeded:true ,okCompletionHandler: {() -> Void in
                
                print("ok btn")
                self.deleteItem()
                
            })
        }
        
    }
    
    
    func deleteItem()
    {
        if let selectedItem = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
        {
            
            
            
            if cellTechnology?.textFieldTechnology.stringValue == ""
            {
                technologyArray.removeLast()
                technologyDataLayer!.deleteTechnologyFromCoreData(selectedItem,andCallBack:{()->Void in
                    self.addTechnology.enabled = true
                    self.addDate.enabled = false
                    
                    // self.sourceList.reloadData()
                    
                    
                    self.sortedSourceListReload()
                })
                
            }
                
                // Condition to check new added technology is deletable
                
                //if !cellTechnology!.textFieldTechnology.editable
            else
            {
                technologyArray = []
                technologyDataLayer!.deleteTechnologyFromCoreData(selectedItem,andCallBack:{()->Void in
                    
//                  self.technologyArray = self.technologyDataLayer!.getSourceListContent() as! [Technology]
                    
                    self.technologyDataLayer?.getSourceListContent({(newArray)->Void in
                        self.technologyArray = newArray as! [Technology]
                        self.addTechnology.enabled = true
                        self.addDate.enabled = false
                         self.sortedSourceListReload()

                        })
                    
                    // self.sourceList.reloadData()
                    
                    
                   
                    
                })
                
                
            }
            
        }
        else
        {
            let selectedInterviewDate = sourceList.itemAtRow(sourceList.selectedRow) as? Date
            let parentTechnology = sourceList.parentForItem(selectedInterviewDate) as! Technology
            parentTechnology.interviewDates?.removeObject(selectedInterviewDate!)
//            technologyDataLayer!.deleteInterviewDateFromCoreData(selectedInterviewDate!)
            self.technologyDataLayer!.deleteInterviewDateFromCoreData(parentTechnology,inInterviewdate: selectedInterviewDate!,andCallBack:{()->Void in
                if self.isCandidatesViewLoaded
                {
                    
                    self.candidateController?.view.removeFromSuperview()
                    self.isCandidatesViewLoaded = false
                }
                self.sortedSourceListReload()
            })
           
            
            //self.sourceList.reloadData()
            
//            sortedSourceListReload()
        }
        
    }
    
    @IBAction func addDateAction(button: NSButton)
    {
        if cellTechnology?.textFieldTechnology.stringValue == ""
        {
            Utility.alertPopup("Alert", informativeText: "Please add a Technology before adding a Date", isCancelBtnNeeded:false,okCompletionHandler: nil)
            
            addTechnology.enabled = true
        }
        else{
            let textFieldObject = (cellTechnology?.textFieldTechnology)! as NSTextField
            if !textFieldObject.editable{
                datePopOver = NSPopover()
                //Make the calendar popover go away when clicked elsewhere
                datePopOver.behavior = NSPopoverBehavior.Transient
                datePopOverController = self.storyboard?.instantiateControllerWithIdentifier("popover") as? EHPopOverController
                datePopOver.contentViewController = datePopOverController
                datePopOverController!.delegate = self
                datePopOver.showRelativeToRect(button.bounds, ofView:button, preferredEdge:NSRectEdge.MaxY)
            }else{
                Utility.alertPopup("Error", informativeText: "Please enter the newly added technology",isCancelBtnNeeded:false,okCompletionHandler: nil)
            }
        }
    }
    
    func showFeedbackViewController(selectedCandidate:Candidate){
        
        print("The candidate is (selectedCandidate)")
        
        for views in self.view.subviews
        {
            views.hidden = true
            
            //views.removeFromSuperview()
        }
        feedbackViewController = self.storyboard?.instantiateControllerWithIdentifier("EHFeedbackViewController") as? EHFeedbackViewController
        
        feedbackViewController!.selectedCandidate = selectedCandidate
        feedbackViewController?.managedObjectContext = self.managedObjectContext
        feedbackViewController?.view.frame = self.view.bounds
        
        feedbackViewController?.delegate = self
        
        
        self.view.addSubview((feedbackViewController?.view)!)
        
        //        createConstraintsForFeedbackController(0, trailing:0.0, top: 0.0, bottom: 0)
        createConstraintsForController(self.view, subView: (feedbackViewController?.view)!, leading: 0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
        //
        
    }
    
    func feedbackViewControllerDidFinish(selectedCandidate:Candidate)
    {
        for views in self.view.subviews {
            views.hidden = false
        }
        candidateController?.refresh()
    }
    
    //MARK:- TextField Delegate methods
    // this method will add new technology name to the technlogy list
    override func controlTextDidEndEditing(obj: NSNotification)
    {
        print(obj.userInfo)
        print(obj.object)
        
        let textFieldObject = obj.object as! NSTextField
        
        if (!(textFieldObject.stringValue == ""))
            
        {
            if textFieldObject.editable{
                
                if isValidTechnologyName(textFieldObject.stringValue)
                {
                    if isNumberValid(textFieldObject.stringValue) == true
                    {
                        Utility.alertPopup("Error", informativeText: "Enter an appropriate Technology name",isCancelBtnNeeded:false,okCompletionHandler: nil)
                        return
                    }
                    
                    
                    let technologyObject = technologyArray[technologyArray.count-1]
                    technologyObject.technologyName = textFieldObject.stringValue
                    textFieldObject.wantsLayer = true
                    textFieldObject.backgroundColor = NSColor.clearColor()
                    addDate.enabled = false
                    addTechnology.enabled = true
                    technologyDataLayer!.addTechnologyToCoreData(technologyObject,andCallBack:{()-> Void in
                        self.deleteTechnologyDate.enabled = false
                        self.sortedSourceListReload()
                    })
                    
                    
                    
                    
                    
                   // self.sourceList.reloadData()
                    
                   
                    
                    
                }
                else{
                    
                    Utility.alertPopup("Error", informativeText: "Technology name should be unique",isCancelBtnNeeded:true,okCompletionHandler: {() -> Void in
                        
                        textFieldObject.stringValue = ""
                        
                        
                    })
                    
                }
            }
            
            
        }
            
        else
        {
            Utility.alertPopup("Alert", informativeText: "Please add a name for Technology",isCancelBtnNeeded:false, okCompletionHandler: nil)
            
            
        }
        
    }
    func addTechnologyToCoreData(techObjectToAdd:Technology,andCallBack:InsertReturn){
        
        let tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
        tempContext.parentContext = self.managedObjectContext
        tempContext.performBlock(
            { () -> Void in
                
                let technology = NSEntityDescription.insertNewObjectForEntityForName(String(Technology), inManagedObjectContext: tempContext) as? Technology
                technology?.technologyName = techObjectToAdd.technologyName
//                tempContext.insertObject(technology!)
                do
                {
                    try tempContext.save()
                    andCallBack()
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
        })
        //        managedObjectContext.insertObject(techObjectToAdd)
        //        EHCoreDataHelper.saveToCoreData(techObjectToAdd)
    }
    
    
    
    func createConstraintsForFeedbackController(leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat){
        feedbackViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let xLeadingSpace = NSLayoutConstraint(item: (feedbackViewController?.view)!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: leading)
        
        let xTrailingSpace = NSLayoutConstraint(item: (feedbackViewController?.view)!, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: trailing)
        
        let yTopSpace = NSLayoutConstraint(item: (feedbackViewController?.view)!, attribute:  .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: top)
        
        let yBottomSpace = NSLayoutConstraint(item: (feedbackViewController?.view)!, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: bottom)
        self.view .addConstraints([yTopSpace,xLeadingSpace,xTrailingSpace,yBottomSpace])
        
    }
    
    
    func createConstraintsForController(superView:NSView ,subView:NSView ,leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat){
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let xLeadingSpace = NSLayoutConstraint(item: subView, attribute: .Leading, relatedBy: .Equal, toItem: superView, attribute: .Leading, multiplier: 1, constant: leading)
        
        let xTrailingSpace = NSLayoutConstraint(item: subView, attribute: .Trailing, relatedBy: .Equal, toItem: superView, attribute: .Trailing, multiplier: 1, constant: trailing)
        
        let yTopSpace = NSLayoutConstraint(item: subView, attribute:  .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1, constant: top)
        
        let yBottomSpace = NSLayoutConstraint(item: subView, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1, constant: bottom)
        superView .addConstraints([yTopSpace,xLeadingSpace,xTrailingSpace,yBottomSpace])
    }
    
    
    //To display the CandidateDetailsView
    
    func setAllContent()
    {
        let mainWindow = NSApp.windows.first
        
        mainWindow?.contentViewController = self
        
        candidateController = self.storyboard?.instantiateControllerWithIdentifier("EHCandidateController") as? EHCandidateController
        candidateController?.delegate = self
        self.candidateView.addSubview((candidateController?.view)!)
        isCandidatesViewLoaded = true
    }
    
    //MARK:- Validations
    
    // this method will check for duplication of technology name
    func isValidTechnologyName(inputString :String) -> Bool
    {
        var isValid = true
        
        for  object in technologyArray
        {
            let technology = object as Technology
            
            //we are lowercaseString to avoid adding duplicate technology name with capital letters
            if technology.technologyName!.lowercaseString == inputString.lowercaseString
            {
                isValid =  false
                break
            }
        }
        return isValid
    }
    
    // this method will check for duplication of interview date 6
    
    func isValidInterviewDate(inputParentTechnology :String , inputDate:NSDate) -> Bool
    {
        var isValid = true
        
        for  object in technologyArray
        {
            let technology = object as Technology
            
            //we are lowercaseString to avoid adding duplicate technology name with capital letters
            if technology.technologyName!.lowercaseString == inputParentTechnology.lowercaseString
            {
                for date in technology.interviewDates!{
                    
                    let aDate = date as! Date
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    let dateString = dateFormatter.stringFromDate(aDate.interviewDate!)
                    let dateStringToCompare = dateFormatter.stringFromDate(inputDate)
                    
                    if  dateString == dateStringToCompare{
                        isValid =  false
                        break
                    }
                }
            }
        }
        return isValid
    }
    
    // this method will check for  validation of  technology name
    func isNumberValid(value:String)->Bool
    {
        
        let number = NSNumberFormatter()
        let final = number.numberFromString(value)
        if let _ = final
        {
            return true
        }
        return false
    }
    
    
    //Contextual Menu Implementaion for Technology Module:
    
    //Contextual menu setup
    
    
    override func mouseDown(theEvent: NSEvent)
    {
        addTechnology.enabled = true
        addDate.enabled = false
        sourceList.deselectRow(self.sourceList.selectedRow)
        deleteTechnologyDate.enabled = false
        
    }
    
    
    override func rightMouseDown(theEvent: NSEvent) {
        
        let check =  CGRectContainsPoint(self.sourceList.frame,theEvent.locationInWindow)
        if check == true
        {
            let mainContextMenu = NSMenu(title: "Main Contextual Menu")
            
            
            
            mainContextMenu.insertItemWithTitle("Add Technology", action:Selector.init("addBtnAction:"), keyEquivalent: "", atIndex: 0)
            mainContextMenu.insertItemWithTitle("Delete Technology", action:Selector.init("dummy") , keyEquivalent: "", atIndex: 1)
            mainContextMenu.insertItemWithTitle("Add Date", action:Selector.init("addDateToTechnologyFromContextMenu:"), keyEquivalent: "", atIndex: 2)
            mainContextMenu.insertItemWithTitle("Delete Date", action:Selector.init("dummy") , keyEquivalent: "addBtnAction:", atIndex: 3)
            
            
            
            let technologySubMenuOne = NSMenu(title: "Technology Menu One")
            
            let technologySubMenuTwo = NSMenu(title:"Technology Menu Two")
            
            let technologySubMenuThree = NSMenu(title:"Technology Menu Three")
            
            if technologyArray.count > 0
            {
                
                for var i = 0 ; i < technologyArray.count ; i++
                {
                    
                    
                    let technology = technologyArray[i] as Technology
                    
                    technologySubMenuOne.insertItemWithTitle(technology.technologyName!, action: Selector.init("deleteTechnologyFromContextMenu:"), keyEquivalent: "", atIndex: i)
                    
                    technologySubMenuTwo.insertItemWithTitle(technology.technologyName!, action: Selector.init("addDateToTechnologyFromContextMenu:"), keyEquivalent: "", atIndex: i)
                    
                    technologySubMenuThree.insertItemWithTitle(technology.technologyName!, action: Selector.init("dummy"), keyEquivalent: "", atIndex: i)
                }
                
                mainContextMenu.setSubmenu(technologySubMenuOne, forItem:mainContextMenu.itemAtIndex(1)!)
                
                mainContextMenu.setSubmenu(technologySubMenuTwo, forItem:mainContextMenu.itemAtIndex(2)!)
                
                mainContextMenu.setSubmenu(technologySubMenuThree, forItem:mainContextMenu.itemAtIndex(3)!)
                
            }
            
            for var i = 0 ; i < technologyArray.count ; i++
            {
                
                let technology = technologyArray[i] as Technology
                
                let datesMenu = NSMenu(title:"Dates Menu")
                
                let allDates = technology.interviewDates?.allObjects
                
                if allDates?.count > 0
                {
                    
                    for  (index , value) in (allDates?.enumerate())!
                    {
                        let selectedDate = value as! Date
                        
                        print(String(selectedDate.interviewDate!))
                        
                        datesMenu.insertItemWithTitle(getFormattedDate(selectedDate.interviewDate!), action: Selector.init("deleteDateFromTechnologyFromContextMenu:"), keyEquivalent:"", atIndex:index)
                    }
                    
                    technologySubMenuThree.setSubmenu(datesMenu, forItem:technologySubMenuThree.itemAtIndex(i)!)
                    
                }
                
            }
            
            NSMenu.popUpContextMenu(mainContextMenu, withEvent: theEvent, forView: self.view)
            
        }
        
    }
    
    //Delete Technology from Menu
    
    func deleteTechnologyFromContextMenu(sender:NSMenuItem)
    {
        Utility.alertPopup("Are you you want to delete the selected technology?", informativeText: "deleting Technology will delete all of its related data.",isCancelBtnNeeded:true) { () -> Void in
            
            for var i = 0 ; i < self.technologyArray.count ; i++
            {
                let technology = self.technologyArray[i] as Technology
                if technology.technologyName == sender.title
                {
                    self.technologyArray.removeAtIndex(i)
                    //self.sourceList.reloadData()
                    
                    self.sortedSourceListReload()
                    self.technologyDataLayer!.deleteTechnologyFromCoreData(technology,andCallBack:{ ()->Void in
                    })
                }
            }
            
        }
        
    }
    
    //Add date to Technology from menu
    
    func addDateToTechnologyFromContextMenu(sender:NSMenuItem)
    {
        addDate.enabled = true
        
        for var i = 0 ; i < technologyArray.count ; i++
        {
            let technology = technologyArray[i] as Technology
            if technology.technologyName == sender.title
            {
                
                contextSelectedTechnologyIndex = i
                
                addDateAction(addDate)
            }
        }
    }
    
    //Delete Date from Technology from menu
    
    func deleteDateFromTechnologyFromContextMenu(sender:NSMenuItem)
    {
        
        Utility.alertPopup("Are you sure you want to delete the selected date?", informativeText:"deleting a date will delete all of its related data. ", isCancelBtnNeeded:true) { () -> Void in
            
            
            for var i = 0 ; i < self.technologyArray.count ; i++
            {
                let technology = self.technologyArray[i] as Technology
                if technology.technologyName == sender.parentItem?.title
                {
                    
                    let selectedMenuIndex = sender.menu?.indexOfItemWithTitle(sender.title)
                    
                    print(selectedMenuIndex)
                    
                    let allDates = technology.interviewDates?.allObjects
                    
                    let selectedDate = allDates![selectedMenuIndex!] as! Date
                    
                    technology.interviewDates?.removeObject(selectedDate)
                    
                    self.technologyDataLayer!.deleteInterviewDateFromCoreData(technology,inInterviewdate: selectedDate,andCallBack:{()->Void in
                        
                        self.sortedSourceListReload()
                    })
                    
                    
                //self.sourceList.reloadData()
                 
                }
            }
        }
        
    }
    
    func dummy()
    {
        
        
    }
    
    func getFormattedDate(date:NSDate)->String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.stringFromDate(date)
    }
    

    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        
        if technologyArray.count == 0
        {
            if menuItem.title == "Add Technology"
            {
                return true
            }
            else{
                
                return false
            }
            
        }
        
        return true
        
    }

   

}



