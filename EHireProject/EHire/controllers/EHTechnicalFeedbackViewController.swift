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
    //MARK: IBOutlets
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
    @IBOutlet weak var dateOfInterviewField: NSTextField!
    @IBOutlet weak var modeOfInterview: NSMatrix!
    @IBOutlet weak var recommentationField: NSMatrix!
    
    //MARK: Variables
    var cell : EHRatingsTableCellView?
    var feedback = EHFeedbackViewController()
    var technicalFeedbackModel = EHTechnicalFeedbackModel()
    let dataAccessModel = TechnicalFeedbackDataAccess()
    var name : String?
    var overallTechnicalRating : Int32?
    var overallCandidateRating : Int32?
    var overallCandidateRatingOnSkills : Int?
    var interviewModeState : String?
    var recommentationState : String?
    var skillsAndRatingsTitleArray = [SkillSet]()
    var selectedCandidate : Candidate?
    var feedbackData : [AnyObject]?
    var skillArray = NSMutableArray()
    
    //MARK: initial setup of views
    func initialSetupOfTableView()
    {
         skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"]
        
        for index in 0...3
        {
            let communication = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
            communication.skillName = skillArray.objectAtIndex(index) as? String
           
            skillsAndRatingsTitleArray.append(communication)
        }
       
    }
    
    override func loadView()
    {
        initialSetupOfTableView()
        super.loadView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        candidateNameField.stringValue = (selectedCandidate?.name)!
        requisitionNameField.stringValue = (selectedCandidate?.requisition)!
        cell?.skilsAndRatingsTitlefield.delegate = self
        technicalFeedbackMainView.wantsLayer = true
        technicalFeedbackMainView.layer?.backgroundColor = NSColor.gridColor().colorWithAlphaComponent(0.5).CGColor
        for rating in overallAssessmentOnTechnologyStarView.subviews
        {
            let view = rating as! NSButton
            view.target = self
            view.action = "assessmentOnTechnology:"
        }
        
        for ratingView in overallAssessmentOfCandidateStarView.subviews
        {
            
            let view = ratingView as! NSButton
            view.target = self
            view.action = "assessmentOfCandidate:"
        }
        if selectedCandidate != nil
        {
            if selectedCandidate?.interviewedByTechLeads?.count != 0
            {
            sortArray((selectedCandidate?.interviewedByTechLeads?.allObjects)!,index: 0)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: To sort
    func sortArray (candidateObjects : [AnyObject],index:Int)
    {
        let sortingArray = NSArray(array: candidateObjects)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortedResults: NSArray = sortingArray.sortedArrayUsingDescriptors([descriptor])
        retrievalOfInterviewData(sortedResults[index] as! TechnicalFeedBack)
    }
    
    //MARK: Retrieval Of Round One
    func retrievalOfInterviewData(feedback : TechnicalFeedBack)
    {
        if selectedCandidate != nil
        {
//            for x in (selectedCandidate?.interviewedByTechLeads)!
//            {
                //let feedback1 = x as! TechnicalFeedBack
                textViewOfCandidateAssessment.string = feedback.commentsOnCandidate
                technicalFeedbackModel.ratingOnTechnical = Int32((feedback.ratingOnTechnical?.integerValue)!)
                textViewOfTechnologyAssessment.string = feedback.commentsOnTechnology
                technicalFeedbackModel.ratingOnCandidate = Int32((feedback.ratingOnCandidate?.integerValue)!)
                designationField.stringValue = feedback.designation!
                interviewedByField.stringValue = feedback.techLeadName!
                technicalFeedbackModel.modeOfInterview = feedback.modeOfInterview!
                technicalFeedbackModel.recommendation = feedback.recommendation!
                
                fetchingModeOfInterview(technicalFeedbackModel.modeOfInterview!)
                fetchingRecommendation(technicalFeedbackModel.recommendation!)
                
                skillsAndRatingsTitleArray.removeAll()
                for object in feedback.candidateSkills!
                {
                    let skillset = object as! SkillSet
                    
                    let newSkill = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
                    
                    newSkill.skillName = skillset.skillName
                    newSkill.skillRating = skillset.skillRating
                    skillsAndRatingsTitleArray.append(newSkill)
                }
                
                tableView.reloadData()
                if !(technicalFeedbackModel.ratingOnTechnical == nil)
                {
                    for stars in overallAssessmentOnTechnologyStarView.subviews
                    {
                        let starButton = stars as! NSButton
                        if starButton.tag == (technicalFeedbackModel.ratingOnTechnical! - 1)
                        {
                            let totalView = overallAssessmentOnTechnologyStarView.subviews
                            toDisplayRatingStar(totalView, sender: starButton, feedbackText: self.ratingOnTechnologyField, view: overallAssessmentOnTechnologyStarView)
                        }
                    }
                }
                
                if !(technicalFeedbackModel.ratingOnCandidate == nil)
                {
                    for starBtn in overallAssessmentOfCandidateStarView.subviews
                    {
                        let tempBtn = starBtn as! NSButton
                        let totalView = overallAssessmentOfCandidateStarView.subviews
                        if tempBtn.tag == (technicalFeedbackModel.ratingOnCandidate! - 1)
                        {
                            toDisplayRatingStar(totalView, sender: tempBtn, feedbackText: self.ratingOfCandidateField, view: overallAssessmentOnTechnologyStarView)
                        }
                    }
                }
            }
        //}

    }
    
    //MARK: To Dispaly the Stars
    
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment On Technology
    
    func assessmentOnTechnology(sender : NSButton)
    {
        let totalView = overallAssessmentOnTechnologyStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, feedbackText: ratingOnTechnologyField, view: overallAssessmentOnTechnologyStarView)
    }
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment Of Candidate
    
    func assessmentOfCandidate(sender : NSButton)
    {
        let totalView = overallAssessmentOfCandidateStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, feedbackText: ratingOfCandidateField,view: overallAssessmentOfCandidateStarView)
    }
    
    //MARK: Delegate And DataSource Methods
    // To return tableview rows
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return skillsAndRatingsTitleArray.count
    }
    
    //To returns the height of the tableview row
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 25
    }
    
    // To provide the content for each item of the table view
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cellView : EHRatingsTableCellView = tableView.makeViewWithIdentifier("RatingCell", owner: self) as! EHRatingsTableCellView
        let skill = skillsAndRatingsTitleArray[row]
        cellView.skilsAndRatingsTitlefield.stringValue = skill.skillName!
        cellView.skilsAndRatingsTitlefield.editable = true
        cellView.skilsAndRatingsTitlefield.delegate = self
        cellView.skilsAndRatingsTitlefield.target = self
        cellView.skilsAndRatingsTitlefield.tag = row
        cell = cellView
        if !(skill.skillRating == nil) {
            for starBtn in (cell?.starCustomView.subviews)!{
                let tempBtn = starBtn as! NSButton
                if tempBtn.tag+1 == skill.skillRating
                {
                   toDisplayRatingStar((cell?.starCustomView.subviews)!, sender: tempBtn, feedbackText: cellView.feedback, view: (cell?.starCustomView!)!)
                }
                else
                {
                    tempBtn.image = NSImage(named: "deselectStar")
                    cellView.feedback.stringValue = ""
                    
                }
            }
        }
        for ratingsView in cellView.starCustomView.subviews
        {
            let view = ratingsView as! NSButton
            view.target = self
            view.action = "starRatingCount:"
        }
        return cellView
    }

    // To Display the Alert Message
    
    func alertPopup(data:String, informativeText:String)
    {
        let alert:NSAlert = NSAlert()
        alert.messageText = data
        alert.informativeText = informativeText
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.runModal()
    }
    
    // To Display The Stars inside TableView
    
    func starRatingCount(sender : NSButton)
    {
        let ratingCell = sender.superview?.superview as! EHRatingsTableCellView
        if ratingCell.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
            alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name")
            return
        }
        let totalView = ratingCell.starCustomView.subviews
        toDisplayRatingStar(totalView, sender: sender,feedbackText: ratingCell.feedback,view: ratingCell.starCustomView)
    }
    
    // To Dispaly the Star Rating to Technical&Personality And Overall Assessment On Technology and also for Overall Assessment Of Candidate
    
    func toDisplayRatingStar(totalView : [NSView], sender : NSButton,feedbackText : NSTextField,view : AnyObject)
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
            feedbackText.stringValue = "Not Satisfactory"
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
              overallTechnicalRating = 1
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 1
            }
            
            else if view.superview is EHRatingsTableCellView
            {
                cell = view.superview as? EHRatingsTableCellView
                overallCandidateRatingOnSkills = 1
                let skill = skillsAndRatingsTitleArray[(cell?.skilsAndRatingsTitlefield.tag)!]
                skill.skillRating = overallCandidateRatingOnSkills
            }
        case 1:
            countingOfRatingStar(1)
            feedbackText.stringValue = "Satisfactory"
            countingOfRatingStar(0, deselectStar: 2,3,4)
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 2
            }
            
            if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 2
            }
             else if view.superview is EHRatingsTableCellView
            {
                cell = view.superview as? EHRatingsTableCellView
                overallCandidateRatingOnSkills = 2
                let skill = skillsAndRatingsTitleArray[(cell?.skilsAndRatingsTitlefield.tag)!]
                skill.skillRating = overallCandidateRatingOnSkills
            }
            
        case 2:
            countingOfRatingStar(2)
            feedbackText.stringValue = "Good"
            
            countingOfRatingStar(0, deselectStar: 3,4)
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 3
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 3
            }
             else if view.superview is EHRatingsTableCellView
            {
                cell = view.superview as? EHRatingsTableCellView
                overallCandidateRatingOnSkills = 3
                let skill = skillsAndRatingsTitleArray[(cell?.skilsAndRatingsTitlefield.tag)!]
                
                skill.skillRating = overallCandidateRatingOnSkills
            }
        case 3:
            countingOfRatingStar(3)
            feedbackText.stringValue = "Very Good"
            countingOfRatingStar(0, deselectStar: 4)
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 4
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 4
            }
            else if view.superview is EHRatingsTableCellView
            {
                cell = view.superview as? EHRatingsTableCellView
                overallCandidateRatingOnSkills = 4

                let skill = skillsAndRatingsTitleArray[(cell?.skilsAndRatingsTitlefield.tag)!]
               
                skill.skillRating = overallCandidateRatingOnSkills
            }
            
        case 4:
            countingOfRatingStar(4)
            feedbackText.stringValue = "Excellent"
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 5
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 5
            }
            else if view.superview is EHRatingsTableCellView
            {
                cell = view.superview as? EHRatingsTableCellView
                
                overallCandidateRatingOnSkills = 5
                let skill = skillsAndRatingsTitleArray[(cell?.skilsAndRatingsTitlefield.tag)!]
                skill.skillRating = overallCandidateRatingOnSkills
            }
            
           default : print("")
        }
    }
    
    //MARK: TextField Delegate method
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        let skill = skillsAndRatingsTitleArray[self.tableView.selectedRow]
        skill.skillName = fieldEditor.string
        return true
    }
    
    //MARK: Button Actions
    //To add new skills inside TableView
    
    @IBAction func addSkills(sender: NSButton)
    {
        if skillsAndRatingsTitleArray.count > 0 && cell?.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
            alertPopup("Enter Title", informativeText: "Please enter previous selected title")
        }
        else
        {
            let newSkill = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
            
                newSkill.skillName = "Enter Title"
                newSkill.skillRating = 0
                self.skillsAndRatingsTitleArray.append(newSkill)
                tableView.reloadData()
        }
    }
    //ModeOfInterview Action
    @IBAction func modeOfInterviewAction(sender: NSMatrix)
    {
        if (sender.selectedCell() == sender.cells[0])
        {
            interviewModeState = sender.cells[0].title
        }
        else
        {
            interviewModeState = sender.cells[1].title
        }
    }
    
    //Recommentation Field Action
    @IBAction func recommentationAction(sender: AnyObject)
    {
        if (sender.selectedCell() == sender.cells[0])
        {
            recommentationState = sender.cells[0].title
        }
        else
        {
            recommentationState = sender.cells[1].title
        }
    }
    
    //To remove the existing skills inside TableView

    @IBAction func removeSkills(sender: NSButton)
    {
        if tableView.selectedRow != -1
        {
            skillsAndRatingsTitleArray.removeAtIndex(tableView.selectedRow)
            tableView.reloadData()
        }
    }
    
    // To save details of Technical Feedback
    
    @IBAction func saveDetailsAction(sender: NSButton)
    {
        let selectedMode = modeOfInterview.selectedColumn
        if selectedMode != 0
        {
            interviewModeState = "Face To Face"
        }else
        {
            interviewModeState = "Telephonic"
        }
        
        let selectedColoumn = recommentationField.selectedColumn
        if selectedColoumn != 0
        {
            recommentationState = "Rejected"
        }else
        {
            recommentationState = "Shortlisted"
        }

        if validation()
        {
        technicalFeedbackModel.modeOfInterview      = interviewModeState
        technicalFeedbackModel.skills = skillsAndRatingsTitleArray as [SkillSet]
        technicalFeedbackModel.commentsOnTechnology = textViewOfTechnologyAssessment.string
        technicalFeedbackModel.ratingOnTechnical    = overallTechnicalRating
        technicalFeedbackModel.commentsOnCandidate  = textViewOfCandidateAssessment.string
        technicalFeedbackModel.ratingOnCandidate    = overallCandidateRating
        technicalFeedbackModel.recommendation       = recommentationState
        technicalFeedbackModel.designation          = designationField.stringValue
        technicalFeedbackModel.techLeadName         = interviewedByField.stringValue
      
         if dataAccessModel.insertIntoTechnicalFeedback(technicalFeedbackModel, selectedCandidate: selectedCandidate!)
          {
            alertPopup("Data Saved", informativeText: "Saved Successfully")
          }
          else
          {
            alertPopup("Data not Saved", informativeText: "Some Problem is there while saving")
          }
        }
    }
    
    //MARK:- Setting Matrix Value
    func fetchingModeOfInterview(value : String)
    {
        if value == "Telephonic"
        {
            modeOfInterview.setState(NSOnState, atRow: 0, column: 0)
            modeOfInterview.setState(NSOffState, atRow: 0, column: 1)
            
        }else{
            modeOfInterview.setState(NSOnState, atRow: 0, column: 1)
            modeOfInterview.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    func fetchingRecommendation(value : String)
    {
        if value == "Shortlisted"
        {
            recommentationField.setState(NSOnState, atRow: 0, column: 0)
            recommentationField.setState(NSOffState, atRow: 0, column: 1)
            
        }else{
            recommentationField.setState(NSOnState, atRow: 0, column: 1)
            recommentationField.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    //MARK: Validation
    func validation() -> Bool
    {
      let isValid = false
        
        if cell?.feedback.stringValue == ""
        {
            alertPopup("Select Stars", informativeText: "Please select stars inside tableview to provide your feedback")
            return isValid
        }
            
        else if ratingOnTechnologyField.stringValue == ""
        {
            alertPopup("Select Stars", informativeText: "Please select stars to provide your feedback inside overall assessment on Technology")
            return isValid
        }
            
        else if ratingOfCandidateField.stringValue == ""
        {
            alertPopup("Select Stars", informativeText: "Please select stars to provide your feedback inside overall assessment of Candidate")
            return isValid
        }
            
        else if textViewOfTechnologyAssessment.string == ""
        {
            alertPopup("Overall Feedback On Technology", informativeText: "Please enter your feedback on Technology")
            return isValid
        }
            
        else if textViewOfCandidateAssessment.string == ""
        {
            alertPopup("Overall Feedback Of Candidate", informativeText: "Overall assessment of Candidate field shold not be blank")
            return isValid
        }
            
        else if designationField.stringValue == ""
        {
            alertPopup("Designation of Candidate", informativeText: "Designation Field should not be blank")
            return isValid
        }
            
        else if interviewedByField.stringValue.characters.count == 0
        {
            alertPopup("Interviewer Name", informativeText: "Please enter the interviewer field should not be blank")
            return isValid
        }
        else if overallCandidateRating == 0
        {
             alertPopup("Overall CandidateRating", informativeText: "Please provide your feedback of Candidate should not be blank")
            return isValid
        }
        else if overallTechnicalRating == 0
        {
            alertPopup("Overall TechnicalRating", informativeText: "Please provide your feedback on Technology should not be blank")
            return isValid
        }
        else
        {
            return true
        }
    }
    
    //MARK: Refresh
    
    func refreshAllFields()
    {
      textViewOfCandidateAssessment.string = ""
      textViewOfTechnologyAssessment.string = ""
      designationField.stringValue = ""
      interviewedByField.stringValue = ""
      fetchingModeOfInterview("Face To Face")
      fetchingRecommendation("Rejected")
      technicalFeedbackModel.ratingOnCandidate = 0
      technicalFeedbackModel.ratingOnTechnical = 0
      skillsAndRatingsTitleArray.removeAll()
      initialSetupOfTableView()
      tableView.reloadData()
        
      ratingOfCandidateField.stringValue = ""
      ratingOnTechnologyField.stringValue = ""
        for stars in overallAssessmentOfCandidateStarView.subviews
        {
            let starButton = stars as! NSButton
            starButton.image = NSImage(named: "deselectStar")
        }
        for stars in overallAssessmentOnTechnologyStarView.subviews
        {
            let starButton = stars as! NSButton
            starButton.image = NSImage(named: "deselectStar")
        }
   }
}
