//
//  EXEhireCandidateinfo.swift
//  EXEhireInterView
//
//  Created by Pratibha Sawargi on 10/12/15.
//  Copyright © 2015 Pratibha Sawargi. All rights reserved.
//

import Cocoa

protocol FeedbackDelegate
{
    func showFeedbackViewController(selectedCandidate:Candidate)
}

class EHCandidateController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate{
    //MARK: IBOutlets
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var candidateView: NSView!
    
    @IBOutlet weak var feedbackButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    //MARK: Properties
    var candidateArray = NSMutableArray()
    var delegate:FeedbackDelegate?
    var technologyName:String?
    var interviewDate:NSDate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       feedbackButton.enabled = false
        removeButton.enabled = false
    }
    
    //MARK: This data source method returns tableview rows
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return candidateArray.count
    }
    
    //Mark: This delegate method provides the content for each item of the table view

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let  candidate  = candidateArray[row] as? Candidate
        let cell = self.tableView.makeViewWithIdentifier((tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        cell.textField?.delegate = self
        
        if tableColumn?.identifier == "name"
        {
            if candidate?.name != nil
            {
            cell.textField?.stringValue = (candidate?.name)!
            }
        }
            
        else if tableColumn?.identifier == "experience"
        {
            if candidate?.experience != nil
            {
              cell.textField?.stringValue = (candidate?.experience)!
            }
        }
            
        else if tableColumn?.identifier == "interviewTime"
        {
            let interviewTimePicker:NSDatePicker = cell.viewWithTag(10) as! NSDatePicker
            interviewTimePicker.dateValue = (candidate?.interviewTime)!
  
        }
            
            else if tableColumn?.identifier == "requisition"
        {
            cell.textField?.stringValue = (candidate?.requisition)!
        }
            
        else
        {
           cell.textField?.stringValue = (candidate?.phoneNumber)!
        }
        return cell
    }
    
    //MARK: This method returns the height of the tableview row
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 35
    }
  
    func tableViewSelectionDidChange(notification: NSNotification)
    {
        let selectedRow:NSInteger = tableView.selectedRow
       if let _:Candidate = candidateArray.objectAtIndex(selectedRow) as? Candidate
       {
        feedbackButton.enabled = true
        removeButton.enabled = true
        }
       else{
        feedbackButton.enabled = false
        removeButton.enabled = false
        }
    }
//    func outlineViewSelectionIsChanging(notification: NSNotification)
//    {
//        if let _ = sourceList.itemAtRow(sourceList.selectedRow) as? Technology
//        {
//            addDate.enabled = true
//            addTechnology.enabled = false
//            
//        }
//        else
//        {
//            addDate.enabled = false
//            addTechnology.enabled = true
//        }
//    }

    //MARK:Actions
    @IBAction func addCandidate(sender: AnyObject)
    {
        func addCandidate()
        {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        let entityDescription = EHCoreDataHelper.createEntity("Candidate", managedObjectContext: appDelegate.managedObjectContext)
        let managedObject:Candidate = Candidate(entity:entityDescription!, insertIntoManagedObjectContext:appDelegate.managedObjectContext) as Candidate
        
        managedObject.name = "Name"
        managedObject.phoneNumber = ""
        managedObject.experience =  ""
        managedObject.interviewTime = NSDate()
        managedObject.requisition = "Requisition"
        managedObject.technologyName = self.technologyName!
        managedObject.interviewDate = self.interviewDate!
        
        
        candidateArray.addObject(managedObject)
        EHCoreDataHelper.saveToCoreData(managedObject)
        tableView.reloadData()
        }
        
        if candidateArray.count > 0
        {
            let candidateRecord = candidateArray.lastObject as! Candidate
            if candidateArray.count > 0 && candidateRecord.name! == "name" || candidateRecord.phoneNumber! == "" || candidateRecord.experience! == " " || candidateRecord.requisition! == "Requisition"
            {
                let alert:NSAlert = NSAlert()
                alert.messageText = "Candiadte can not be added"
                alert.informativeText = "Please fill the existing candidate details before adding a new candidate"
                alert.addButtonWithTitle("OK")
                alert.addButtonWithTitle("Cancel")
                alert.alertStyle = .WarningAlertStyle
                alert.runModal()
            }
            else
            {
                addCandidate()
            }
        }
        else
        {
            addCandidate()
        }


        
    }
    
    func refresh() {
        getSourceListContent()
        tableView.reloadData()
    }
    
    
    func getSourceListContent(){
        candidateArray.removeAllObjects()
        
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let context     = appDelegate.managedObjectContext
        
        let predicate = NSPredicate(format:"technologyName = %@ AND interviewDate = %@" , technologyName!,interviewDate!)
       
        print(technologyName)
        print(interviewDate)
        let records = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Candidate", managedObjectContext: context)
        
        print(records)
        
        if records?.count > 0{
            for aRec in records!{
                let cEntity = aRec as! Candidate
                
                candidateArray.addObject(cEntity);//
            }
        }
    }

    
   @IBAction func removeCandidate(sender: AnyObject)
   {
    if removeButton.enabled == true
        
    {
        showAlert("Are you sure to delete the Candidate?", info:"Deleting a Candidate will delete all of the details")
    }
    else
    {
        removeButton.enabled = false
    }
    }
    
    @IBAction func addInterviewTime(sender: AnyObject)
    {
        let selectedRow:NSInteger = tableView.selectedRow
        let selectedCandidate:Candidate = candidateArray.objectAtIndex(selectedRow) as! Candidate
        selectedCandidate.interviewTime = sender.dateValue
        EHCoreDataHelper.saveToCoreData(selectedCandidate)
        
    }
    
    @IBAction func enterFeedback(sender: AnyObject)
    {
        if tableView.selectedRow > -1
        {
        if let delegate = self.delegate
        {
            let selectedRow:NSInteger = tableView.selectedRow
            let selectedCandidate:Candidate = candidateArray.objectAtIndex(selectedRow) as! Candidate
            delegate.showFeedbackViewController(selectedCandidate)
            
        }
        }
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        
        let textField = control as! NSTextField
        
        let candidate = self.candidateArray.objectAtIndex(self.tableView.selectedRow) as! Candidate
        
       switch textField.tag
       {
        case 1:
        candidate.name = fieldEditor.string
        
        case 2:
        candidate.experience = fieldEditor.string

        case 3:
        candidate.phoneNumber = fieldEditor.string

        case 4:
        candidate.requisition = fieldEditor.string

        default:
        print("Hi")
    }
        do{
            try candidate.managedObjectContext?.save()
          }
        catch{
            }
        return true
    }
    
    func showAlert(message:String,info:String)
    {
        let selectedRow = self.tableView.selectedRow
        if selectedRow != -1
        {
        _ = self.candidateArray.objectAtIndex(self.tableView.selectedRow) as! Candidate
        
        let alert:NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = info
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.alertStyle = .WarningAlertStyle
        let res = alert.runModal()
        
        if res == NSAlertFirstButtonReturn
        {
            deleteCandidate()
            
        }
        }
    }
    
    func deleteCandidate()
    {
      if tableView.selectedRow > -1
        {
            let editCandidate = candidateArray.objectAtIndex(tableView.selectedRow) as? Candidate
            
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.managedObjectContext.deleteObject(editCandidate!)
            EHCoreDataHelper.saveToCoreData(editCandidate!)
            candidateArray.removeObjectAtIndex(tableView.selectedRow)
        }
        
        tableView.reloadData()
    }

}
