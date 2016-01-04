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
    
    @IBOutlet weak var removeButton: NSButton!
    //MARK: Properties
    var candidateArray = NSMutableArray()
    var delegate:FeedbackDelegate?
    var technologyName:String?
    var interviewDate:NSDate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.doubleAction = "PerformDoubleAction"
      
    }
    
    func PerformDoubleAction()
    {
        if tableView.selectedRow != -1
        {
            if let delegate = self.delegate
            {
                delegate.showFeedbackViewController(self.candidateArray.objectAtIndex(self.tableView.selectedRow) as! Candidate)
            }
        }
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
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.systemLocale()
            dateFormatter.dateFormat = "hh:mm"
           let str = dateFormatter.stringFromDate((candidate?.interviewTime)!)
            
            cell.textField?.stringValue = str
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
  
    //MARK:Actions
    @IBAction func addCandidate(sender: AnyObject)
    {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        let entityDescription = EHCoreDataHelper.createEntity("Candidate", managedObjectContext: appDelegate.managedObjectContext)
        let managedObject:Candidate = Candidate(entity:entityDescription!, insertIntoManagedObjectContext:appDelegate.managedObjectContext) as Candidate
        
        managedObject.name = "Name"
        managedObject.phoneNumber = ""
        managedObject.experience =  ""
        managedObject.interviewTime = NSDate()
        managedObject.requisition = "Requsition"
        managedObject.technologyName = self.technologyName!
        managedObject.interviewDate = self.interviewDate!
        
        
        candidateArray.addObject(managedObject)
        EHCoreDataHelper.saveToCoreData(managedObject)
        tableView.reloadData()

        
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
            delete()
            
        }
    }
    
    func delete()
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
