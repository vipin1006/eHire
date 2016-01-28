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
    @IBOutlet weak var candidateSearchField: NSSearchField!
    @IBOutlet weak var addCandidateButton: NSButton!
    @IBOutlet weak var feedbackButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
   // @IBOutlet weak var phoneNumberTextField: NSTextField!
    //MARK: Properties
    var candidateArray = NSMutableArray()
    var filteredArray = NSMutableArray()
    var delegate:FeedbackDelegate?
    var technologyName:String?
    var interviewDate:NSDate?
    var preserveCandidate : Int?
    var candidateDetails = Candidate()
    var candidateAccessLayer : EHCandidateAccessLayer?
    var managedObjectContext : NSManagedObjectContext?

    
    override func viewDidLoad()
    {
      super.viewDidLoad()
      feedbackButton.enabled = false
      removeButton.enabled = false
      removeButton.toolTip = "Remove Candidate"
      addCandidateButton.toolTip = "Add Candidate"
        candidateAccessLayer = EHCandidateAccessLayer()
        candidateAccessLayer?.managedObjectContext = self.managedObjectContext
        
    }
    
    override func viewWillAppear()
    {
     if let tablePreserved = preserveCandidate
     {
       tableView.selectRowIndexes(NSIndexSet(index: tablePreserved), byExtendingSelection: false)
     }
    }
    
    //MARK: This data source method returns tableview rows
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        if candidateSearchField.stringValue.characters.count > 0 {
            return filteredArray.count
        }
        return candidateArray.count
    }
    
    //Mark: This delegate method provides the content for each item of the table view

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        var candidate:Candidate
        if candidateSearchField.stringValue.characters.count > 0 {
            candidate = (filteredArray[row] as? Candidate)!
        }
        else {
            candidate = (candidateArray[row] as? Candidate)!
        }
        let cell = self.tableView.makeViewWithIdentifier((tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        cell.textField?.delegate = self
        if tableColumn?.identifier == "name"
        {
            if candidate.name != nil
            {
            cell.textField?.stringValue = (candidate.name)!
            }
        }
            
        else if tableColumn?.identifier == "experience"
        {
            if candidate.experience != nil
            {
                if candidate.experience!.doubleValue < -1
                {
                    cell.textField?.stringValue = ""
                }
                else
                {
                    let str = String(format: "%.1f", arguments: [(candidate.experience!.doubleValue)])
                    cell.textField?.stringValue = str
                }
            }
        }
            
        else if tableColumn?.identifier == "interviewTime"
        {
            let interviewTimePicker:NSDatePicker = cell.viewWithTag(10) as! NSDatePicker
            interviewTimePicker.dateValue = (candidate.interviewTime)!
  
        }
            
            else if tableColumn?.identifier == "requisition"
        {
            cell.textField?.stringValue = (candidate.requisition)!
        }
            
        else
        {
           cell.textField?.stringValue = (candidate.phoneNumber)!
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
        let selectedRow = tableView.selectedRow
       if selectedRow != -1
       {
       if let _:Candidate = candidateArray.objectAtIndex(selectedRow) as? Candidate
       {
        feedbackButton.enabled = true
        removeButton.enabled = true
        }
      }
       else
       {
        feedbackButton.enabled = false
        removeButton.enabled = false
        }
    }

    //MARK:Actions
    @IBAction func addCandidate(sender: AnyObject)
    {
      func addCandidate()
      {

         candidateAccessLayer!.addCandidate("", experience: nil, phoneNumber: "", requisition: "",interviewTime:self.interviewDate!, technologyName: self.technologyName!, interviewDate: self.interviewDate!,andCallBack: {(newCandidate) -> Void in
            self.candidateArray.addObject(newCandidate)
            self.tableView.reloadData()
            let index : NSInteger = self.candidateArray.count - 1;
            self.tableView.selectRowIndexes(NSIndexSet.init(index: index), byExtendingSelection: true)
            let rowView:NSTableRowView = self.tableView.rowViewAtRow(self.tableView.selectedRow, makeIfNecessary: true)!

            rowView.viewWithTag(1)?.becomeFirstResponder()
            
            })
        
      }
      if candidateArray.count > 0
      {
        var allCandidatesValid:Bool = true
        for candidateRecord in candidateArray
        {
          if candidateRecord.name! == "" || candidateRecord.phoneNumber! == "" || candidateRecord.experience! == -1 || candidateRecord.experience! == nil || candidateRecord.requisition! == ""
          {
            Utility.alertPopup("Candidate can not be added", informativeText: "Please fill all the details of the selected candidate before adding a new candidate", isCancelBtnNeeded:true,okCompletionHandler:
                { () -> Void in
                        
                })
            allCandidatesValid = false
            break
          }
        }
        if allCandidatesValid == true
        {
          addCandidate()
        }
     }
     else
     {
       addCandidate()
     }
  }
    
    func refresh()
    {
      getSourceListContent()
        
    }
    
    func getSourceListContent()
    {
        
        
      candidateArray.removeAllObjects()
        candidateAccessLayer?.getCandiadteList(technologyName!, interviewDate: interviewDate!, andCallBack: { (recordsArray) -> Void in
            if recordsArray.count > 0
            {
                for aRec in recordsArray
                {
                    let cEntity = aRec as! Candidate
                    self.candidateArray.addObject(cEntity);
                }
            }
            
            self.tableView.reloadData()
            if self.tableView.selectedRow == -1
            {
                self.feedbackButton.enabled = false
                self.removeButton.enabled = false
            }
            if let tablePreserved = self.preserveCandidate
            {
                self.tableView.selectRowIndexes(NSIndexSet(index: tablePreserved), byExtendingSelection: false)
            }
            if self.candidateArray.count > 0
            {
                let candidate = self.candidateArray.lastObject
                if  candidate!.name! == "" && candidate!.phoneNumber! == "" && candidate!.experience! == -1 && candidate!.requisition! == ""
                {
                    self.candidateSearchField.enabled = false
                }
                else
                {
                    self.candidateSearchField.enabled = true
                }
            }
            else
            {
                self.candidateSearchField.enabled = false
            }

        })
    }

    @IBAction func searchFieldTextDidChange(sender: NSSearchField)
    {
      filteredArray.removeAllObjects()
      let predicate = NSPredicate(format:" requisition CONTAINS[cd] %@" ,sender.stringValue)
        let predicate1 = NSPredicate(format:" experience == %f" ,sender.floatValue)
        let predicate2 = NSPredicate(format:" name CONTAINS[cd] %@" ,sender.stringValue)
      filteredArray.addObjectsFromArray(candidateArray.filteredArrayUsingPredicate(predicate1))
      filteredArray.addObjectsFromArray(candidateArray.filteredArrayUsingPredicate(predicate))
        filteredArray.addObjectsFromArray(candidateArray.filteredArrayUsingPredicate(predicate2))
        tableView.reloadData()
      
    }
    
   @IBAction func removeCandidate(sender: AnyObject)
   {
   
    Utility.alertPopup("Are you sure you want to delete the Candidate?", informativeText: "", isCancelBtnNeeded:true,okCompletionHandler:{() in
        self.deleteCandidate()
      })
   }
    
    @IBAction func addInterviewTime(sender: AnyObject)
    {
      let selectedCandidate:Candidate = candidateArray.objectAtIndex(tableView.selectedRow) as! Candidate
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
          preserveCandidate = tableView.selectedRow
          NSApp.windows.first?.title = "Candidate Feedback"
          if candidateArray.count > 0
            {
              let candidateRecord = candidateArray.objectAtIndex(tableView.selectedRow) as! Candidate
              if  candidateRecord.name! == "" || candidateRecord.phoneNumber! == "" || candidateRecord.experience == -1 || candidateRecord.experience == nil || candidateRecord.requisition! == ""
              {
                Utility.alertPopup("Candidate details are not complete. Cannot proceed to provide feedback.", informativeText:"Please enter all the candidate information before proceeding.",isCancelBtnNeeded:false, okCompletionHandler: { () -> Void in
                        })
              }
              else
              {
                delegate.showFeedbackViewController(selectedCandidate)
              }
            }
        }
        
       }
     }
        
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
      let textField = control as! NSTextField
      let candidate = self.candidateArray.objectAtIndex(self.tableView.selectedRow) as! Candidate
      switch textField.tag
      {
        case 1:
        if (!(textField.stringValue == ""))
        {
         if EHOnlyDecimalValueFormatter.isNumberValid(textField.stringValue)
         {
          Utility.alertPopup("Error", informativeText: "Please enter alphabetical characters for candidate name.",isCancelBtnNeeded:false,okCompletionHandler: nil)
            textField.stringValue = ""
          //candidate.name = textField.stringValue
         }
         else
         {
          candidate.name = fieldEditor.string
          candidateSearchField.enabled = true
         }
        }
        else
        {
            candidate.name = fieldEditor.string
 
         candidateSearchField.enabled = false
        }
       
        case 2:
        if (!(textField.stringValue == ""))
        {
          if !EHOnlyDecimalValueFormatter.isNumberValid(textField.stringValue)
          {
            Utility.alertPopup("Error", informativeText: "Please enter a numerical value for experience.",isCancelBtnNeeded:false,okCompletionHandler:nil)
            textField.stringValue = ""
          }
          else if (fieldEditor.string?.characters.count <= 4)
          {
            let numberFormatter = NSNumberFormatter()
            let number:NSNumber? = numberFormatter.numberFromString(fieldEditor.string!)
            if let number = number
            {
              let double = Double(number)
              candidate.experience = double
            }
              candidateSearchField.enabled = false
          }
          else
          {
            Utility.alertPopup("Error", informativeText: "Please enter a appropriate  experience.",isCancelBtnNeeded:false,okCompletionHandler: nil)
            textField.stringValue = ""
          }
        }
        else
        {
           candidate.experience = nil
           self.candidateSearchField.enabled = false
        }
       

       case 3:
            if (!(textField.stringValue == ""))
            {
                if !EHOnlyDecimalValueFormatter.isNumberValid(textField.stringValue)
                {
                    Utility.alertPopup("Error", informativeText: "Please enter a 10 digit mobile phone number. ",isCancelBtnNeeded:false,okCompletionHandler: nil)
                    textField.stringValue = ""
                }
                else if ((fieldEditor.string?.characters.count >= 10) && (fieldEditor.string?.characters.count <= 12))
                {
                    candidate.phoneNumber = fieldEditor.string
                    self.candidateSearchField.enabled = true
                }
                else
                {
                    Utility.alertPopup("Error", informativeText: "Please enter a 10 digit mobile phone number.",isCancelBtnNeeded:false,okCompletionHandler: nil)
                    textField.stringValue = ""
                    
                }
            }
            else
            {
                candidate.phoneNumber = fieldEditor.string
                candidateSearchField.enabled = false
        }


        case 4:
            if (!(textField.stringValue == ""))
            {
                if EHOnlyDecimalValueFormatter.isNumberValid(textField.stringValue)
                {
                    Utility.alertPopup("Error", informativeText: "Please enter alphabetical characters for requisition.",isCancelBtnNeeded:false,okCompletionHandler: nil)
                    textField.stringValue = ""
                    
                }
                else
                {
                    candidate.requisition = fieldEditor.string
                    candidateSearchField.enabled = true
                }
            }
            else
            {
                 candidate.requisition = fieldEditor.string
              candidateSearchField.enabled = false
            }
            
        default: break
       
     }
        EHCoreDataHelper.saveToCoreData(candidate)
        return true
    }
    
    
    func deleteCandidate()
    {
     if tableView.selectedRow > -1
     {
      let editCandidate = candidateArray.objectAtIndex(tableView.selectedRow) as? Candidate
      candidateAccessLayer!.removeCandidate(editCandidate!)
      candidateArray.removeObjectAtIndex(tableView.selectedRow)
      feedbackButton.enabled = false
      removeButton.enabled = false
     }
      tableView.reloadData()
    }
}
