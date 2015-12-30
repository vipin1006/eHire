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
    @IBOutlet weak var dateOfInterviewField: NSTextField!
    
    @IBOutlet weak var modeOfInterview: NSMatrix!
    @IBOutlet weak var recommentationField: NSMatrix!
    
    //Variables
    var cell : EHRatingsTableCellView?
    var technicalFeedbackDetails = [String : Any]()
    var feedback = EHFeedbackViewController()
    let skill = EHSkillSetModel()
    var technicalFeedbackModel = EHTechnicalFeedbackModel()
    let dataAccessModel = TechnicalFeedbackDataAccess()
    
    var name : String?
    var overallTechnicalRating : Int = 0
    var overallCandidateRating : Int = 0
    var overallCandidateRatingOnSkills : Int = 0
    var interviewModeState : String?
    var recommentationState : String?
    var skillsAndRatingsTitleArray = NSMutableArray()
    
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
        print(interviewModeState)
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
        print(recommentationState)
    }
   
    override func loadView()
    {
//        let communicationSkill = EHSkillSetModel()
//        communicationSkill.skillName = "Communication"
//        communicationSkill.skillRating = 0
//        let stabilitySkill = EHSkillSetModel()
//        stabilitySkill.skillName = "Stability"
//        stabilitySkill.skillRating = 0
//        let leadershipSkill = EHSkillSetModel()
//        leadershipSkill.skillName = "Leadership"
//        leadershipSkill.skillRating = 0
//        let growthSkill = EHSkillSetModel()
//        growthSkill.skillName = "Growth"
//        growthSkill.skillRating = 0
//
//        technicalFeedbackModel.skills.append(communicationSkill)
//        technicalFeedbackModel.skills.append(stabilitySkill)
//        technicalFeedbackModel.skills.append(leadershipSkill)
//        technicalFeedbackModel.skills.append(growthSkill)
     if skillsAndRatingsTitleArray.count == 0
     {
      let communication = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
    
      communication.skillName = "Communication"
      communication.skillRating = overallCandidateRatingOnSkills
    
      self.skillsAndRatingsTitleArray.addObject(communication)
     
      let organisationStability = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
    
     organisationStability.skillName = "Stability"
    
      organisationStability.skillRating = overallCandidateRatingOnSkills
    
     self.skillsAndRatingsTitleArray.addObject(organisationStability)
      
     let leadership = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
    
     leadership.skillName = "Leadership"
    
     leadership.skillRating = overallCandidateRatingOnSkills
    
     self.skillsAndRatingsTitleArray.addObject(leadership)
    
    
     let growth = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
    
     growth.skillName = "Growth"
     growth.skillRating = overallCandidateRatingOnSkills
     self.skillsAndRatingsTitleArray.addObject(growth)
      }
        super.loadView()
    }

    //initial setup of view to load the basic views of Technical Feedback.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cell?.skilsAndRatingsTitlefield.delegate = self
        textViewOfTechnologyAssessment.delegate = self
        textViewOfCandidateAssessment.delegate = self
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
        tableView.reloadData()
    }
   
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment On Technology
    
    func assessmentOnTechnology(sender : NSButton)
    {
        let totalView = overallAssessmentOnTechnologyStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, label: ratingOnTechnologyField, view: overallAssessmentOnTechnologyStarView)
    }
    // To Dispaly the Star Rating insided the TextView Of Overall Assessment Of Candidate
    
    func assessmentOfCandidate(sender : NSButton)
    {
        let totalView = overallAssessmentOfCandidateStarView.subviews
        toDisplayRatingStar(totalView, sender: sender, label: ratingOfCandidateField,view: overallAssessmentOfCandidateStarView)
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
        let cellView : EHRatingsTableCellView = tableView.makeViewWithIdentifier("RatingCell", owner: self) as! EHRatingsTableCellView
        //cellView?.skilsAndRatingsTitlefield.stringValue = skillsAndRatingsTitleArray.objectAtIndex(row) as! String
        let skill = skillsAndRatingsTitleArray.objectAtIndex(row) as! SkillSet
       // let skill = technicalFeedbackModel.skills[row] as EHSkillSetModel
        cellView.skilsAndRatingsTitlefield.stringValue = skill.skillName!
        cellView.skilsAndRatingsTitlefield.editable = true
        cellView.skilsAndRatingsTitlefield.delegate = self
        cellView.skilsAndRatingsTitlefield.target = self
        cellView.skilsAndRatingsTitlefield.tag = row
        cell = cellView
        
        for ratingsView in cellView.starCustomView.subviews
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
        
        toDisplayRatingStar(totalView, sender: sender,label: ratingCell.feedback,view: ratingCell.starCustomView)
    }
    
    // To Dispaly the Star Rating to Technical&Personality And Overall Assessment On Technology and also for Overall Assessment Of Candidate
    
    func toDisplayRatingStar(totalView : [NSView], sender : NSButton,label : NSTextField,view : AnyObject)
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
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
              overallTechnicalRating = 1
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 1
            }
            
            else if view as? NSView == cell?.starCustomView
            {
                overallCandidateRatingOnSkills = 1
//                let skill = skillsAndRatingsTitleArray.objectAtIndex(self.tableView.selectedRow) as! SkillSet
//                skill.skillRating = overallCandidateRatingOnSkills
//                EHCoreDataHelper.saveToCoreData(skill)
            }
        case 1:
            countingOfRatingStar(1)
            label.stringValue = "Satisfactory"
            countingOfRatingStar(0, deselectStar: 2,3,4)
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 2
            }
            
            if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 2
            }
            else if view as? NSView == cell?.starCustomView
            {
                overallCandidateRatingOnSkills = 2
            }
            
        case 2:
            countingOfRatingStar(2)
            label.stringValue = "Good"
            
            countingOfRatingStar(0, deselectStar: 3,4)
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 3
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 3
            }
            else if view as? NSView == cell?.starCustomView
            {
                overallCandidateRatingOnSkills = 3
            }
        case 3:
            countingOfRatingStar(3)
            label.stringValue = "Very Good"
            countingOfRatingStar(0, deselectStar: 4)
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 4
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 4
            }
            else if view as? NSView == cell?.starCustomView
            {
                overallCandidateRatingOnSkills = 4
            }
            
        case 4:
            countingOfRatingStar(4)
            label.stringValue = "Excellent"
            if view as! NSView == overallAssessmentOnTechnologyStarView
            {
                overallTechnicalRating = 5
            }
            
            else if view as! NSView == overallAssessmentOfCandidateStarView
            {
                overallCandidateRating = 5
            }
            else if view as? NSView == cell?.starCustomView
            {
                overallCandidateRatingOnSkills = 5
            }
            
           default : print("")
        }
    }
    
    //MARK: TextField Delegate methods
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        let skill = skillsAndRatingsTitleArray.objectAtIndex(self.tableView.selectedRow) as! SkillSet
        skill.skillName = fieldEditor.string
        skill.skillRating = overallCandidateRatingOnSkills
        print(skill.skillRating)
        EHCoreDataHelper.saveToCoreData(skill)
//      let skill = technicalFeedbackModel.skills[self.tableView.selectedRow]
//      skill.skillName = fieldEditor.string
        return true
    }
    
    // Mark: To add new skills inside TableView
    
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
            
            newSkill.skillRating = overallCandidateRatingOnSkills
            
            self.skillsAndRatingsTitleArray.addObject(newSkill)
            
            print(skillsAndRatingsTitleArray)
            
            tableView.reloadData()
        }

//        if technicalFeedbackModel.skills.count > 0 && cell?.skilsAndRatingsTitlefield.stringValue == "Enter Title"
//        {
//            alertPopup("Enter Title", informativeText: "Please enter previous selected title")
//        }
//        else
//        {
//            skill.skillName = "Enter Title"
//            skill.skillRating = 0
//            technicalFeedbackModel.skills.append(skill)
//            tableView.reloadData()
//        }
    }
    
    //Mark: To remove the existing skills inside TableView

    @IBAction func removeSkills(sender: NSButton)
    {
        if tableView.selectedRow != -1
        {
            skillsAndRatingsTitleArray.removeObjectAtIndex(tableView.selectedRow)
            tableView.reloadData()
        }
    }
    
    //Mark: TextField Action
    
    @IBAction func textFieldAction(sender: NSTextField)
    {
        if sender.stringValue == ""
        {
            setBoarderColor(sender)
        }
        else if sender.stringValue.characters.count < 5
        {
            setBoarderColor(sender)
        }
        else
        {
            sender.wantsLayer = true
            sender.layer?.backgroundColor = NSColor.clearColor().CGColor
        }
    }
    
    // Mark: To save details of Technical Feedewback
    
    @IBAction func saveDetailsAction(sender: NSButton)
    {
       
        if validation()
       {
       technicalFeedbackModel.modeOfInterview         = interviewModeState
       technicalFeedbackModel.skills = skillsAndRatingsTitleArray as [AnyObject]
       technicalFeedbackModel.commentsOnTechnology = textViewOfTechnologyAssessment.string
       technicalFeedbackModel.ratingOnTechnical    = overallTechnicalRating
       technicalFeedbackModel.commentsOnCandidate  = textViewOfCandidateAssessment.string
       technicalFeedbackModel.ratingOnCandidate    = overallCandidateRating
       technicalFeedbackModel.recommendation       = recommentationState
       technicalFeedbackModel.designation          = designationField.stringValue
       technicalFeedbackModel.techLeadName         = interviewedByField.stringValue
      
       
         if dataAccessModel.insertIntoTechnicalFeedback(technicalFeedbackModel)
         {
            print("Saved")
            fetching()
          }
          else
          {
            print ("Not saved")
          }
        }
        else
        {
            alertPopup("Some Fields Data Are Missing", informativeText: "Enter the Proper data")
        }
    }
    
    func fetching()
    {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TechnicalFeedBack")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let feedbackData = results as! [NSManagedObject]
            if feedbackData.count != 0
            {
               print(feedbackData)
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
 }
    
    //To give Color to the SubViews
    func setBoarderColor(subView:NSTextField)
    {
        subView.wantsLayer = true
        subView.layer?.backgroundColor = NSColor.orangeColor().CGColor
    }
    
    func setBoarderColorForTextView(subView:NSTextView)
    {
        subView.wantsLayer = true
        subView.layer?.borderColor = NSColor.orangeColor().CGColor
        subView.layer?.borderWidth = 2
    }
    
    func validationForTextView(subView : NSTextView) -> Bool
    {
        if subView.string == ""
        {
            setBoarderColorForTextView(subView)
            return false
        }
        else if subView.string!.characters.count < 5
        {
            setBoarderColorForTextView(subView)
            return false
        }
        else
        {
            subView.wantsLayer = true
            subView.layer?.borderColor = NSColor.clearColor().CGColor
            subView.layer?.borderWidth = 2
            return true
        }   
    }
    
    func validationForTextfield(subView : NSTextField) -> Bool
    {
      if subView.stringValue == ""
     {
     setBoarderColor(subView)
         return false
     }
     else if subView.stringValue.characters.count < 5
     {
     setBoarderColor(subView)
         return false
     }
     else
     {
     subView.wantsLayer = true
     subView.layer?.backgroundColor = NSColor.clearColor().CGColor
     return true
     }
    }

    func textView(textView: NSTextView, shouldChangeTextInRange affectedCharRange: NSRange, replacementString: String?) -> Bool
    {
        validationForTextView(textView)
        return true
    }
    
    func validation() -> Bool
    {
      var isValid : Bool = false
      isValid =  validationForTextView(textViewOfTechnologyAssessment)
      isValid =  validationForTextView(textViewOfCandidateAssessment)
      isValid =  validationForTextfield(ratingOfCandidateField)
      isValid =  validationForTextfield(ratingOnTechnologyField)
      isValid =  validationForTextfield(interviewedByField)
      isValid =  validationForTextfield(designationField)
//        if modeOfInterview.cells.
//        {
//            return false
//        }
//        else if recommentationField.selectedCell()?.state
//        {
//            return false
//        }
      return isValid
    }
}
