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

class EHTechnologyViewController: NSViewController,NSOutlineViewDelegate,NSOutlineViewDataSource,DataCommunicator,FeedbackDelegate,NSTextFieldDelegate,FeedbackControllerDelegate{
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        technologyArray = EHTechnologyDataLayer.getSourceListContent() as! [Technology]
        deleteTechnologyDate.toolTip = "Delete Date or Technology"
        addDate.enabled = false
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
        return technologyArray[index]
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
    
    func outlineViewSelectionDidChange(notification: NSNotification)
    {
        
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        
        switch item{
            
        case  _ as Technology:
            
            if isCandidatesViewLoaded
            {
                
                candidateController?.view.removeFromSuperview()
                 isCandidatesViewLoaded = false
            }
            
        case  _ as Date:
            
            if !isCandidatesViewLoaded
            {
                
                candidateController = self.storyboard?.instantiateControllerWithIdentifier("EHCandidateController") as? EHCandidateController
                candidateController?.delegate = self
                self.candidateView.addSubview((candidateController?.view)!)
                //createConstraintsForCandidateController(0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
                
                createConstraintsForController(candidateView, subView: (candidateController?.view)!, leading: 0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
                
                isCandidatesViewLoaded = true
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
               // parent.textFieldTechnology.editable = true
                parent.textFieldTechnology.backgroundColor = NSColor.whiteColor()
                
            }else{
                parent.textFieldTechnology.editable = false
                parent.textFieldTechnology.backgroundColor = NSColor.clearColor()
            }
            parent.textFieldTechnology.stringValue = x.technologyName!
            parent.textFieldTechnology.delegate = self
            cellTechnology = parent
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
        
        if let selectedItem = sourceList.itemAtRow(sourceList.selectedRow) as? Technology {
            
            if isValidInterviewDate(selectedItem.technologyName!,inputDate: scheduledDate){
                let aString = sendingData as! NSDate
                print(aString)
                
                let newTechnologyEntityDescription = EHCoreDataHelper.createEntity("Date", managedObjectContext: EHCoreDataStack.sharedInstance.managedObjectContext
                )
                let newDateManagedObject:Date = Date(entity:newTechnologyEntityDescription!, insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext
                    ) as Date
                
                
                newDateManagedObject.interviewDate = scheduledDate
                
                selectedItem.interviewDates?.addObject(newDateManagedObject)
                EHCoreDataHelper.saveToCoreData(selectedItem)
                
                EHTechnologyDataLayer.addInterviewDateToCoreData(selectedItem, dateToAdd: newDateManagedObject)
                addDate.enabled = false
                addTechnology.enabled = true
                
                self.sourceList.reloadData()
            }
            else
            {
                Utility.alertPopup("Error", informativeText: "Interview date cannot be same",okCompletionHandler: nil)

            }
            datePopOver.close()
        }
    }
    
    
    //PRAGMAMARK: - Button Actions
    
    @IBAction func addBtnAction(sender: AnyObject) {
        
        if  ((sourceList.itemAtRow(sourceList.selectedRow) as? Technology) != nil){ // adding new date
            
            // Condition to check dates cannot be added when technology is editing
            if !cellTechnology!.textFieldTechnology.editable{
                addDateAction(sender as! NSButton)
            }
        }
            
        else{ // adding new technology
            if technologyArray.count > 0 && cellTechnology?.textFieldTechnology.stringValue == ""{
                Utility.alertPopup("Error", informativeText: "Please enter previous selected technology",okCompletionHandler: nil)
            }else{
                let newTechnologyEntityDescription = EHCoreDataHelper.createEntity("Technology", managedObjectContext: EHCoreDataStack.sharedInstance.managedObjectContext)
                let newTechnologyManagedObject:Technology = Technology(entity:newTechnologyEntityDescription!, insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext) as Technology
                newTechnologyManagedObject.technologyName = ""
                technologyArray.append(newTechnologyManagedObject)
                
                self.sourceList.reloadData()
                
            }
        }
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        
        //this if statement is added to avoid crash. To be removed once - is disabled when no technology is selected
        if self.sourceList.selectedRow == -1
        {
            Utility.alertPopup("Error", informativeText: "Please select any Item to delete",okCompletionHandler: nil)
            return
        }
        
        Utility.alertPopup("Alert", informativeText: "Are you sure you want delete",okCompletionHandler: {() -> Void in
            
            print("ok btn")
            self.deleteItem()
            
            })
    }
    
    
    func deleteItem()
    {
        if let selectedItem = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
        {
            // Condition to check new added technology is deletable
            if !cellTechnology!.textFieldTechnology.editable
            {
                technologyArray = []
                EHTechnologyDataLayer.deleteTechnologyFromCoreData(selectedItem)
                technologyArray = EHTechnologyDataLayer.getSourceListContent() as! [Technology]
                addTechnology.enabled = true
                addDate.enabled = false
            }
        }
            else
        {
            let selectedInterviewDate = sourceList.itemAtRow(sourceList.selectedRow) as? Date
            let parentTechnology = sourceList.parentForItem(selectedInterviewDate)
            parentTechnology!.interviewDates?!.removeObject(selectedInterviewDate!)
            EHTechnologyDataLayer.deleteInterviewDateFromCoreData(selectedInterviewDate!)
            if isCandidatesViewLoaded
            {
                
                candidateController?.view.removeFromSuperview()
                isCandidatesViewLoaded = false
            }
        }
        self.sourceList.reloadData()
    }
    
    @IBAction func addDateAction(button: NSButton)
    {
      //  if technologyArray.count == 0
       // {
        //   alertPopup("Can not add a Date", informativeText: "Please add a Technology before adding a Date", inTag: 0)
            
           // addTechnology.enabled = true
       // }
       // else{
        datePopOver = NSPopover()
        //Make the calendar popover go away when clicked elsewhere
        datePopOver.behavior = NSPopoverBehavior.Transient
        datePopOverController = self.storyboard?.instantiateControllerWithIdentifier("popover") as? EHPopOverController
        datePopOver.contentViewController = datePopOverController
        datePopOverController!.delegate = self
        datePopOver.showRelativeToRect(button.bounds, ofView:button, preferredEdge:NSRectEdge.MaxY)
       // }
    }
    
    func showFeedbackViewController(selectedCandidate:Candidate){
        
        print("The candidate is \(selectedCandidate)")
        
        for views in self.view.subviews
        {
            views.hidden = true

            //views.removeFromSuperview()
        }
        feedbackViewController = self.storyboard?.instantiateControllerWithIdentifier("EHFeedbackViewController") as? EHFeedbackViewController
        
        feedbackViewController!.selectedCandidate = selectedCandidate
        
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
            if isValidTechnologyName(textFieldObject.stringValue)
            {
                if isNumberValid(textFieldObject.stringValue) == true
                {
                    Utility.alertPopup("Error", informativeText: "Enter an appropriate Technology name",okCompletionHandler: nil)
                    return
                }
                
                let technologyObject = technologyArray[technologyArray.count-1]
                technologyObject.technologyName = textFieldObject.stringValue
                textFieldObject.wantsLayer = true
                
                textFieldObject.backgroundColor = NSColor.clearColor()
                addDate.enabled = false
                addTechnology.enabled = true
                EHTechnologyDataLayer.addTechnologyToCoreData(technologyObject)
                
                 self.sourceList.reloadData()
                
            }
            else{
                Utility.alertPopup("Error", informativeText: "Technology name should be unique",okCompletionHandler: nil)

            }
            
            
        }
       
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
   

    
}



