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
              cell.textField?.stringValue = (candidate.experience)!
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
         candidateAccessLayer!.addCandidate("", experience: "", phoneNumber: "", requisition: "",interviewTime:self.interviewDate!, technologyName: self.technologyName!, interviewDate: self.interviewDate!,andCallBack: {(newCandidate) -> Void in
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
          if candidateRecord.name! == "" || candidateRecord.phoneNumber! == "" || candidateRecord.experience! == " " || candidateRecord.requisition! == ""
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
                if  candidate!.name! == "" && candidate!.phoneNumber! == "" && candidate!.experience! == "" && candidate!.requisition! == ""
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

    @IBAction func searchFieldTextDidChange(sender: AnyObject)
    {
      filteredArray.removeAllObjects()
      let predicate = NSPredicate(format:"name contains[c] %@ OR experience contains[c] %@ OR phoneNumber contains[c] %@ OR requisition contains[c] %@" , sender.stringValue,sender.stringValue,sender.stringValue,sender.stringValue)
     filteredArray.addObjectsFromArray(candidateArray.filteredArrayUsingPredicate(predicate))
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
              if  candidateRecord.name! == "" || candidateRecord.phoneNumber! == "" || candidateRecord.experience! == " " || candidateRecord.requisition! == ""
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
          Utility.alertPopup("Error", informativeText: "Enter an appropriate candidate name",isCancelBtnNeeded:false,okCompletionHandler: nil)
            textField.stringValue = ""
          candidate.name = textField.stringValue
         }
         else
         {
          candidate.name = fieldEditor.string
          candidateSearchField.enabled = true
         }
        }
        else
        {
         candidateSearchField.enabled = false
        }
       
        case 2:
        candidate.experience = fieldEditor.string

        case 3:
        candidate.phoneNumber = fieldEditor.string

        case 4:
            if (!(textField.stringValue == ""))
            {
                if EHOnlyDecimalValueFormatter.isNumberValid(textField.stringValue)
                {
                    Utility.alertPopup("Error", informativeText: "Enter an appropriate candidate requisition",isCancelBtnNeeded:false,okCompletionHandler: nil)
                    textField.stringValue = ""
                    candidate.requisition = textField.stringValue
                }
                else
                {
                    candidate.requisition = fieldEditor.string
                    candidateSearchField.enabled = true
                }
            }
            else
            {
              candidateSearchField.enabled = false
            }
            
        default:
        print("")
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
