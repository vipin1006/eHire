//
//  EHTechnicalFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnicalFeedbackViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate
{
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet var technicalFeedbackMainView: NSView!
    
    @IBOutlet var textViewOfTechnologyAssessment: NSTextView!
    
    @IBOutlet var textViewOfCandidateAssessment: NSTextView!
    
    @IBOutlet weak var designationField: NSTextField!
    
    @IBOutlet weak var interviewedByField: NSTextField!
    
    @IBOutlet weak var ratingOfCandidateField: NSTextField!
    
    @IBOutlet weak var ratingOnTechnologyField: NSTextField!
    
    @IBOutlet weak var overallAssessmentOfCandidateStarView: NSView!
    
    @IBOutlet weak var overallAssessmentOnTechnologyStarView: NSView!
    
    var skillsAndRatingsTitleArray = NSMutableArray()
    var cell : EHRatingsTableCellView?
    
    //initial setup of view to load the basic views of Technical Feedback
    
    override func viewDidLoad() {
        super.viewDidLoad()
        technicalFeedbackMainView.wantsLayer = true
        technicalFeedbackMainView.layer?.backgroundColor = NSColor.gridColor().colorWithAlphaComponent(0.5).CGColor
        
        tableView.headerView?.wantsLayer = true
        tableView.headerView?.layer?.backgroundColor = NSColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        
        self.ratingOfCandidateField.delegate = self
        self.ratingOnTechnologyField.delegate = self
        
        for rating in overallAssessmentOnTechnologyStarView.subviews
        {
            let view = rating as! NSButton
            view.target = self
            view.action = "accessmentOnTechnology:"
        }
        
        for ratingView in overallAssessmentOfCandidateStarView.subviews
        {
            let view = ratingView as! NSButton
            view.target = self
            view.action = "accessmentOfCandidate:"
        }
        if skillsAndRatingsTitleArray.count == 0
        {
            self.skillsAndRatingsTitleArray.addObject("Communication")
            self.skillsAndRatingsTitleArray.addObject("Organisation Stability")
            self.skillsAndRatingsTitleArray.addObject("Leadership(if applicable)")
            self.skillsAndRatingsTitleArray.addObject("Growth Potential")
        }
        tableView.reloadData()
    }
    
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment On Technology
    
    func accessmentOnTechnology(sender : NSButton)
    {
        let totalView = overallAssessmentOnTechnologyStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, label: ratingOnTechnologyField)
    }
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment Of Candidate
    
    func accessmentOfCandidate(sender : NSButton)
    {
        let totalView = overallAssessmentOfCandidateStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, label: ratingOfCandidateField)
    }
    
    //MARK: This data source method returns tableview rows
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return skillsAndRatingsTitleArray.count
    }
    
    //MARK: This method returns the height of the tableview row
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25
    }
    
    //Mark: This delegate method provides the content for each item of the table view
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cellView : EHRatingsTableCellView?
        cellView = tableView.makeViewWithIdentifier("RatingCell", owner: self) as? EHRatingsTableCellView
        cellView?.skilsAndRatingsTitlefield.stringValue = skillsAndRatingsTitleArray.objectAtIndex(row) as! String
        cellView?.skilsAndRatingsTitlefield.editable = true
        cellView?.skilsAndRatingsTitlefield.delegate = self
        cellView?.skilsAndRatingsTitlefield.target = self
        cellView?.skilsAndRatingsTitlefield.tag = row
        cell = cellView
        for ratingsView in cellView!.starCustomView.subviews
        {
            let view = ratingsView as! NSButton
            view.target = self
            view.action = "starRatingCount:"
        }
        
        return cellView
    }
    
    //Mark: To Display the Alert Message
    
    func alertPopup(data:String, informativeText:String)
    {
        let alert:NSAlert = NSAlert()
        alert.messageText = data
        alert.informativeText = informativeText
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.runModal()
    }
    
    //Mark: To Display The Stars inside TableView
    
    func starRatingCount(sender : NSButton)
    {
        let ratingCell = sender.superview?.superview as! EHRatingsTableCellView
        if ratingCell.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
            alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name")
            return
        }
        
        let totalView = ratingCell.starCustomView.subviews
        
        toDisplayRatingStar(totalView, sender: sender,label: ratingCell.feedback)
    }
    
    //MARK: To Dispaly the Star Rating to Technical&Personality And Overall Assessment On Technology and also for Overall Assessment Of Candidate
    
    func toDisplayRatingStar(totalView : [NSView], sender : NSButton,label : NSTextField)
    {
        func countingOfRatingStarr(total : Int, deselectStar : Int?...)
        {
            if deselectStar.count == 0
            {
                if total == 0
                {
                    sender.image = NSImage(named: "selectStar")
                    
                    for starCount in 1...4
                    {
                        let countOfBtn = totalView[starCount] as! NSButton
                        if countOfBtn.image?.name() == "selectStar"
                        {
                            countOfBtn.image = NSImage(named: "deselectStar")
                        }
                    }
                }
                else
                {
                    for countOfStar in 0...total
                    {
                        let countOfBtn = totalView[countOfStar] as! NSButton
                        if countOfBtn.image?.name() == "deselectStar"
                        {
                            countOfBtn.image = NSImage(named: "selectStar")
                        }
                    }
                }
            }
            else
            {
                for stars in deselectStar
                {
                    let star = totalView[stars!] as! NSButton
                    if star.image?.name() == "selectStar"
                    {
                        star.image = NSImage(named: "deselectStar")
                    }
                }
            }
        }
        if sender.image?.name() == "selectStar"
        {
            sender.image = NSImage(named: "deselectStar")
        }
        else
        {
            sender.image = NSImage(named: "selectStar")
        }
        
        
        switch (sender.tag)
        {
            
        case 0:
            countingOfRatingStarr(0)
            
            label.stringValue = "Not Satisfactory"
            
        case 1:
            countingOfRatingStarr(1)
            label.stringValue = "Satisfactory"
            
            countingOfRatingStarr(0, deselectStar: 2,3,4)
            
        case 2:
            countingOfRatingStarr(2)
            
            label.stringValue = "Good"
            
            countingOfRatingStarr(0, deselectStar: 3,4)
            
        case 3:
            countingOfRatingStarr(3)
            
            label.stringValue = "Very Good"
            
            countingOfRatingStarr(0, deselectStar: 4)
            
        case 4:
            countingOfRatingStarr(4)
            
            label.stringValue = "Excellent"
            
        default : print("")
        }
    }
    
    //MARK: TextField Delegate methods
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        skillsAndRatingsTitleArray[control.tag] = fieldEditor.string!
        return true
    }
    
    // Mark: To add new skills inside TableView
    
    @IBAction func addSkills(sender: NSButton) {
        
        if skillsAndRatingsTitleArray.count > 0 && cell?.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
            alertPopup("Enter Title", informativeText: "Please enter previous selected title")
        }
        else
        {
            skillsAndRatingsTitleArray.addObject("Enter Title")
            tableView.reloadData()
        }
    }
    
    // Mark: To remove the existing skills inside TableView

    @IBAction func removeSkills(sender: NSButton) {
        if tableView.selectedRow != -1
        {
            skillsAndRatingsTitleArray.removeObjectAtIndex(tableView.selectedRow)
            tableView.reloadData()
        }
    }
    
    // Mark: To save details of Technical Feedback
    
    @IBAction func saveDetailsAction(sender: NSButton)
    {
        validateFields()
    }
    
    // Mark: To Validate all fields of Technical Feedback Controller

    func validateFields()
    {
        
        if cell?.feedback.stringValue == ""
        {
            alertPopup("Select Stars", informativeText: "Please select stars inside tableview to provide your feedback")
        }
            
        else if ratingOnTechnologyField.stringValue == ""
        {
            alertPopup("Select Stars", informativeText: "Please select stars to provide your feedback inside overall assessment on Technology")
        }
            
        else if ratingOfCandidateField.stringValue == ""
        {
            alertPopup("Select Stars", informativeText: "Please select stars to provide your feedback inside overall assessment of Candidate")
        }
            
        else if textViewOfTechnologyAssessment.string == ""
        {
            alertPopup("Overall Feedback On Technology", informativeText: "Please enter your feedback on Technology")
        }
        else if textViewOfTechnologyAssessment.string?.characters.count < 5
        {
            alertPopup("Overall Feedback On Technology", informativeText: "Overall assessment on Technology field length shoud be more than 5 charaters")
        }
            
        else if textViewOfCandidateAssessment.string == ""
        {
            alertPopup("Overall Feedback Of Candidate", informativeText: "Overall assessment of Candidate field shold not be blank")
        }
            
        else if textViewOfCandidateAssessment.string?.characters.count < 5
        {
            alertPopup("Overall Feedback Of Candidate", informativeText: "Overall assessment of Candidate field length shoud be more than 5 charaters")
        }
            
        else if designationField.stringValue == ""
        {
            alertPopup("Designation of Candidate", informativeText: "Designation Field should not be blank")
        }
            
        else if designationField.stringValue.characters.count < 8
        {
            alertPopup("Designation of Candidate", informativeText: "Designation of the Candidate length should be more than 8 Character")
        }
            
        else if interviewedByField.stringValue.characters.count == 0
        {
            alertPopup("Interviewer Name", informativeText: "Please enter the interviewer field should not be blank")
        }
            
        else if interviewedByField.stringValue.characters.count < 3
        {
            alertPopup("Interviewer Name", informativeText: "Interviewer Name should be more than 3 character")
        }
    }
    
}
