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
  func showFeedbackViewController()
}

class EHCandidateController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,Callback
{
    //MARK: IBOutlets
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var candidateView: NSView!
    
    //MARK: Properties
    var candidateArray = NSMutableArray()
    var candidateBasicInfo:EHCandidateBasicInfo?
    var candidate:EHCandidateDetails?
    var delegate:FeedbackDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.doubleAction = "performDoubleClickAction"
        candidateBasicInfo   = self.storyboard!.instantiateControllerWithIdentifier("basicInfo") as? EHCandidateBasicInfo
    }
    
    func performDoubleClickAction()
    {
        if tableView.selectedRow != -1
        {
            self.view.addSubview(candidateBasicInfo!.view)
            let editCandidate = candidateArray.objectAtIndex(tableView.selectedRow) as? EHCandidateDetails
            candidateBasicInfo!.delegate = self
            candidateBasicInfo?.nameField.stringValue = editCandidate!.name
            candidateBasicInfo?.experienceField.stringValue = (editCandidate?.experience)!
            candidateBasicInfo?.datePicker.stringValue = (editCandidate?.interViewTime)!
            candidateBasicInfo?.phoneNumField.stringValue = (editCandidate?.phoneNum)!
            candidateBasicInfo?.saveButton.title = "Update"
            self.candidateView.hidden = true
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
        if candidateArray.count > 0
        {
            candidate  = candidateArray[row] as? EHCandidateDetails
        }

        let cell = self.tableView.makeViewWithIdentifier((tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        if tableColumn?.identifier == "name"
        {
            cell.textField?.stringValue = (candidate?.name)!
        }
            
        else if tableColumn?.identifier == "experience"
        {
            cell.textField?.stringValue = (candidate?.experience)!
        }
            
        else if tableColumn?.identifier == "interviewTime"
        {
            cell.textField?.stringValue = (candidate?.interViewTime)!
        }
            
        else
        {
            cell.textField?.stringValue = (candidate?.phoneNum)!
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
       self.view.addSubview(candidateBasicInfo!.view)
       candidateBasicInfo!.delegate = self
       tableView.reloadData()
       self.candidateView.hidden = true
    }
    
    //Delegate Method for Callback Mechanism
    
    func getData(name: String, experience: String, interViewTime: String, phoneNum: String)
    {
        let newCandidate = EHCandidateDetails(inName:name, candidateExperience:experience , candidateInterviewTiming: interViewTime, candidatePhoneNo:phoneNum)
        if name == "" && experience == "" && interViewTime == "" && phoneNum == ""
        {
            self.candidateView.hidden = false
        }
            
        else
        {
            if candidateBasicInfo?.saveButton.title == "Save"
            {
                self.candidateView.hidden = false
                candidateArray.addObject(newCandidate)
            }
            else
            {
                let editCandidate = candidateArray.objectAtIndex(tableView.selectedRow) as? EHCandidateDetails
                editCandidate?.name = name
                editCandidate?.experience = experience
                editCandidate?.interViewTime = interViewTime
                editCandidate?.phoneNum = phoneNum
                self.candidateView.hidden = false
                candidateBasicInfo?.saveButton.title = "Save"
            }
        }
        tableView.reloadData()
    }
    
   @IBAction func removeCandidate(sender: AnyObject)
   {
     if tableView.selectedRow > -1
     {
        candidateArray.removeObjectAtIndex(tableView.selectedRow)
     }
     tableView.reloadData()
  }
    
    @IBAction func showCandidateFeedbackView(sender: AnyObject)
    {
        if let delegate = self.delegate{
            
            delegate.showFeedbackViewController()
        }
    }
}
