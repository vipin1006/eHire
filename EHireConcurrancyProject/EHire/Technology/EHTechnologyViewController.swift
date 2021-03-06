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
    
    @IBOutlet var outlineActionView: NSView!
    
    var canChangeSelection :Bool = false
    
    @IBOutlet var technologySearchFiled: NSSearchField!
    

    
    //@IBAction func addDateAction(sender: AnyObject) {
    //}
    //Set the content of source list in the outlineVew as the technology list/array
    var technologyArray = [Technology]()

     var filteredTechnologyArray = NSMutableArray()
    
    
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
    var rowView:NSTableRowView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        technologySearchFiled.appearance = NSAppearance(named:NSAppearanceNameVibrantLight)
        
        technologyDataLayer = EHTechnologyDataLayer()
        technologyDataLayer!.managedObjectContext = self.managedObjectContext!
        self.sourceList.wantsLayer = true
        
        self.sourceList.layer?.backgroundColor = NSColor.clearColor().CGColor
        self.view.wantsLayer = true
        
        self.view.layer?.backgroundColor = NSColor(calibratedRed:247/255.0, green: 246/255.0, blue: 247/255.0, alpha: 1.0).CGColor
        
        self.outlineActionView.wantsLayer = true
        
        self.outlineActionView.layer?.backgroundColor = NSColor(calibratedRed:235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0).CGColor
        
        self.outlineActionView.layer?.borderWidth = 0.3
        
        self.outlineActionView.layer?.borderColor = NSColor.lightGrayColor().CGColor
        
        technologyDataLayer?.getTechnologyListWith(
        { (technologyList,error) -> Void in
            if CoreDataError.Success == error
            {
            self.technologyArray = technologyList as! [Technology]
            self.sortedSourceListReload()
            }
            else
            {
                print("Error")
            }
        })
        candidateController = self.storyboard?.instantiateControllerWithIdentifier("EHCandidateController") as? EHCandidateController
        deleteTechnologyDate.toolTip = "Delete Date or Technology"
        deleteTechnologyDate.enabled = false
        //addDate.enabled = false
    }
    
    //Mark : Technology name sorting method
    func sortedSourceListReload()
    {
        technologyArray = technologyArray.sort({$0.technologyName < $1.technologyName})

        self.sourceList.reloadData()
 
    }
    
    //PRAGMAMARK: - outlineview datasource  methods
    //This datasource method returns the child at a given index
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject
    {
        // it 'item' is nil, technology has to be returned. Else, item's(technology) child(date) at that index
        if   item != nil
        {
            if item is Technology{
                let technology = item as! Technology
                let allObjectsAraay = technology.interviewDates?.allObjects
                
                return allObjectsAraay![index]
            }
        }
        //return self.technologyArray[index]
        
        return self.filteredTechnologyArray.count > 0 ? self.filteredTechnologyArray[index] : self.technologyArray[index]
    }
    
    
    // This datasource method returns true if the item(technology) has any children(date)
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool
    {
        if item is Technology
        {
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
        // return technologyArray.count
        
        return self.filteredTechnologyArray.count > 0 ? self.filteredTechnologyArray.count : self.technologyArray.count    }
    
    //PRAGMAMARK: - outlineview delegate  methods
    //This delegate method sets isCandidatesViewLoaded based on which item (technology/date) is selected.
    
    //
    func outlineViewSelectionIsChanging(notification: NSNotification)
    {
        if let _ = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
        {
            
            //addDate.enabled = true
           // addTechnology.enabled = false //Ajay Commnented
            
        }
        else
        {
            //addDate.enabled = false
            addTechnology.enabled = true
            deleteTechnologyDate.enabled = true
        }
    }
    
    //MARK:- Outline view delegate method
     func selectionShouldChangeInOutlineView(outlineView: NSOutlineView) -> Bool
    {
        
     
        
        if cellTechnology?.textFieldTechnology.editable == true{
            cellTechnology?.textFieldTechnology.becomeFirstResponder()
            Utility.alertPopup("Technology name alreday exist", informativeText: "Enter an appropriate Technology name",isCancelBtnNeeded:false,okCompletionHandler: {() -> Void in
                
               
                
                
            })
            return false
        }
        return true
    }
    
    

    
    func outlineViewSelectionDidChange(notification: NSNotification)
    {
        
        if let selectedItem = sourceList.itemAtRow((notification.object?.selectedRow)!) as? Technology
        {
            let notificationObject = notification.object
            cellTechnology = notificationObject?.viewAtColumn(0, row: (notification.object?.selectedRow)!, makeIfNecessary: false) as? EHTechnologyCustomCell
            
            if !(selectedItem.technologyName == "")
            {
                deleteTechnologyDate.enabled = true
            }
            else
            {
                if selectedItem.technologyName == ""
                {
                    deleteTechnologyDate.enabled = true
                    addTechnology.enabled = false //Ajay Commented
                   // addDate.enabled = false
                }
                else
                {
                    deleteTechnologyDate.enabled = false
                   // addDate.enabled = true
                }
               
            }
        }
        
        
        
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        
        switch item{
            
        case  _ as Technology:
            
            
            if isCandidatesViewLoaded
            {
                candidateController?.view.removeFromSuperview()
                NSApp.windows.first?.title = "eHire"
                 isCandidatesViewLoaded = false
               //welcomeImage.hidden = false
            }
        case  _ as Date:
            
            if !isCandidatesViewLoaded
            {
                candidateController?.delegate = self
                candidateController?.managedObjectContext = self.managedObjectContext
                self.candidateView.addSubview((candidateController?.view)!)
               
                NSApp.windows.first?.title = "List of Candidates"
                //createConstraintsForCandidateController(0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
                
                createConstraintsForController(candidateView, subView: (candidateController?.view)!, leading: 0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
                
                isCandidatesViewLoaded = true
               // welcomeImage.hidden = true

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
            
            if x.technologyName == ""{
                parent.textFieldTechnology.editable = true
                parent.textFieldTechnology.backgroundColor = NSColor.whiteColor()
                parent.textFieldTechnology.delegate = self

                
            }else{
                parent.textFieldTechnology.editable = false
                parent.textFieldTechnology.backgroundColor = NSColor.clearColor()
                parent.textFieldTechnology.delegate = nil

            }
            
            if let name = x.technologyName{
                parent.textFieldTechnology.stringValue = name
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
        if item is Technology
        {
          return 35
        }
        
        return 20
    }
    
    
    
    
    //MARK: - Custom Protocol methods
    //This delegate method passed the data from another view controller to this controller as it confirms to the custom DataCommunicator protocol.
    func sendData<T>(sendingData: T,sender:String)
    {
        let scheduledDate = sendingData as! NSDate
        
        func addInterviewDateForTechnology(technology:Technology)
        {
            if isValidInterviewDate(technology.technologyName!,inputDate:scheduledDate)
            {
                technologyDataLayer!.addInterviewDateFor(technology, withDate: scheduledDate, andCompletion:
                { (error) -> Void in
                   if CoreDataError.Success == error
                   {
                    //self.addDate.enabled = false
                    self.addTechnology.enabled = true
                    self.sourceList.reloadData()
                    self.sourceList.expandItem(technology, expandChildren: true)
                    }
                    else
                   {
                    print("Error in insertion of date")
                    }
                   
                })
            }
            else
            {
                Utility.alertPopup("Interview date already exist", informativeText: "Interview date should be unique",isCancelBtnNeeded:false,okCompletionHandler: nil)
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
    
    @IBAction func addBtnAction(sender:NSButton) {
        
        var height = 30
        
        let AddMenu = NSMenu(title:"Add Menu")
        
        let senderFrame = sender.frame
        
        print(self.sourceList.selectedRow)
        
        if self.sourceList.selectedRow == -1
        {
            AddMenu.insertItemWithTitle("New Technology...", action: #selector(EHTechnologyViewController.addTechnologyToList), keyEquivalent:"", atIndex: 0)
        }
        else
        {
            let selectedItem = self.sourceList.itemAtRow(self.sourceList.selectedRow)
            
            if selectedItem is Technology{
                
                AddMenu.insertItemWithTitle("Add Date...", action: #selector(EHTechnologyViewController.addDateToTechnologyFromContextMenu(_:)), keyEquivalent:"", atIndex: 0)
                
                AddMenu.insertItemWithTitle("New Technology...", action: #selector(EHTechnologyViewController.addTechnologyToList), keyEquivalent:"", atIndex: 1)
                
                height = 50
               
            }
            else
            {
              AddMenu.insertItemWithTitle("New Technology...", action: #selector(EHTechnologyViewController.addTechnologyToList), keyEquivalent:"", atIndex: 0)
                
            }
            
        }
        
        let point = sender.superview?.convertPoint(NSMakePoint(senderFrame.origin.x,senderFrame.origin.y + senderFrame.size.height + CGFloat(height)), fromView:nil)
        
        let event = NSEvent.mouseEventWithType(NSEventType.LeftMouseDown, location: point!, modifierFlags:NSEventModifierFlags.ControlKeyMask, timestamp:1.0, windowNumber: (sender.window?.windowNumber)!, context:sender.window?.graphicsContext, eventNumber:0, clickCount: 1, pressure: 1)

        
        NSMenu.popUpContextMenu(AddMenu, withEvent:event!, forView:sender)
        
    }
    
    func addTechnologyToList()
    {
       
        if technologyArray.count > 0 && lastCellAddedForTechnology?.textFieldTechnology.stringValue == ""{
        Utility.alertPopup("Technology name is empty", informativeText: "Please provide a name for the technology before proceeding.",isCancelBtnNeeded:false,okCompletionHandler: nil)
        }else
        {
        technologyDataLayer?.createEntityWith("", completion:
        { (newTechnology,error) -> Void in
        
        self.technologyArray.append(newTechnology)
        self.reloadTableView()
        self.sourceList.selectRowIndexes(NSIndexSet(index:self.sourceList.numberOfRows-1), byExtendingSelection: true)
        self.rowView = self.sourceList.rowViewAtRow(self.sourceList.selectedRow, makeIfNecessary:true)!
        self.rowView!.viewWithTag(1)?.becomeFirstResponder()
        self.deleteTechnologyDate.enabled = true
        
        })
        }
      

        
        
    }
    
    
    func reloadTableView()
    {
       self.sourceList.reloadData()
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        
        //this if statement is added to avoid crash. To be removed once - is disabled when no technology is selected
        if self.sourceList.selectedRow == -1
        {
            Utility.alertPopup("No item is selected", informativeText: "Please select any Item to delete",isCancelBtnNeeded:false,okCompletionHandler: nil)
            return
        }
        
        let selected = self.sourceList.itemAtRow(self.sourceList.selectedRow)
        
        if selected is Technology
        {
            guard cellTechnology?.textFieldTechnology.stringValue != "" && cellTechnology?.textFieldTechnology.editable == true else{
                Utility.alertPopup("Are you sure you want to delete the Technology?", informativeText: "All the data of this item will also be deleted.",isCancelBtnNeeded:true,okCompletionHandler: {() -> Void in
                    self.deleteItem()
                    if self.technologyArray.count == 0
                    {
                        
                        self.deleteTechnologyDate.enabled = false
                    }
                    
                })
                return
            }
            
            
        }
        else
        {
            Utility.alertPopup("Are you sure you want to delete the selected Date?", informativeText: "All the data of this item will also be deleted.",isCancelBtnNeeded:true ,okCompletionHandler: {() -> Void in
                
                self.deleteItem()
                
            })
        }
        
    }
    
    func deleteItem()
    {
        if let technologyEntity = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
        {
            if cellTechnology?.textFieldTechnology.stringValue == "" || cellTechnology?.textFieldTechnology.editable == true
            {
                technologyArray.removeLast()
                self.addTechnology.enabled = true
                //self.addDate.enabled = false
                self.sortedSourceListReload()
            }
                
            else
            {
                technologyDataLayer!.removeTechnolgy(technologyEntity, completion:
                    { (error) -> Void in
                        if CoreDataError.Success == error
                        {
                            self.technologyArray.removeAtIndex(self.technologyArray.indexOf(technologyEntity)!)
                            if self.filteredTechnologyArray.count > 0
                            {
                                self.filteredTechnologyArray.removeObjectAtIndex(self.filteredTechnologyArray.indexOfObject(technologyEntity))
                            }
                            
                            self.technologySearchFiled.stringValue = ""
                            self.addTechnology.enabled = true
                            // self.addDate.enabled = false
                            self.sortedSourceListReload()
                        }
                        else
                        {
                            print("Error in deletion")
                        }
                })
            }
            
        }
        else
        {
            let selectedInterviewDate = sourceList.itemAtRow(sourceList.selectedRow) as? Date
            let technologyObject = sourceList.parentForItem(selectedInterviewDate) as! Technology
            technologyObject.interviewDates?.removeObject(selectedInterviewDate!)
            self.technologyDataLayer!.removeInterviewDateFrom(technologyObject, forInterview: selectedInterviewDate!, andCompletion: { (error) -> Void in
                if CoreDataError.Success == error
                {
                    if self.isCandidatesViewLoaded
                    {
                        self.candidateController?.view.removeFromSuperview()
                        self.isCandidatesViewLoaded = false
                        self.sortedSourceListReload()
                    }
                }
                else
                {
                    print("Error")
                }
            })
            
        }
        
    }
    
    @IBAction func addDateAction(button: NSButton)
    {
        if cellTechnology?.textFieldTechnology.stringValue == ""
        {
            Utility.alertPopup("Technology name is empty", informativeText: "Please add a Technology before adding a Date", isCancelBtnNeeded:false,okCompletionHandler: nil)
            
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
                datePopOver.showRelativeToRect((cellTechnology?.textFieldTechnology?.bounds)!, ofView:cellTechnology!, preferredEdge:NSRectEdge.MaxX)
            }else{
                Utility.alertPopup("Error", informativeText: "Please enter the newly added technology",isCancelBtnNeeded:false,okCompletionHandler: nil)
            }
        }
    }
    
    func showFeedbackViewController(selectedCandidate:Candidate){
        
        feedbackViewController = self.storyboard?.instantiateControllerWithIdentifier("EHFeedbackViewController") as? EHFeedbackViewController
        
        feedbackViewController!.selectedCandidate = selectedCandidate
        feedbackViewController?.managedObjectContext = self.managedObjectContext
        feedbackViewController?.view.frame = self.view.bounds
        
        feedbackViewController?.delegate = self
        
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        
        self.presentViewController(feedbackViewController!, animator: EHTransitionAnimator())
        
    }
    
   
    
    func feedbackViewControllerDidFinish(selectedCandidate:Candidate)
    {

//        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
//        
//        appDelegate.mainWindowController?.contentViewController = self
       
        candidateController?.refresh()
    }
    
    //MARK:- TextField Delegate methods
    // this method will add new technology name to the technlogy list
    override func controlTextDidEndEditing(obj: NSNotification)
    {
        
        let textFieldObject = obj.object as! NSTextField
        print(textFieldObject)
        
        let technologyObject  = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
        if textFieldObject.stringValue != ""
        {
            
            if isValidTechnologyName(textFieldObject.stringValue)
            {
                if isNumberValid(textFieldObject.stringValue) == true
                {
                    Utility.alertPopup("Technology name already exist", informativeText: "Enter an appropriate Technology name",isCancelBtnNeeded:false,okCompletionHandler: {() -> Void in
                        
                        textFieldObject.stringValue = ""
                    })
                    return
                }
                if let _ = technologyObject
                {
                    technologyObject!.technologyName = textFieldObject.stringValue
                    self.cellTechnology?.textFieldTechnology.editable = false

                    technologyDataLayer!.addTechnologyTo(technologyObject!, completion:
                        { (error) -> Void in
                            if CoreDataError.Success == error
                            {
                                self.deleteTechnologyDate.enabled = false
                                self.addTechnology.enabled = true
                                self.sortedSourceListReload()
                                self.canChangeSelection = true
                                
                            }
                            else
                            {
                                print("Error in insertion of technology")
                                
                            }
                    })
                }
                
                
            }
            else
            {
                Utility.alertPopup("Technology name already exist", informativeText: "Technology name should be unique",isCancelBtnNeeded:false,okCompletionHandler: {() -> Void in
                    
                    textFieldObject.stringValue = ""
                    self.deleteTechnologyDate.enabled = true
                })
                return
            }
            
        }
        
//        else
//        {
//            Utility.alertPopup("Error", informativeText: "aaaaaaa",isCancelBtnNeeded:false,okCompletionHandler: {() -> Void in
//                
//                textFieldObject.stringValue = ""
//                self.deleteTechnologyDate.enabled = true
//            })
//            return
//            
//            
//        }
    }
    
    
    //MARK:- Delegate method to disable/enable deleteTechnologyDate Button
    override func controlTextDidChange(obj: NSNotification) {
         let textFieldObject = obj.object as! NSTextField
        if textFieldObject.stringValue == ""{
            self.deleteTechnologyDate.enabled = true
        }else{
            self.deleteTechnologyDate.enabled = false
        }
    }
    
    //MARK:- Method to create dynamic constraints for feedback controller
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
       guard cellTechnology?.textFieldTechnology.editable == true else{
        addTechnology.enabled = true
       // addDate.enabled = false
        sourceList.deselectRow(self.sourceList.selectedRow)
        deleteTechnologyDate.enabled = false
        return
        }
        
    }
    
    
  override func rightMouseDown(theEvent: NSEvent) {
  
        
        let isOutlineView = self.view.hitTest(theEvent.locationInWindow)
        
        if isOutlineView is NSOutlineView
        {
          
            let mainContextMenu = NSMenu(title: "Main Contextual Menu")
            
            
            if self.sourceList.selectedRow == -1
            {
                mainContextMenu.insertItemWithTitle("Add Technology", action:#selector(EHTechnologyViewController.addTechnologyToList), keyEquivalent: "", atIndex: 0)
            }
            else
            {
                
               let selectedItem = self.sourceList.itemAtRow(self.sourceList.selectedRow)
                
                if selectedItem is Technology{
                    
                    mainContextMenu.insertItemWithTitle("Add Date", action:#selector(EHTechnologyViewController.addDateToTechnologyFromContextMenu(_:)), keyEquivalent: "", atIndex: 0)
                    
                    mainContextMenu.insertItemWithTitle("Delete Technology", action:#selector(EHTechnologyViewController.deleteTechnologyFromContextMenu(_:)), keyEquivalent: "", atIndex: 1)
                }
                else
                {
                   mainContextMenu.insertItemWithTitle("Delete Date", action:#selector(EHTechnologyViewController.deleteDateFromTechnologyFromContextMenu(_:)), keyEquivalent: "", atIndex: 0)
                   
                }
                
                
            }
            
           NSMenu.popUpContextMenu(mainContextMenu, withEvent: theEvent, forView: self.view)
            
        }
       
    }
    
    //Delete Technology from Menu
    
    func deleteTechnologyFromContextMenu(sender:NSMenuItem)
    {
        Utility.alertPopup("Are you sure you want to delete the Technology?", informativeText: "All the data of this item will also be deleted.",isCancelBtnNeeded:true) { () -> Void in
            
            self.technologyDataLayer?.removeTechnolgy(self.technologyArray.removeAtIndex(self.sourceList.selectedRow), completion: { (error) -> Void in
                
                  
            })
            
            self.sortedSourceListReload()
            
        }
        
    }
    
    //Add date to Technology from menu
    
    func addDateToTechnologyFromContextMenu(sender:NSMenuItem)
    {
       // addDate.enabled = true
        
        addDateAction(addTechnology)
        
    }
    
    //Delete Date from Technology from menu
    
    func deleteDateFromTechnologyFromContextMenu(sender:NSMenuItem)
    {
        
        Utility.alertPopup("Are you sure you want to delete the Date?", informativeText:"All the data of this item will also be deleted. ", isCancelBtnNeeded:true) { () -> Void in
            
            let selectedDate = self.sourceList.itemAtRow(self.sourceList.selectedRow) as! Date
            
            let technologyObject = self.sourceList.parentForItem(selectedDate) as! Technology
            
            technologyObject.interviewDates?.removeObject(selectedDate)
            
            self.technologyDataLayer!.removeInterviewDateFrom(technologyObject, forInterview: selectedDate, andCompletion:
                { (error) -> Void in
                    self.sortedSourceListReload()
            })
            
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
       
        
        return true
        
    }
    
    @IBAction func filteredSerachField(sender: NSSearchField)
    {
        addTechnology.enabled = false
        filteredTechnologyArray.removeAllObjects()
        let technologyPredicate =   NSPredicate(format:"technologyName contains[cd] %@ " ,sender.stringValue)
        
        print(technologyPredicate)
        
        let resultArray = technologyArray.filter{technologyPredicate.evaluateWithObject($0)}
        filteredTechnologyArray.addObjectsFromArray(resultArray)
        
        
        self.sourceList.reloadData()

        
    }


    
}




