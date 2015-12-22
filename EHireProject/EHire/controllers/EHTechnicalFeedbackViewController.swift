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
    //IBOutlets
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
    @IBOutlet weak var candidateNameField: NSTextField!
    @IBOutlet weak var requisitionNameField: NSTextField!
    @IBOutlet weak var modeOfInterviewField: NSMatrix!
    @IBOutlet weak var dateOfInterviewField: NSTextField!
    
    //Variables
    var skillsAndRatingsTitleArray = NSMutableArray()
    var cell : EHRatingsTableCellView?
    var technicalFeedbackDetails = [String : Any]()
    
    //initial setup of view to load the basic views of Technical Feedback.
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        technicalFeedbackMainView.wantsLayer = true
        technicalFeedbackMainView.layer?.backgroundColor = NSColor.gridColor().colorWithAlphaComponent(0.5).CGColor
        
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
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
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
        func countingOfRatingStar(total : Int, deselectStar : Int?...)
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
            countingOfRatingStar(0)
            label.stringValue = "Not Satisfactory"
            
        case 1:
            countingOfRatingStar(1)
            label.stringValue = "Satisfactory"
            countingOfRatingStar(0, deselectStar: 2,3,4)
            
        case 2:
            countingOfRatingStar(2)
            label.stringValue = "Good"
            
            countingOfRatingStar(0, deselectStar: 3,4)
            
        case 3:
            countingOfRatingStar(3)
            label.stringValue = "Very Good"
            countingOfRatingStar(0, deselectStar: 4)
            
        case 4:
            countingOfRatingStar(4)
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
       technicalFeedbackDetails["commentsOnTechnology"] = textViewOfTechnologyAssessment.string
       technicalFeedbackDetails["commentsOfCandidate"] = textViewOfCandidateAssessment.string
        
       if TechnicalFeedBack.technicalFeedbackDetails(technicalFeedbackDetails)
       {
         print("Saved")
       }
        else
       {
        print ("Not saved")
        }
    }
    
    //To give Color to the SubViews
    func setBoarderColor(subView:NSTextField)
    {
        subView.wantsLayer = true
        subView.layer?.borderColor = NSColor.orangeColor().CGColor
        subView.layer?.borderWidth = 2
    }
    func setBoarderColorForTextView(subView:NSTextView)
    {
        subView.wantsLayer = true
        subView.layer?.borderColor = NSColor.orangeColor().CGColor
        subView.layer?.borderWidth = 2
    }

    
    // Mark: To Validate all fields of Technical Feedback Controller

    func validateFields()
    {
//        if candidateNameField.stringValue == ""
//        {
//            setBoarderColor(candidateNameField)
//        }
//        else if requisitionNameField.stringValue == ""
//        {
//            setBoarderColor(requisitionNameField)
//        }
//        else if dateOfInterviewField.stringValue == ""
//        {
//            setBoarderColor(dateOfInterviewField)
//        }
        
        if textViewOfTechnologyAssessment.string == ""
        {
            setBoarderColorForTextView(textViewOfTechnologyAssessment)
        }
        else if ratingOnTechnologyField.stringValue == ""
        {
            setBoarderColor(ratingOnTechnologyField)
        }
        else if textViewOfTechnologyAssessment.string?.characters.count < 5
        {
             setBoarderColorForTextView(textViewOfTechnologyAssessment)
        }
            
        else if textViewOfCandidateAssessment.string == ""
        {
            setBoarderColorForTextView(textViewOfCandidateAssessment)
        }
            
        else if textViewOfCandidateAssessment.string?.characters.count < 5
        {
            setBoarderColorForTextView(textViewOfCandidateAssessment)
        }
        else if ratingOfCandidateField.stringValue == ""
        {
            setBoarderColor(ratingOfCandidateField)
        }
        
        else if designationField.stringValue == ""
        {
            setBoarderColor(designationField)
        }
            
        else if designationField.stringValue.characters.count < 8
        {
            setBoarderColor(designationField)
        }
            
        else if interviewedByField.stringValue == ""
        {
            setBoarderColor(interviewedByField)
        }
            
        else if interviewedByField.stringValue.characters.count < 3
        {
            setBoarderColor(interviewedByField)
        }
    }
    
}
