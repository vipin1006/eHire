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

class EHCandidateController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate,NSUserNotificationCenterDelegate{
    
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
    let center = NSUserNotificationCenter.defaultUserNotificationCenter()

    
    override func viewDidLoad()
    {
      super.viewDidLoad()
      feedbackButton.enabled = false
      removeButton.enabled = false
      removeButton.toolTip = "Remove Candidate"
      addCandidateButton.toolTip = "Add Candidate"
      candidateAccessLayer = EHCandidateAccessLayer()
      candidateAccessLayer?.managedObjectContext = self.managedObjectContext
      candidateSearchField.appearance = NSAppearance(named:NSAppearanceNameVibrantLight)
      center.delegate = self
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
            addCandidateButton.enabled = false
        }
        else {
            candidate = (candidateArray[row] as? Candidate)!
             addCandidateButton.enabled = true
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
            else
            {
                cell.textField?.stringValue = ""
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
        return 22
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
         self.removeButton.enabled = false
        })
      }
      if candidateArray.count > 0
      {
        var allCandidatesValid:Bool = true
        for candidateRecord in candidateArray
        {
          if candidateRecord.name! == "" || candidateRecord.phoneNumber! == "" || candidateRecord.experience! == nil || candidateRecord.experience! == nil || candidateRecord.requisition! == ""
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
      candidateAccessLayer?.getCandiadteList(technologyName!, interviewDate:interviewDate!, andCallBack: { (recordsArray) -> Void in
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
      let predicate = self.experiencePredicateWithValue(sender.stringValue)
      filteredArray.addObjectsFromArray(candidateArray.filteredArrayUsingPredicate(predicate))
            tableView.reloadData()
    }
    
    func experiencePredicateWithValue(value: String) -> NSPredicate
    {
        let floatValue = (value as NSString).floatValue
        
        let lhs:NSExpression = NSExpression.init(forKeyPath: "experience")
        
        let lowerLimit:NSExpression = NSExpression.init(forConstantValue:NSNumber.init(float: floor(floatValue)))
        let option:NSComparisonPredicateOptions = NSComparisonPredicateOptions.init(rawValue: 0)
        
        let greaterThanPredicate:NSComparisonPredicate = NSComparisonPredicate.init(leftExpression:lhs , rightExpression:lowerLimit , modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.GreaterThanOrEqualToPredicateOperatorType, options: option)
        
        
        let upperLimit:NSExpression = NSExpression.init(forConstantValue:NSNumber.init(float: floor(floatValue+1)))
        
        let lessThanPredicate:NSComparisonPredicate = NSComparisonPredicate.init(leftExpression:lhs , rightExpression:upperLimit , modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LessThanPredicateOperatorType, options: option)
        
        let predicate:NSPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates:[greaterThanPredicate, lessThanPredicate])
        
        let otherPredicate = NSPredicate(format:" requisition CONTAINS[cd] %@ OR name CONTAINS[cd] %@ OR phoneNumber CONTAINS[cd] %@", value, value, value)
        let compoundPredicate:NSCompoundPredicate =  NSCompoundPredicate.init(orPredicateWithSubpredicates: [otherPredicate, predicate])
        return compoundPredicate
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
      
        selectedCandidate.interviewTime = (sender.dateValue!!)
        
        selectedCandidate.interviewDate = convertGmtToLocal(sender.dateValue!!)
        
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
                self.tableView.deselectRow(self.tableView.selectedRow)
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

        var textShouldEndEditing = true
      switch textField.tag
      {
        case 1:
        if (!(textField.stringValue == ""))
        {
          if !Utility.isAlphabetsOnly(textField.stringValue)
          {
            Utility.alertPopup("Error", informativeText: "Please enter alphabetical characters.",isCancelBtnNeeded:false,okCompletionHandler: nil)
            fieldEditor.selectedRange = NSRange.init(location: 0, length:fieldEditor.string!.characters.count)
            textShouldEndEditing = false
            
          }
         else
         {
           candidate.name = fieldEditor.string
         }
           candidateSearchField.enabled = true
       }
        else
        {
          candidate.name = fieldEditor.string
          candidateSearchField.enabled = false
        }
       
        case 2:
        if (!(textField.stringValue == ""))
        {
        let experience = textField.doubleValue
          if !EHOnlyDecimalValueFormatter.isNumberValid(textField.stringValue)
          {
            Utility.alertPopup("Error", informativeText: "Please enter a numerical value for experience.",isCancelBtnNeeded:false,okCompletionHandler:nil)
            fieldEditor.selectedRange = NSRange.init(location: 0, length:fieldEditor.string!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            textShouldEndEditing = false
        }
          else if experience <= 50
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
            fieldEditor.selectedRange = NSRange.init(location: 0, length:fieldEditor.string!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            textShouldEndEditing = false

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
          Utility.alertPopup("Error", informativeText: "Please enter a appropriate mobile number. ",isCancelBtnNeeded:false,okCompletionHandler: nil)
          fieldEditor.selectedRange = NSRange.init(location: 0, length:fieldEditor.string!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
          textShouldEndEditing = false
           
        }
        else if ((fieldEditor.string?.characters.count >= 10) && (fieldEditor.string?.characters.count <= 12))
        {
          candidate.phoneNumber = fieldEditor.string
          self.candidateSearchField.enabled = true
                   }
        else
        {
          Utility.alertPopup("Error", informativeText: "Please enter a 10 digit mobile phone number.",isCancelBtnNeeded:false,okCompletionHandler: nil)
          fieldEditor.selectedRange = NSRange.init(location: 0, length:fieldEditor.string!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
          textShouldEndEditing = false
            
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
            if !Utility.isAlphabetsOnly(textField.stringValue)
            {
                Utility.alertPopup("Error", informativeText: "Please enter alphabetical characters.",isCancelBtnNeeded:false,okCompletionHandler: nil)
                fieldEditor.selectedRange = NSRange.init(location: 0, length:fieldEditor.string!.characters.count)
                textShouldEndEditing = false
            }
            else
            {
                candidate.requisition = fieldEditor.string
            }
            candidateSearchField.enabled = true
        }
        else
        {
            candidate.requisition = fieldEditor.string
            candidateSearchField.enabled = false
        }
        default: break
    }
        if candidate.name != "" && candidate.phoneNumber != ""  && candidate.experience != nil && candidate.requisition != ""
        {
            EHCoreDataHelper.saveToCoreData(candidate)
        }
        return textShouldEndEditing
    }
    
    func deleteCandidate()
    {
      if tableView.selectedRow != -1
      {
        if filteredArray.count > 0
        {
           let can = filteredArray.objectAtIndex(tableView.selectedRow) as! Candidate
           candidateAccessLayer!.removeCandidate(can)
           filteredArray.removeObject(can)
           candidateArray.removeObject(can)
           self.candidateSearchField.stringValue = ""
        }
        else
        {
           candidateAccessLayer!.removeCandidate(candidateArray.objectAtIndex(self.tableView.selectedRow) as! Candidate)
           candidateArray.removeObjectAtIndex(self.tableView.selectedRow)
        }
        feedbackButton.enabled = false
        removeButton.enabled = false
        addCandidateButton.enabled = true
        tableView.reloadData()
      }
    }
    
    override func controlTextDidBeginEditing(obj: NSNotification)
    {
      removeButton.enabled = false
      feedbackButton.enabled = false
    }
    
    func convertGmtToLocal(gmt:NSDate)->NSDate{
        
        let formatter = NSDateFormatter()
        
        formatter.timeZone = NSTimeZone(abbreviation:"IST")
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let s = formatter.stringFromDate(gmt)
        
        let another = NSDateFormatter()
    
        another.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        another.timeZone = NSTimeZone(abbreviation:"GMT")
        
        let localDate = another.dateFromString(s)
        
        return localDate!
        
    }
    
    func scheduleNotification(withDate:NSDate)
    {
        
            print(withDate)
        
            let notification = NSUserNotification()
            
            notification.title = "eHire"
            
            notification.informativeText = "Interview is scheduled for today"
            
            notification.hasActionButton = true
        
            notification.deliveryDate = withDate
            
            notification.soundName = NSUserNotificationDefaultSoundName
        
            center.scheduleNotification(notification)
      
            print(center.scheduledNotifications.count)
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
}
