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
    @IBOutlet weak var addNewSkill: NSButton!
    @IBOutlet weak var deleteExistingSkill: NSButton!
    @IBOutlet weak var submitButton: NSButton!
    @IBOutlet weak var clearButton: NSButton!
   
    
    //MARK: Variables
    var cell : EHRatingsTableCellView?
    var feedback = EHFeedbackViewController()
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
    var rowView : NSTableRowView?
    var defaultSkills : String? = ""
    
    //MARK: initial setup of views
    func initialSetupOfTableView()
    {
        skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"]
        
//        for index in 0...3
//        {
        
        dataAccessModel.createdefaultSkillSetObject(skillArray,feedBackControllerObj: self,andCallBack:{(communication)->Void in
                
//                if self.arrTemp.count>0{
//                
//                    self.arrTemp.removeLast()
//                }
            
                 self.skillsAndRatingsTitleArray = communication as [SkillSet]
                self.tableView.reloadData()
            
                })
      
           
//        }
    }

    func test(){
    
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("test"), object: nil)
        if arrTemp.count==0 {
        
            //implement your code
            
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
        else{
        
            self.performSelector(Selector("test"), withObject: nil, afterDelay: 0.10)
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
        clearButton.enabled = false
        self.performSelector(Selector("test"), withObject: nil, afterDelay: 0.01)
        candidateNameField.stringValue = (selectedCandidate?.name)!
        requisitionNameField.stringValue = (selectedCandidate?.requisition)!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm aaa"
        let dateInStringFormat = dateFormatter.stringFromDate((selectedCandidate?.interviewDate)!)
        dateOfInterviewField.stringValue = dateInStringFormat
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
        setDefaultValues()
        selectedRound = 0
    }
    
    func setDefaultValues()
    {
    technicalFeedbackModel.modeOfInterview = "Face To Face"
    technicalFeedbackModel.recommendation = "Shortlisted"
    technicalFeedbackModel.commentsOnCandidate = ""
    technicalFeedbackModel.commentsOnTechnology = ""
    technicalFeedbackModel.designation = ""
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
                clearButton.enabled = false
                technicalFeedbackObject = feedback
                textViewOfCandidateAssessment.string = feedback.commentsOnCandidate
                technicalFeedbackModel.ratingOnTechnical = Int16((feedback.ratingOnTechnical?.integerValue)!)
                textViewOfTechnologyAssessment.string = feedback.commentsOnTechnology
                technicalFeedbackModel.ratingOnCandidate = Int16((feedback.ratingOnCandidate?.integerValue)!)
                                interviewedByField.stringValue = feedback.techLeadName!
                technicalFeedbackModel.modeOfInterview = feedback.modeOfInterview!
                technicalFeedbackModel.recommendation = feedback.recommendation!
                if technicalFeedbackModel.recommendation == "Shortlisted"
                {
                    designationField.stringValue = feedback.designation!
                }
                else
                {
                    designationField.enabled = false
                    designationField.stringValue = ""
                }

                technicalFeedbackModel.isFeedbackSubmitted = feedback.isFeedbackSubmitted
                
                fetchingModeOfInterview(technicalFeedbackModel.modeOfInterview!)
                fetchingRecommendation(technicalFeedbackModel.recommendation!)
                disableAndEnableFields((technicalFeedbackModel.isFeedbackSubmitted?.boolValue)!)
                self.skillsAndRatingsTitleArray.removeAll()
                
                if isFeedBackSaved == true{
//                for object in feedback.candidateSkills!
//                {
//                    let skillset = object as! SkillSet
                    
//                    dataAccessModel.createSkillSetWithTechnicalManagerObject(feedback, andCallBack: { (newSkill) -> Void in
//                        newSkill.skillName   = skillset.skillName
//                        newSkill.skillRating = skillset.skillRating
//                        self.skillsAndRatingsTitleArray.append(newSkill)
//                        if feedback.candidateSkills?.count == self.skillsAndRatingsTitleArray.count{
//                            
//                        }
//                    })
                    
                    dataAccessModel.createSavedSkillSetObject(feedback,skillSetArray: (feedback.candidateSkills?.allObjects)!, andCallBack: { (newSkill) -> Void in
                         self.skillsAndRatingsTitleArray = newSkill as [SkillSet]
                        self.tableView.reloadData()
                    })
                    
                    
                   
                    
                    
//                }
                }else{
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
        clearButton.enabled = false
        submitButton.enabled = false
        addNewSkill.enabled = false
        deleteExistingSkill.enabled = false
        designationField.editable = false
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
        submitButton.enabled = true
        designationField.editable = true
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
         clearButton.enabled = true
         }
    }
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment Of Candidate
    
    func assessmentOfCandidate(sender : NSButton)
    {
        let totalView = overallAssessmentOfCandidateStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, feedbackText: ratingOfCandidateField,view: overallAssessmentOfCandidateStarView)
        if isFeedBackSaved == false
        {
         clearButton.enabled = true
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
        }
        
        for ratingsView in cellView.starCustomView.subviews
        {
            let feedbackview = ratingsView as! NSButton
            
            if technicalFeedbackModel.isFeedbackSubmitted == true
            {
                feedbackview.enabled = false
                cellView.skilsAndRatingsTitlefield.enabled = false
                cellView.feedback.enabled = false
            }
            else
            {
                feedbackview.enabled = true
                cellView.skilsAndRatingsTitlefield.enabled = true
                cellView.feedback.enabled = true
            }
            feedbackview.target = self
            feedbackview.action = "starRatingCount:"
        }   
        return cellView
    }

    func tableViewSelectionDidChange(notification: NSNotification)
    {
        if tableView.selectedRow != -1
        {
                    }

    }
    
    func tableViewSelectionIsChanging(notification: NSNotification)
    {
        
    
        if isFeedBackSaved == false
        {
            clearButton.enabled = true
        }

        if tableView.selectedRow != -1
        {
            if cell!.skilsAndRatingsTitlefield.stringValue == "Communication" || cell!.skilsAndRatingsTitlefield.stringValue == "Organisation Stability" || cell!.skilsAndRatingsTitlefield.stringValue == "Leadership(if applicable)" || cell!.skilsAndRatingsTitlefield.stringValue == "Growth Potential"
            {
                defaultSkills = cell?.skilsAndRatingsTitlefield.stringValue
                cell!.skilsAndRatingsTitlefield.editable = false
                tableView.selectionHighlightStyle = .None
                
            }
            else
            {
                defaultSkills = cell?.skilsAndRatingsTitlefield.stringValue
                cell!.skilsAndRatingsTitlefield.editable = true
                 tableView.selectionHighlightStyle = .Regular
            }

        }

        
//        if selectedRow != -1
//        {
//         if selectedRow < 4
//         {
//            tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.None
//         }
//         else
//         {
//           tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.Regular
//         }
//        }
    }
    
    func textDidChange(notification: NSNotification)
    {
        if isFeedBackSaved == false
        {
        clearButton.enabled = true
        }
    }
    // To Display The Stars inside TableView
    func starRatingCount(sender : NSButton)
    {
        if isFeedBackSaved == false
        {
         clearButton.enabled = true
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
        clearButton.enabled = true
        }
    }
    override func controlTextDidEndEditing(obj: NSNotification)
    {
        let textFieldObject = obj.object as! NSTextField
        if textFieldObject.superview is EHRatingsTableCellView
        {
            if tableView.selectedRow != -1
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
        if skillsAndRatingsTitleArray.count > 0 && cell?.skilsAndRatingsTitlefield.stringValue == "Enter Title"
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
                dataAccessModel.createSkillSetWithTechnicalManagerObject(technicalFeedbackObject!, andCallBack: { (newSkill) -> Void in
                    
                    newSkill.skillName = "Enter Title"
                    self.skillsAndRatingsTitleArray.append(newSkill)
                    self.tableView.reloadData()
                })
            }
            else
            {
            dataAccessModel.createSkillSetObject({(newSkill)->Void in
               
                newSkill.skillName = "Enter Title"
                self.skillsAndRatingsTitleArray.append(newSkill)
                self.tableView.reloadData()
                self.tableView.selectRowIndexes(NSIndexSet(index:self.tableView.numberOfRows-1), byExtendingSelection: true)
                self.rowView = self.tableView.rowViewAtRow(self.tableView.selectedRow, makeIfNecessary:true)!
                self.rowView!.viewWithTag(1)?.becomeFirstResponder()
                
            })
            }
         }
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
            designationField.enabled = true
        }
        else
        {
           technicalFeedbackModel.recommendation = sender.cells[1].title
           designationField.enabled = false
        }
    }
    
    //To remove the existing skills inside TableView

    @IBAction func removeSkills(sender: NSButton)
    {
        if tableView.selectedRow != -1
        {
            if defaultSkills == "Communication" || defaultSkills == "Organisation Stability" || defaultSkills == "Leadership(if applicable)" || defaultSkills == "Growth Potential"
            {
                print("Skillllls")
            }
            else
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
            technicalFeedbackModel.designation    = designationField.stringValue
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
                Utility.alertPopup("Success", informativeText: "Feedback for Technical Round has been Saved Successfully", isCancelBtnNeeded:false,okCompletionHandler: nil)
                }
            })
            }
        else
        {
        let sortedResults = sortingAnArray((selectedCandidate?.interviewedByTechLeads?.allObjects)!)
        let technicalFeedback =  sortedResults[selectedRound!] as! TechnicalFeedBack
            
            dataAccessModel.updateManagerFeedback(selectedCandidate!, technicalFeedback: technicalFeedback, technicalFeedbackmodel: technicalFeedbackModel,andCallBack: {(isSucess)->Void in
                
                if isSucess{
                    Utility.alertPopup("Success", informativeText: "Feedback for Technical Round has been updated Successfully", isCancelBtnNeeded:false,okCompletionHandler: nil)
                }
            })
        }
        
   }
    
    @IBAction func submitDetails(sender: AnyObject)
    {
        if validation()
        {
        technicalFeedbackModel.skills = skillsAndRatingsTitleArray as [SkillSet]
        technicalFeedbackModel.commentsOnTechnology = textViewOfTechnologyAssessment.string
        technicalFeedbackModel.commentsOnCandidate  = textViewOfCandidateAssessment.string
        technicalFeedbackModel.designation          = designationField.stringValue
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
            Utility.alertPopup("Alert", informativeText: "Are you sure you want to ‘Submit’ the data ?", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                
                self.dataAccessModel.insertIntoTechnicalFeedback(self,technicalFeedbackModel: self.technicalFeedbackModel, selectedCandidate: self.selectedCandidate!,andCallBack: {(isSucess)->Void in
                    if isSucess{
                        Utility.alertPopup("Success", informativeText: "Feedback for Technical Round \((self.selectedCandidate?.interviewedByTechLeads?.count)!) has been successfully saved", isCancelBtnNeeded:false,okCompletionHandler: nil)
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
                    Utility.alertPopup("Success", informativeText: "Feedback for Technical Round has been updated Successfully", isCancelBtnNeeded:false,okCompletionHandler: nil)
                }
                self.disableAndEnableFields(true)
                self.tableView.reloadData()
            })
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
            
        }
        else
        {
            recommentationField.setState(NSOnState, atRow: 0, column: 1)
            recommentationField.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    //MARK: Validation
    func validation() -> Bool
    {
      let isValid = false
        
        if defaultSkills == "Communication"
        {
            if cell?.feedback.stringValue == ""
            {
            Utility.alertPopup("Alert", informativeText: "Skill Name should not be blank",isCancelBtnNeeded:false, okCompletionHandler: nil)
            return isValid
            }
            return true
        }
            
//            || defaultSkills == "Organisation Stability" || defaultSkills == "Leadership(if applicable)" || defaultSkills == "Growth Potential"
//            {
//                
//            }
        
        
        else if cell?.skilsAndRatingsTitlefield.stringValue == ""
        {
            Utility.alertPopup("Alert", informativeText: "Skill Name should not be blank",isCancelBtnNeeded:false, okCompletionHandler: nil)
            return isValid
        }
        else if cell?.skilsAndRatingsTitlefield.stringValue == "Enter Title"
        {
            Utility.alertPopup("Alert", informativeText: "Enter Valid Skill Name",isCancelBtnNeeded:false, okCompletionHandler: nil)
            return isValid
        }
//        else if cell?.feedback.stringValue == ""
//        {
//            Utility.alertPopup("Alert", informativeText: "Please provide your feedback of skills",isCancelBtnNeeded:false, okCompletionHandler: nil)
//            return isValid
//        }
            
        else if ratingOnTechnologyField.stringValue == ""
        {
            Utility.alertPopup("Alert", informativeText: "Please provide your feedback of overall assessment on Technology", isCancelBtnNeeded:false,okCompletionHandler: nil)
            return isValid
        }
            
        else if ratingOfCandidateField.stringValue == ""
        {
            Utility.alertPopup("Alert", informativeText: "Please provide your feedback of overall assessment of Candidate",isCancelBtnNeeded:false, okCompletionHandler: nil)
            return isValid
        }
            
        else if textViewOfTechnologyAssessment.string == ""
        {
             Utility.alertPopup("Alert", informativeText: "Please enter your feedback on Technology", isCancelBtnNeeded:false,okCompletionHandler: nil)
            return isValid
        }
            
        else if textViewOfCandidateAssessment.string == ""
        {
            Utility.alertPopup("Alert", informativeText: "Overall assessment of Candidate field shold not be blank", isCancelBtnNeeded:false,okCompletionHandler: nil)
            return isValid
        }
            
        else if designationField.stringValue == ""
        {
            if recommentationField.stringValue == "Shortlisted"
            {
            Utility.alertPopup("Alert", informativeText: "Designation Field should not be blank",isCancelBtnNeeded:false, okCompletionHandler: nil)
                return isValid
            }
            else
            {
                return true
            }
            
        }
            
        else if interviewedByField.stringValue.characters.count == 0
        {
            Utility.alertPopup("Alert", informativeText: "Please enter the interviewer field should not be blank", isCancelBtnNeeded:false,okCompletionHandler: nil)
            return isValid
        }
        else if technicalFeedbackModel.ratingOnCandidate == 0
        {
             Utility.alertPopup("Alert", informativeText: "Please provide your feedback of Candidate should not be blank", isCancelBtnNeeded:false,okCompletionHandler: nil)
            return isValid
        }
        else if technicalFeedbackModel.ratingOnTechnical == 0
        {
            Utility.alertPopup("Alert", informativeText: "Please provide your feedback on Technology should not be blank", isCancelBtnNeeded:false,okCompletionHandler: nil)
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
      isFeedBackSaved = false
      textViewOfCandidateAssessment.string = ""
      textViewOfTechnologyAssessment.string = ""
      designationField.stringValue = ""
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
