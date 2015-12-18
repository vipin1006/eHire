//
//  EXEhireCandidateinfo.swift
//  EXEhireInterView
//
//  Created by Pratibha Sawargi on 10/12/15.
//  Copyright © 2015 Pratibha Sawargi. All rights reserved.
//

import Cocoa

protocol FeedbackDelegate{
    
  func showFeedbackViewController()
    
}

class EHCandidateController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,Callback
{

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var candidateView: NSView!
    
    var candidateArray = [String]()
    var candidateExperianceArray = [String]()
    var candidateInterViewTimingArray = [String]()
    var candidatePhoneNoArray = [String]()
    
    var candidateBasicInfo:EHCandidateBasicInfo?
    var employee:EHCandidateDetails?
    
    var delegate:FeedbackDelegate?
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        candidateBasicInfo   = self.storyboard!.instantiateControllerWithIdentifier("basicInfo") as? EHCandidateBasicInfo
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return candidateArray.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = self.tableView.makeViewWithIdentifier((tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        
        if tableColumn?.identifier == "name"
        {
            cell.textField?.stringValue = candidateArray[row]
            
        }
            
        else if tableColumn?.identifier == "experience"
        {
            cell.textField?.stringValue = candidateExperianceArray[row]
        }
            
        else if tableColumn?.identifier == "interviewTime"
        {
            cell.textField?.stringValue = candidateInterViewTimingArray[row]
        }
            
              else
        {
            cell.textField?.stringValue = candidatePhoneNoArray[row]
        }
             
        return cell
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        return 35
    }
  

    @IBAction func addCandidate(sender: AnyObject)
    {
       self.view.addSubview(candidateBasicInfo!.view)
       candidateBasicInfo!.delegate = self
       tableView.reloadData()
       self.candidateView.hidden = true
        
    }
    
    func getData(name: String, experience: String, interViewTime: String, phoneNum: String)
    {
       if name == "" && experience == "" && interViewTime == "" && phoneNum == ""
       {
         self.candidateView.hidden = false
       }
       else
       {
          self.candidateView.hidden = false
          candidateArray.append(name)
          candidateExperianceArray.append(experience)
          candidateInterViewTimingArray.append(interViewTime)
          candidatePhoneNoArray.append(phoneNum)
          tableView.reloadData()
       }
    }
    
   @IBAction func removeCandidate(sender: AnyObject)
   {
       if tableView.selectedRow > -1
        {
           candidateArray.removeAtIndex(tableView.selectedRow)
           candidateExperianceArray.removeAtIndex(tableView.selectedRow)
           candidateInterViewTimingArray.removeAtIndex(tableView.selectedRow)
           candidatePhoneNoArray.removeAtIndex(tableView.selectedRow)
        }
           tableView.reloadData()
   }
    
    @IBAction func showCandidateFeedbackView(sender: AnyObject) {
        
        print("Its working")
        
        if let delegate = self.delegate{
            
            delegate.showFeedbackViewController()
        }
        
    }
    
 }
