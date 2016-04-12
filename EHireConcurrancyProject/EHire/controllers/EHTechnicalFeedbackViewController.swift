//
//  EHTechnicalFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnicalFeedbackViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate,NSTextViewDelegate
{
    //MARK: IBOutlets
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var technicalFeedbackMainView: NSView!
    @IBOutlet var textViewOfTechnologyAssessment: NSTextView!
    @IBOutlet var textViewOfCandidateAssessment: NSTextView!
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
    @IBOutlet weak var addNewSkill: NSButton!
    @IBOutlet weak var deleteExistingSkill: NSButton!
    
    //MARK: Variables
    var cell : EHRatingsTableCellView?
    var feedbackControl = EHFeedbackViewController()
    var technicalFeedbackModel = EHTechnicalFeedbackModel()
    let dataAccessModel = EHTechnicalFeedbackDataAccess()
    var name : String?
    var overallCandidateRatingOnSkills : Int?
    var skillsAndRatingsTitleArray = [SkillSet]()
    var selectedCandidate : Candidate?
    var feedbackData : [AnyObject]?
    var skillArray = NSMutableArray()
    var selectedRound : Int?
    var isFeedBackSaved : Bool?
    var managedObjectContext : NSManagedObjectContext?
    var technicalFeedbackObject:TechnicalFeedBack?
    var arrTemp = ["a","b","c","d"]
    var defaultSkills : String? = ""
    
    //MARK: initial setup of views
    func initialSetupOfTableView()
    {
        skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"]

        dataAccessModel.createdefaultSkillSetObject(skillArray,feedBackControllerObj: self,andCallBack:
            {(communication)->Void in
                              self.skillsAndRatingsTitleArray = communication as [SkillSet]
                self.tableView.reloadData()
            
            })
    }
    
    func test()
    {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(EHTechnicalFeedbackViewController.test), object: nil)
        if arrTemp.count==0
        {
            if self.selectedCandidate != nil
            {
                if self.selectedCandidate?.interviewedByTechLeads?.count != 0
                {
                   self.sortArray((self.selectedCandidate?.interviewedByTechLeads?.allObjects)!,index: 0)
                }
                else
                {
                    self.isFeedBackSaved = false
                    self.tableView.reloadData()
                }
             }
        }
        else
        {
            self.performSelector(#selector(EHTechnicalFeedbackViewController.test), withObject: nil, afterDelay: 0.10)
        }
    }
    
    override func loadView()
    {
        dataAccessModel.managedObjectContext = self.managedObjectContext
        initialSetupOfTableView()
        super.loadView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        feedbackControl.clearButton.enabled = false
        
        self.performSelector(#selector(EHTechnicalFeedbackViewController.test), withObject: nil, afterDelay: 0.01)
        candidateNameField.stringValue = (selectedCandidate?.name)!
        requisitionNameField.stringValue = (selectedCandidate?.requisition)!
        print(selectedCandidate?.interviewDate)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateInStringFormat = dateFormatter.stringFromDate((selectedCandidate?.interviewDate)!)
        dateOfInterviewField.stringValue = dateInStringFormat
        
        cell?.skilsAndRatingsTitlefield.delegate = self
        
        for rating in overallAssessmentOnTechnologyStarView.subviews
        {
            let view = rating as! NSButton
            view.target = self
            view.action = #selector(EHTechnicalFeedbackViewController.assessmentOnTechnology(_:))
        }
        
        for ratingView in overallAssessmentOfCandidateStarView.subviews
        {
            let view = ratingView as! NSButton
            view.target = self
            view.action = #selector(EHTechnicalFeedbackViewController.assessmentOfCandidate(_:))
        }
        setDefaultValues()
        selectedRound = 0
    }
    
    func setDefaultValues()
    {
    technicalFeedbackModel.modeOfInterview = "Face To Face"
    technicalFeedbackModel.recommendation = "Shortlisted"
    technicalFeedbackModel.commentsOnCandidate = ""
    technicalFeedbackModel.commentsOnTechnology = ""
    technicalFeedbackModel.techLeadName = ""
    technicalFeedbackModel.ratingOnTechnical = 0
    technicalFeedbackModel.ratingOnCandidate = 0
    }
    
    //MARK: To Sort
    func sortArray (candidateObjects : [AnyObject],index:Int)
    {
        isFeedBackSaved = true
        selectedRound = index
        let sortingArray = NSArray(array: candidateObjects)
        let descriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortedResults = sortingArray.sortedArrayUsingDescriptors([descriptor])
        retrievalOfInterviewData(sortedResults[index] as! TechnicalFeedBack)
    }
    
    //MARK: Retrieval Of Interview feedback Details
    func retrievalOfInterviewData(feedback : TechnicalFeedBack)
    {
          if selectedCandidate != nil
            {
                feedbackControl.clearButton.enabled = false
                technicalFeedbackObject = feedback
                textViewOfCandidateAssessment.string = feedback.commentsOnCandidate
                technicalFeedbackModel.ratingOnTechnical = Int16((feedback.ratingOnTechnical?.integerValue)!)
                textViewOfTechnologyAssessment.string = feedback.commentsOnTechnology
                technicalFeedbackModel.ratingOnCandidate = Int16((feedback.ratingOnCandidate?.integerValue)!)
                interviewedByField.stringValue = feedback.techLeadName!
                technicalFeedbackModel.modeOfInterview = feedback.modeOfInterview!
                technicalFeedbackModel.recommendation = feedback.recommendation!
                
                technicalFeedbackModel.isFeedbackSubmitted = feedback.isFeedbackSubmitted
                fetchingModeOfInterview(technicalFeedbackModel.modeOfInterview!)
                fetchingRecommendation(technicalFeedbackModel.recommendation!)
                disableAndEnableFields((technicalFeedbackModel.isFeedbackSubmitted?.boolValue)!)
                self.skillsAndRatingsTitleArray.removeAll()
                
                if isFeedBackSaved == true
                {
                    dataAccessModel.createSavedSkillSetObject(feedback,skillSetArray: (feedback.candidateSkills?.allObjects)!, andCallBack: { (newSkill) -> Void in
                         self.skillsAndRatingsTitleArray = newSkill as [SkillSet]
                        self.tableView.reloadData()
                    })
   
                }
                else
                {
                    for object in feedback.candidateSkills!
                    {
                        let skillset = object as! SkillSet
                        
                        dataAccessModel.createSkillSetObject({ (newSkill) -> Void in
                            newSkill.skillName   = skillset.skillName
                            newSkill.skillRating = skillset.skillRating
                            self.skillsAndRatingsTitleArray.append(newSkill)
                            if feedback.candidateSkills?.count == self.skillsAndRatingsTitleArray.count{
                                self.tableView.reloadData()
                            }

                        })
                        
                        }
                }
                
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
     }
    
    func disableAndEnableFields(isDataSubmitted : Bool)
    {
        if isDataSubmitted == true
        {
        //To Disable All fields
        feedbackControl.clearButton.enabled = false
        feedbackControl.submitButton.enabled = false
        addNewSkill.enabled = false
        deleteExistingSkill.enabled = false
        interviewedByField.editable = false
        textViewOfCandidateAssessment.editable = false
        textViewOfTechnologyAssessment.editable = false
        modeOfInterview.enabled = false
        recommentationField.enabled = false
        for starButton in (overallAssessmentOfCandidateStarView.subviews)
        {
            let stars = starButton as! NSButton
            stars.enabled = false
        }
        for starButton in (overallAssessmentOnTechnologyStarView.subviews)
        {
            let stars = starButton as! NSButton
            stars.enabled = false
        }
        }
        else
        {
        //To Enable All fields
        addNewSkill.enabled = true
        deleteExistingSkill.enabled = true
        feedbackControl.submitButton.enabled = true
        interviewedByField.editable = true
        textViewOfCandidateAssessment.editable = true
        textViewOfTechnologyAssessment.editable = true
        modeOfInterview.enabled = true
        recommentationField.enabled = true
        for starButton in (overallAssessmentOfCandidateStarView.subviews)
        {
            let stars = starButton as! NSButton
            stars.enabled = true
        }
        for starButton in (overallAssessmentOnTechnologyStarView.subviews)
        {
            let stars = starButton as! NSButton
            stars.enabled = true
        }
        }
    }
    
    //MARK: To Dispaly the Stars
    
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment On Technology
    
    func assessmentOnTechnology(sender : NSButton)
    {
        let totalView = overallAssessmentOnTechnologyStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, feedbackText: ratingOnTechnologyField, view: overallAssessmentOnTechnologyStarView)
         if isFeedBackSaved == false
         {
         feedbackControl.clearButton.enabled = true
         }
    }
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment Of Candidate
    
    func assessmentOfCandidate(sender : NSButton)
    {
        let totalView = overallAssessmentOfCandidateStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, feedbackText: ratingOfCandidateField,view: overallAssessmentOfCandidateStarView)
        if isFeedBackSaved == false
        {
         feedbackControl.clearButton.enabled = true
        }
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
        cellView.skilsAndRatingsTitlefield.delegate = self
        cellView.skilsAndRatingsTitlefield.target = self
        cellView.skilsAndRatingsTitlefield.tag = row
        cell = cellView
        if cell!.skilsAndRatingsTitlefield.stringValue == "Communication" || cell!.skilsAndRatingsTitlefield.stringValue == "Organisation Stability" || cell!.skilsAndRatingsTitlefield.stringValue == "Leadership(if applicable)" || cell!.skilsAndRatingsTitlefield.stringValue == "Growth Potential"
        {
            cell!.skilsAndRatingsTitlefield.editable = false
        }
        else
        {
         cell!.skilsAndRatingsTitlefield.editable = true
        }
        
        if !(skill.skillRating == nil)
        {
            for stars in (cell?.starCustomView.subviews)!
            {
                let starButton = stars as! NSButton
                if starButton.tag+1 == skill.skillRating
                {
                    toDisplayRatingStar((cell?.starCustomView.subviews)!, sender: starButton, feedbackText: cellView.feedback, view: (cell?.starCustomView!)!)
                    break
                }
                else
                {
                    starButton.image = NSImage(named: "deselectStar")
                    cellView.feedback.stringValue = ""
                }
            }
            if tableView.numberOfRows > 7
            {
                tableView.scrollToEndOfDocument("")
            }
        }
        
        for ratingsView in cellView.starCustomView.subviews
        {
            let feedbackview = ratingsView as! NSButton
            
            if technicalFeedbackModel.isFeedbackSubmitted == true
            {
                feedbackview.enabled = false
                cellView.skilsAndRatingsTitlefield.selectable = false
                cellView.feedback.enabled = false
            }
            else
            {
                feedbackview.enabled = true
                cellView.skilsAndRatingsTitlefield.enabled = true
                cellView.feedback.enabled = true
            }
            feedbackview.target = self
            feedbackview.action = #selector(EHTechnicalFeedbackViewController.starRatingCount(_:))
        }   
        return cellView
    }
    
    func tableViewSelectionIsChanging(notification: NSNotification)
    {
        if isFeedBackSaved == false
        {
            feedbackControl.clearButton.enabled = true
        }
        if tableView.selectedRow != -1
        {
            let cellSelected = notification.object?.viewAtColumn(0, row: tableView.selectedRow, makeIfNecessary: true) as! EHRatingsTableCellView
            defaultSkills = cellSelected.skilsAndRatingsTitlefield.stringValue
            if cellSelected.skilsAndRatingsTitlefield.stringValue == "Communication" || cellSelected.skilsAndRatingsTitlefield.stringValue == "Organisation Stability" || cellSelected.skilsAndRatingsTitlefield.stringValue == "Leadership(if applicable)" || cellSelected.skilsAndRatingsTitlefield.stringValue == "Growth Potential"
            {
                tableView.selectionHighlightStyle = .None
                cellSelected.skilsAndRatingsTitlefield.editable = false
                deleteExistingSkill.enabled = false
            }
            else
            {
                if isFeedBackSaved == false
                {
                    tableView.selectionHighlightStyle = .Regular
                    deleteExistingSkill.enabled = true
                    cellSelected.skilsAndRatingsTitlefield.editable = true
                }
                else if isFeedBackSaved == true
                {
                    deleteExistingSkill.enabled = false
                }
                else
                {
                    tableView.selectionHighlightStyle = .Regular
                    deleteExistingSkill.enabled = true
                    cellSelected.skilsAndRatingsTitlefield.editable = true
                }
            }
        }
    }
    
    func textDidChange(notification: NSNotification)
    {
        if isFeedBackSaved == false
        {
          feedbackControl.clearButton.enabled = true
        }
    }
    
    // To Display The Stars inside TableView
    func starRatingCount(sender : NSButton)
    {
        if isFeedBackSaved == false
        {
         feedbackControl.clearButton.enabled = true
        }
        let ratingCell = sender.superview?.superview as! EHRatingsTableCellView
        if ratingCell.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
            Utility.alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name",isCancelBtnNeeded:false, okCompletionHandler: nil)
            return
        }
        else if ratingCell.skilsAndRatingsTitlefield.stringValue == ""
        {
            Utility.alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name",isCancelBtnNeeded:false, okCompletionHandler: nil)
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
              technicalFeedbackModel.ratingOnTechnical = 1
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                technicalFeedbackModel.ratingOnCandidate = 1
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
                technicalFeedbackModel.ratingOnTechnical = 2
            }
            
            if view as! NSView == overallAssessmentOfCandidateStarView
            {
                technicalFeedbackModel.ratingOnCandidate = 2
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
                technicalFeedbackModel.ratingOnTechnical = 3
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                technicalFeedbackModel.ratingOnCandidate = 3
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
                technicalFeedbackModel.ratingOnTechnical = 4
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                technicalFeedbackModel.ratingOnCandidate = 4
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
                technicalFeedbackModel.ratingOnTechnical = 5
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                technicalFeedbackModel.ratingOnCandidate = 5
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
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        return true
    }
    
    override func controlTextDidBeginEditing(obj: NSNotification)
    {
        obj.object as! NSTextField
        if isFeedBackSaved == false
        {
        feedbackControl.clearButton.enabled = true
        }
        deleteExistingSkill.enabled = false
    }
    override func controlTextDidEndEditing(obj: NSNotification)
    {
        deleteExistingSkill.enabled = false
        let textFieldObject = obj.object as! NSTextField
        if textFieldObject.superview is EHRatingsTableCellView
        {
           if skillsAndRatingsTitleArray.count > 4
            {
               let skillSetObject =  skillsAndRatingsTitleArray[textFieldObject.tag]
               skillSetObject.skillName = textFieldObject.stringValue
            }
        }
    }
   
    //MARK: Button Actions
    //To add new skills inside TableView
    
    @IBAction func addSkills(sender: NSButton)
    {
        deleteExistingSkill.enabled = false
        if cell?.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
           Utility.alertPopup("Enter Title", informativeText: "Please enter previous selected title",isCancelBtnNeeded:false, okCompletionHandler: nil)
        }
        else if  cell?.skilsAndRatingsTitlefield.stringValue == ""
        {
            Utility.alertPopup("Enter Title", informativeText: "Skill name should not be blank",isCancelBtnNeeded:false, okCompletionHandler: nil)
        }
        else
        {
           if isFeedBackSaved == true
           {
            dataAccessModel.createSkillSetWithTechnicalManagerObject(technicalFeedbackObject!, andCallBack:
                { (newSkill) -> Void in
                    newSkill.skillName = "Enter Title"
                    self.skillsAndRatingsTitleArray.append(newSkill)
                    self.tableView.reloadData()
                    self.setSkillNameTextfieldAsFirstReponder()
                })
           }
            else
            {
            dataAccessModel.createSkillSetObject({(newSkill)->Void in
            newSkill.skillName = "Enter Title"
            self.skillsAndRatingsTitleArray.append(newSkill)
            self.tableView.reloadData()
            self.setSkillNameTextfieldAsFirstReponder()
             })
            }
         }
    }
    func setSkillNameTextfieldAsFirstReponder()
    {
    self.tableView.selectRowIndexes(NSIndexSet(index:self.tableView.numberOfRows-1), byExtendingSelection: true)
    let rowView = self.tableView.rowViewAtRow(self.tableView.selectedRow, makeIfNecessary:true)!
    self.cell!.skilsAndRatingsTitlefield.editable = true
    rowView.viewWithTag(-1)
    rowView.subviews[1].subviews[0].becomeFirstResponder()
    }
    
    //ModeOfInterview Action
    @IBAction func modeOfInterviewAction(sender: NSMatrix)
    {
        if (sender.selectedCell() == sender.cells[0])
        {
            technicalFeedbackModel.modeOfInterview = sender.cells[0].title
        }
        else
        {
            technicalFeedbackModel.modeOfInterview = sender.cells[1].title
        }
    }
    
    //Recommentation Field Action
    @IBAction func recommentationAction(sender: AnyObject)
    {
        if (sender.selectedCell() == sender.cells[0])
        {
            technicalFeedbackModel.recommendation = sender.cells[0].title
        }
        else
        {
           technicalFeedbackModel.recommendation = sender.cells[1].title
        }
    }
    
    //To remove the existing skills inside TableViewasds
    @IBAction func removeSkills(sender: NSButton)
    {
        if tableView.selectedRow != -1
        {
            if !(defaultSkills == "Communication" || defaultSkills == "Organisation Stability" || defaultSkills == "Leadership(if applicable)" || defaultSkills == "Growth Potential")
            {
                skillsAndRatingsTitleArray.removeAtIndex(tableView.selectedRow)
                tableView.reloadData()
            }
        }
    }
    
    // To save details of Technical Feedback
    
    @IBAction func saveDetailsAction(sender: AnyObject)
    {
        if technicalFeedbackModel.isFeedbackSubmitted == true
        {
            return
        }
        
        let selectedColoumn = recommentationField.selectedColumn
        if selectedColoumn != 0
        {
            technicalFeedbackModel.recommendation = "Rejected"
        }else
        {
            technicalFeedbackModel.recommendation = "Shortlisted"
        }
        technicalFeedbackModel.skills = skillsAndRatingsTitleArray as [SkillSet]
        technicalFeedbackModel.commentsOnTechnology = textViewOfTechnologyAssessment.string
        technicalFeedbackModel.commentsOnCandidate  = textViewOfCandidateAssessment.string
        technicalFeedbackModel.techLeadName         = interviewedByField.stringValue
        technicalFeedbackModel.isFeedbackSubmitted = false
        
        if isFeedBackSaved == false
        {
              dataAccessModel.insertIntoTechnicalFeedback(self,technicalFeedbackModel: technicalFeedbackModel, selectedCandidate: selectedCandidate!,andCallBack: {(isSucess)->Void in
                if isSucess
                {
                self.isFeedBackSaved = true
                self.sortArray((self.selectedCandidate?.interviewedByTechLeads?.allObjects)!,index:self.selectedRound!
                    )
                Utility.alertPopup("Feedback saved", informativeText: "Feedback for Technical Round has been Saved Successfully.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                }
            })
            }
        else
        {
        let sortedResults = sortingAnArray((selectedCandidate?.interviewedByTechLeads?.allObjects)!)
        let technicalFeedback =  sortedResults[selectedRound!] as! TechnicalFeedBack
            
            dataAccessModel.updateManagerFeedback(selectedCandidate!, technicalFeedback: technicalFeedback, technicalFeedbackmodel: technicalFeedbackModel,andCallBack: {(isSucess)->Void in
                
                if isSucess{
                    Utility.alertPopup("Feedback updated", informativeText: "Feedback for Technical Round has been updated Successfully.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                }
            })
        }
        
   }
    
    //To Submit Feedback Data
    @IBAction func submitDetails(sender: AnyObject)
    {
        if validation()
        {
        technicalFeedbackModel.skills = skillsAndRatingsTitleArray as [SkillSet]
        technicalFeedbackModel.commentsOnTechnology = textViewOfTechnologyAssessment.string
        technicalFeedbackModel.commentsOnCandidate  = textViewOfCandidateAssessment.string
        technicalFeedbackModel.techLeadName         = interviewedByField.stringValue
        technicalFeedbackModel.isFeedbackSubmitted  = true
            
        let selectedColoumn = recommentationField.selectedColumn
        if selectedColoumn != 0
        {
            technicalFeedbackModel.recommendation = "Rejected"
        }
        else
        {
            technicalFeedbackModel.recommendation = "Shortlisted"
        }
            
        if isFeedBackSaved == false
        {
            Utility.alertPopup("Are you sure you want to ‘Submit’ the data ?", informativeText: "Once submitted you cannot edit feedback information.", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                
                self.dataAccessModel.insertIntoTechnicalFeedback(self,technicalFeedbackModel: self.technicalFeedbackModel, selectedCandidate: self.selectedCandidate!,andCallBack: {(isSucess)->Void in
                    if isSucess
                    {
                        Utility.alertPopup("Feedback submitted", informativeText: "Feedback for Technical Round \((self.selectedCandidate?.interviewedByTechLeads?.count)!) has been successfully submitted.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                        self.enablingAndDisablingOfSegments()
                    }
                    
                    self.disableAndEnableFields(true)
                    self.tableView.reloadData()
                })
            })
        }
        else
        {
            let sortedResults = sortingAnArray((selectedCandidate?.interviewedByTechLeads?.allObjects)!)
            let technicalFeedback =  sortedResults[selectedRound!] as! TechnicalFeedBack
            
            dataAccessModel.updateManagerFeedback(selectedCandidate!, technicalFeedback: technicalFeedback, technicalFeedbackmodel: technicalFeedbackModel,andCallBack: {(isSucess)->Void in
                
                if isSucess
                {
                    Utility.alertPopup("Feedback updated", informativeText: "Feedback for Technical Round has been updated Successfully.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                     self.enablingAndDisablingOfSegments()
                }
               
                self.disableAndEnableFields(true)
                self.tableView.reloadData()
            })
         }
      }
    }

    func enablingAndDisablingOfSegments()
    {
        if(self.feedbackControl.subRound.selectedSegment == 0)
        {
            if technicalFeedbackModel.recommendation == "Rejected"
            {
                self.feedbackControl.subRound.setEnabled(true, forSegment: 0)
                self.feedbackControl.subRound.setEnabled(false, forSegment: 1)
                self.feedbackControl.subRound.setEnabled(false, forSegment: 2)
            }
            else
            {
                self.feedbackControl.subRound.setEnabled(true, forSegment: 0)
                self.feedbackControl.subRound.setEnabled(true, forSegment: 1)
                self.feedbackControl.subRound.setEnabled(false, forSegment: 2)
            }
        }
        else if(self.feedbackControl.subRound.selectedSegment == 1)
        {
            if technicalFeedbackModel.recommendation == "Rejected"
            {
            self.feedbackControl.subRound.setEnabled(true, forSegment: 0)
            self.feedbackControl.subRound.setEnabled(true, forSegment: 1)
            self.feedbackControl.subRound.setEnabled(false, forSegment: 2)
            self.feedbackControl.typeOfInterview.setEnabled(false, forSegment: 1)
            }
            else
            {
                self.feedbackControl.subRound.setEnabled(true, forSegment: 0)
                self.feedbackControl.subRound.setEnabled(true, forSegment: 1)
                self.feedbackControl.subRound.setEnabled(true, forSegment: 2)
                self.feedbackControl.typeOfInterview.setEnabled(true, forSegment: 1)
            }
        }
        else if(self.feedbackControl.subRound.selectedSegment == 2)
        {
            if technicalFeedbackModel.recommendation == "Rejected"
            {
            self.feedbackControl.subRound.setEnabled(true, forSegment: 0)
            self.feedbackControl.subRound.setEnabled(true, forSegment: 1)
            self.feedbackControl.subRound.setEnabled(true, forSegment: 2)
            self.feedbackControl.typeOfInterview.setEnabled(false, forSegment: 1)
            }
            else
            {
               self.feedbackControl.subRound.setEnabled(true, forSegment: 0)
               self.feedbackControl.subRound.setEnabled(true, forSegment: 1)
               self.feedbackControl.subRound.setEnabled(true, forSegment: 2)
               self.feedbackControl.typeOfInterview.setEnabled(true, forSegment: 1)
            }
        }
    }
    
    func sortingAnArray(allObjects : [AnyObject]) -> NSArray
    {
        let sortingArray = NSArray(array: allObjects)
        let descriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortedResults = sortingArray.sortedArrayUsingDescriptors([descriptor])
        return sortedResults
    }

    //MARK:- Setting Matrix Value
    func fetchingModeOfInterview(value : String)
    {
        if value == "Telephonic"
        {
            modeOfInterview.setState(NSOnState, atRow: 0, column: 0)
            modeOfInterview.setState(NSOffState, atRow: 0, column: 1)
        }
        else
        {
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
        }
        else
        {
            recommentationField.setState(NSOnState, atRow: 0, column: 1)
            recommentationField.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    //MARK:- Validation Method for checking all defaults skills are selected
    
    func validationForDefaultSkills()->Bool
    {
        for object in self.skillsAndRatingsTitleArray
        {
            let skillset = object
            if skillset.skillName == "Communication" || skillset.skillName == "Organisation Stability" || skillset.skillName == "Growth Potential"
            {
                if (skillset.skillRating == 0)
                {
                    return false
                }
            }
        }
        return true
    }
    
    //MARK:- TextView validation method
    func validationForTextView(subView : NSTextView,title : String,informativeText:String) -> Bool
    {
        if subView.string == ""
        {
            Utility.alertPopup(title, informativeText: informativeText,isCancelBtnNeeded:false,okCompletionHandler: nil)
            
            return false
        }
            
        else
        {
            return true
        }
    }
    
    //MARK:- Textfield validation method
    func validationForTextfield(subView : NSTextField,title : String,informativeText:String) -> Bool
    {
        if subView.stringValue == ""
        {
            Utility.alertPopup(title, informativeText: informativeText,isCancelBtnNeeded:false,okCompletionHandler: nil)
             return false
        }
        else
        {
          return true
        }
    }

    //MARK: Validation
    func validation() -> Bool
    {
        var isValid : Bool = false
        let selectedColoumn = recommentationField.selectedColumn
        if selectedColoumn != 0
        {
            technicalFeedbackModel.recommendation = "Rejected"
            if (cell?.feedback.stringValue == "" || textViewOfCandidateAssessment.string == "" || textViewOfTechnologyAssessment.string == "" || interviewedByField.stringValue == "" || ratingOfCandidateField.stringValue == "" || ratingOnTechnologyField.stringValue == "")
            {
                Utility.alertPopup("Alert", informativeText: "Please enter all details", isCancelBtnNeeded: false, okCompletionHandler: nil)
                return isValid
            }else if !validationForDefaultSkills()
            {
                Utility.alertPopup("Alert", informativeText: "Please provide rating for default skills", isCancelBtnNeeded: false, okCompletionHandler: nil)
                return isValid
            }else
            {
                isValid = true
                return isValid
            }
        }
        else
        {
            technicalFeedbackModel.recommendation = "Shortlisted"
            if !validationForDefaultSkills(){
                Utility.alertPopup("Rating on Technical/Personality", informativeText: "Please provide rating for Technical/Personality skills",isCancelBtnNeeded:false,okCompletionHandler: nil)
                return isValid
            }
            else if !validationForTextView(textViewOfTechnologyAssessment,title: "Overall Feedback On Technology",informativeText: "Overall assessment of Technology field shold not be blank")
            {
                return isValid
            }
            else if !validationForTextfield(ratingOnTechnologyField,title: "Overall assessment on Technology",informativeText: "Please provide ratings for overall assessment on Technology"){
                
                return isValid
            }
            else if !validationForTextView(textViewOfCandidateAssessment,title: "Overall assessment Of Candidate",informativeText: "Overall assessment of Candidate field shold not be blank")
            {
               return isValid
            }
            else if !validationForTextfield(ratingOfCandidateField,title: "Overall assessment of Candidate",informativeText: "Please provide ratings for overall assessment of Candidate")
            {
                return isValid
            }
        
            else if !validationForTextfield(interviewedByField,title: "Interviewed By",informativeText: "Interviewed by field should not be empty")
            {
                return isValid
            }
            else
            {
               isValid = true
            }
            return isValid
        }
    }
    
    //MARK: Refresh
    func refreshAllFields()
    {
      isFeedBackSaved = false
      textViewOfCandidateAssessment.string = ""
      textViewOfTechnologyAssessment.string = ""
      interviewedByField.stringValue = ""
      fetchingModeOfInterview("Face To Face")
      fetchingRecommendation("Shortlisted")
      technicalFeedbackModel.ratingOnCandidate = 0
      technicalFeedbackModel.ratingOnTechnical = 0
      skillsAndRatingsTitleArray.removeAll()
      initialSetupOfTableView()
      ratingOfCandidateField.stringValue = ""
      ratingOnTechnologyField.stringValue = ""
      technicalFeedbackModel.isFeedbackSubmitted = false
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
      disableAndEnableFields(false)
      tableView.reloadData()
    }
    
    @IBAction func clearAllFields(sender: AnyObject)
    {
       refreshAllFields()
    }
}
