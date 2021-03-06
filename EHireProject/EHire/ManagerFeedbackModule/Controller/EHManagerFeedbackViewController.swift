//
//  EHManagerFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerFeedbackViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate {

    @IBOutlet weak var deleteExistingBtn: NSButton!
    @IBOutlet weak var addNewSkillBtn: NSButton!
    @IBOutlet weak var saveBtn: NSButton!
    
    @IBOutlet weak var submitBtn: NSButton!
    @IBOutlet var managerFeedbackMainView: NSView!
   
    @IBOutlet weak var textFieldCandidateName: NSTextField!
    
    @IBOutlet weak var dateOfInterviewField: NSTextField!
    @IBOutlet weak var textFieldCandidateRequisition: NSTextField!
    @IBOutlet weak var textFieldCorporateGrade: NSTextField!
    @IBOutlet weak var textFieldDesignation: NSTextField!
    
    @IBOutlet weak var textFieldGrossAnnualSalary: NSTextField!
    
    @IBOutlet weak var textFieldInterviewedBy: NSTextField!
   
    @IBOutlet weak var textFieldPosition: NSTextField!
   
    @IBOutlet var textViewCommitments: NSTextView!
    
    
    @IBOutlet var textViewJustificationForHire: NSTextView!
    
    @IBOutlet weak var viewOverAllAssessmentOfCandidateStar: NSView!
    
    @IBOutlet weak var labelOverAllAssessmentOfCandidate: NSTextField!
    
    @IBOutlet weak var viewOverAllAssessmentOfTechnologyStar: NSView!
    
    @IBOutlet weak var labelOverAllAssessmentOfTechnology: NSTextField!
    
    @IBOutlet weak var matrixForInterviewMode: NSMatrix!
    
    @IBOutlet var textViewCommentsForOverAllCandidateAssessment: NSTextView!
    
    @IBOutlet var textViewCommentsForOverAllTechnologyAssessment: NSTextView!
    
    @IBOutlet weak var matrixForRecommendationState: NSMatrix!
    
    @IBOutlet weak var matrixForCgDeviation: NSMatrix!
    var ratingTitle = NSMutableArray()
    
    @IBOutlet weak var tableView: NSTableView!
    
    let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    
    var candidateDetails : EHCandidateDetails?
    
    var selectedCandidate : Candidate?
   
    var cell : EHManagerFeedBackCustomTableView?
    var isFeedBackSaved : Bool?
    
    
    let  managerialRoundFeedback = EHManagerialFeedbackModel()
    var skillsAndRatingsTitleArray = [SkillSet]()
    var selectedSegment:Int?
    
    var designationStringValue = ""
    
    var xTimesTwo:String {
        set {
            designationStringValue = xTimesTwo
        }
        get {
            return designationStringValue
        }
    }
    //MARK:- View Methods
    override func loadView() {
        
       addDefalutSkillSet()
        super.loadView()
    }
    
        override func viewDidLoad()
    {
        super.viewDidLoad()
        
        textFieldCandidateName.stringValue = (selectedCandidate?.name)!
        textFieldCandidateRequisition.stringValue = (selectedCandidate?.requisition)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "DD MMM YYYY"
        let dateInStringFormat = dateFormatter.stringFromDate((selectedCandidate?.interviewDate)!)
        dateOfInterviewField.stringValue = dateInStringFormat

        managerFeedbackMainView.wantsLayer = true
        managerFeedbackMainView.layer?.backgroundColor = NSColor.gridColor().colorWithAlphaComponent(0.5).CGColor
       // tableView.reloadData()
        setDefaultCgDeviationAndInterviewMode()
        
        
         selectedSegment = 0
        if selectedCandidate != nil
        { if selectedCandidate?.interviewedByManagers?.count != 0{
           
            sortArray((selectedCandidate?.interviewedByManagers?.allObjects)!,index: 0)

        }else{
            isFeedBackSaved = false
            }
            tableView.reloadData()
        }
        
        
        print("name = \(managerialRoundFeedback.designation)")
    }
    
    //MARK:- Method for Adding Default Skills
    func addDefalutSkillSet(){
        let skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"] as NSMutableArray
        
        for index in 0...3
        {
            let skillSetObject = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
            skillSetObject.skillName = skillArray.objectAtIndex(index) as? String
            skillsAndRatingsTitleArray.append(skillSetObject)

        }
        
    }

    //MARK:-TableView DataSource Methods
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return skillsAndRatingsTitleArray.count

    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 25
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = tableView.makeViewWithIdentifier("DataCell", owner: self) as! EHManagerFeedBackCustomTableView
        
        let skillSetObject = skillsAndRatingsTitleArray[row] as SkillSet
        cell.titleName.stringValue = skillSetObject.skillName!
        cell.titleName.tag = row
        cell.titleName.target = self
        cell.titleName.delegate = self
      self.cell = cell
        if !(skillSetObject.skillRating == nil)
        {
            for starButton in cell.selectStar.subviews
            {
                let tempBtn = starButton as! NSButton
                if tempBtn.tag+1 == (skillSetObject.skillRating!){
                    displayStar(cell, lbl: cell.feedBackRating, sender: tempBtn )
                    break
                }
                else
                {
                    tempBtn.image = NSImage(named: "deselectStar")
                    cell.feedBackRating.stringValue = ""
                }
            }
        }
        for ratingsView in cell.selectStar.subviews
        {
            let view = ratingsView as! NSButton
            if managerialRoundFeedback.isSubmitted == true{
                view.enabled = false
                cell.titleName.enabled = false
                cell.feedBackRating.enabled = false
            }else{
                view.enabled = true
                cell.titleName.enabled = true
                cell.feedBackRating.enabled = true
            }
//            if selectedCandidate?.interviewedByManagers?.count > 0
//            {
//                view.enabled = false
//            }
            
            view.target = self
            view.action = "selectedStarCount:"
            
        }
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification)
    {
        if notification.object!.selectedRow >= 4
        {
            cell?.titleName.editable = true
        }
    }
    
    //MARK:- Method to select star in tableview
    func selectedStarCount(sender : NSButton)
    {
        let ratingCell = sender.superview?.superview as! EHManagerFeedBackCustomTableView
        if ratingCell.titleName.stringValue == "Enter Title"
        {
            Utility.alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name",isCancelBtnNeeded:false,okCompletionHandler: nil)

            return
        }
        displayStar(ratingCell, lbl: ratingCell.feedBackRating, sender: sender )
    }
    
    
    //MARK:- Textfield delegate Method
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        
       
        return true
    }
    
    override func controlTextDidEndEditing(obj: NSNotification){
        let textFieldObject = obj.object as! NSTextField
        if textFieldObject.superview is EHManagerFeedBackCustomTableView{
            if tableView.selectedRow >= 4
            {
            let skillSetObject =  skillsAndRatingsTitleArray[textFieldObject.tag]
            skillSetObject.skillName = textFieldObject.stringValue
            }
        }
    }
    
 //MARK:- Method to add new skills
    @IBAction func addSkillSet(sender: NSButton)
    {
        if managerialRoundFeedback.skillSet.count > 0 && cell?.titleName.stringValue == "Enter Title"
        {
            Utility.alertPopup("Enter Title", informativeText: "Please enter previous selected title",isCancelBtnNeeded:false,okCompletionHandler: nil)
        }
        else if  cell?.titleName.stringValue == ""
        {
            Utility.alertPopup("Enter Title", informativeText: "Skill title should not be blank",isCancelBtnNeeded:false, okCompletionHandler: nil)
        }
        else
        {
       let newSkill = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
        newSkill.skillName = "Enter Title"
        newSkill.skillRating = 0
        skillsAndRatingsTitleArray.append(newSkill)
        tableView.reloadData()
        }
    }
    
    //MARK:-Method to delete skills
    @IBAction func deleteSkillSet(sender: NSButton)
    {
        if tableView.selectedRow >= 4
        {
            skillsAndRatingsTitleArray.removeAtIndex(tableView.selectedRow)
            tableView.reloadData()
        }
    }
    
    //MARK:-Method to add star in overall technology assessment
    @IBAction func addOverAllAssessmentForTechnology(sender: AnyObject)
    {
            displayStar(viewOverAllAssessmentOfTechnologyStar, lbl:labelOverAllAssessmentOfTechnology, sender: sender as! NSButton)
    }
    
    //:- Method to add star in overall candidate assessment
    @IBAction func addOverAllAssessmentForCandidate(sender: AnyObject)
    {
            displayStar(viewOverAllAssessmentOfCandidateStar, lbl:labelOverAllAssessmentOfCandidate, sender: sender as! NSButton)
    }
    
    //MARK:- Method to enable/disable stars
    func displayStar(customView:AnyObject,lbl:NSTextField,sender:NSButton)
    {
        var totalView = customView.subviews
        if customView is EHManagerFeedBackCustomTableView{
            totalView = customView.selectStar!.subviews
        }
        
        var totalStarCount : Int?
        
        // Logic for selecting and deselecting stars
        func countingOfRatingStar(total: Int, deselectStar : Int?...)
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

                    
                    for countStar in 0...total
                    {
                        let countBtn = totalView[countStar] as! NSButton
                        if countBtn.image?.name() == "deselectStar"
                        {
                            countBtn.image = NSImage(named: "selectStar")
                        }
                    }
                }
            }
            else
            {

                
                for stars in deselectStar{
                    
                    let star = totalView[stars!] as! NSButton
                    
                    if star.image?.name() == "selectStar"{
                        
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
        
        
        // Logic for checking which star rating clicked
        switch (sender.tag)
        {
        case 0:
            countingOfRatingStar(0)
            
            lbl.stringValue = "Not Satisfactory"
           setSkillRating(customView,ratingValue: 1)
            
        case 1:
            countingOfRatingStar(1)
            lbl.stringValue = "Satisfactory"
            countingOfRatingStar(0, deselectStar: 2,3,4)
            setSkillRating(customView,ratingValue: 2)
            
        case 2:
            countingOfRatingStar(2)
            lbl.stringValue = "Good"
            countingOfRatingStar(0, deselectStar: 3,4)
             setSkillRating(customView,ratingValue: 3)
            
        case 3:
            countingOfRatingStar(3)
            lbl.stringValue = "Very Good"
            countingOfRatingStar(0, deselectStar: 4)
             setSkillRating(customView,ratingValue: 4)
        case 4:
            countingOfRatingStar(4)
            lbl.stringValue = "Excellent"
             setSkillRating(customView,ratingValue: 5)
        default : print("")
        }
        
    }
    
    
    //MARK:- Method to set skillSet into model class
    func setSkillRating(customView:AnyObject,ratingValue:Int16){
        if customView is EHManagerFeedBackCustomTableView{
            cell = customView as? EHManagerFeedBackCustomTableView
            let textFieldObject = customView.titleName as NSTextField
            let skillSetObject = skillsAndRatingsTitleArray[textFieldObject.tag] as SkillSet
            skillSetObject.skillRating = NSNumber(short: ratingValue)
        }
        else if customView as! NSView == viewOverAllAssessmentOfTechnologyStar{
            managerialRoundFeedback.ratingOnTechnical=ratingValue
        }
        else if customView as! NSView == viewOverAllAssessmentOfCandidateStar{
            managerialRoundFeedback.ratingOnCandidate=ratingValue
        }
    }
   
    
    
    //MARK:- Method to get interviewmode
    @IBAction func getInterviewMode(sender: AnyObject) {
        
        if (sender.selectedCell() == sender.cells[0])
        {
            managerialRoundFeedback.modeOfInterview = sender.cells[0].title
        }
        else
        {
           managerialRoundFeedback.modeOfInterview = sender.cells[1].title
        }
        
     
    }
    
    //MARK:- Method to get cgdeviation
    @IBAction func selectCgDeviation(sender: AnyObject) {
        
        let selectedColoumn = sender.selectedColumn
        if selectedColoumn == 0{
            managerialRoundFeedback.isCgDeviation = true
        }else{
            managerialRoundFeedback.isCgDeviation = false
        }
    }
    
    //MARK:- Method to set interviewmode
    func setModeOfInterview(value:String){
        if value == "Telephonic"{
            matrixForInterviewMode.setState(NSOnState, atRow: 0, column: 0)
            matrixForInterviewMode.setState(NSOffState, atRow: 0, column: 1)
            
        }else{
             matrixForInterviewMode.setState(NSOnState, atRow: 0, column: 1)
            matrixForInterviewMode.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    

    //MARK:- Method to set recommendation state

    func setRecommendationState(value:String){
        if value == "Shortlisted"{
            matrixForRecommendationState.setState(NSOnState, atRow: 0, column: 0)
             matrixForRecommendationState.setState(NSOffState, atRow: 0, column: 1)
        }else{
            matrixForRecommendationState.setState(NSOnState, atRow: 0, column: 1)
             matrixForRecommendationState.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    //MARK:- Method to set cgdeviation
    func setCgDeviation(value:Bool){
        if value{
            matrixForCgDeviation.setState(NSOnState, atRow: 0, column: 0)
             matrixForCgDeviation.setState(NSOffState, atRow: 0, column: 1)
        }else{
            matrixForCgDeviation.setState(NSOnState, atRow: 0, column: 1)
             matrixForCgDeviation.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
   
    
    //MARK:- Method to set default interviewmode/cgdeviation/recommendationstate
    func setDefaultCgDeviationAndInterviewMode(){
        managerialRoundFeedback.modeOfInterview = "Face To Face"
        managerialRoundFeedback.isCgDeviation = false
        managerialRoundFeedback.recommendation = "Shortlisted"
        managerialRoundFeedback.commentsOnCandidate = NSAttributedString(string: "")
        managerialRoundFeedback.commentsOnTechnology = NSAttributedString(string: "")
        managerialRoundFeedback.commitments = NSAttributedString(string: "")
        managerialRoundFeedback.designation = ""
        managerialRoundFeedback.recommendedCg = ""
        managerialRoundFeedback.designation = ""
        
        managerialRoundFeedback.jestificationForHire = NSAttributedString(string: "")
        managerialRoundFeedback.grossAnnualSalary = NSNumber(integer: 0)
        
        managerialRoundFeedback.managerName = ""
        managerialRoundFeedback.ratingOnTechnical=0
        managerialRoundFeedback.ratingOnCandidate=0
        
    }
    
    
    //MARK:- Method to validate is any field empty
    
    func validation() -> Bool
    {
        var isValid : Bool = false
        if cell?.feedBackRating.stringValue==""{
            Utility.alertPopup("Select Stars", informativeText: "Please provide rating for technical skills",isCancelBtnNeeded:false,okCompletionHandler: nil)
            return isValid
        }else if !validationForTextView(textViewCommentsForOverAllTechnologyAssessment,title: "Overall Feedback On Technology",informativeText: "Overall assessment of Technology field shold not be blank"){
            
            return isValid
            
        } else if !validationForTextView(textViewCommentsForOverAllCandidateAssessment,title: "Overall Feedback Of Candidate",informativeText: "Overall assessment of Candidate field shold not be blank"){
            
            return isValid
        }else if !validationForTextView(textViewJustificationForHire,title: "Justification For Hire",informativeText: "Justification for hire field should not be blank"){
            
            return isValid
            
        }else if !validationForTextView(textViewCommitments,title: "Commitments",informativeText: "Commitments field should not be blank"){
           
            return isValid
            
        }else if !validationForTextfield(textFieldCorporateGrade,title: "Corporate Grade",informativeText: "Corporate grade field should not be blank"){
            
            return isValid
            
        }else if !validationForTextfield(textFieldDesignation,title: "Designation",informativeText: "Designation field should not be blank"){
            
            return isValid
        }else if !validationForTextfield(textFieldGrossAnnualSalary,title: "Annual Salary",informativeText: "Annual Salay Field should not be empty"){
            
            return isValid
            
        }else if !validationForTextfield(textFieldInterviewedBy,title: "Interviewed By",informativeText: "Interviewed by field should not be empty"){
                       return isValid
        }else if !validationForTextfield(textFieldPosition,title: "Position",informativeText: "Position Field Should not be empty"){
           
            return isValid
        }else if !validationForTextfield(labelOverAllAssessmentOfCandidate,title: "Select Stars",informativeText: "Please  provide ratings for overall assessment of Candidate"){
            
            return isValid
        }else if !validationForTextfield(labelOverAllAssessmentOfTechnology,title: "Select Stars",informativeText: "Please  provide ratings for overall assessment on Technology"){
            
            return isValid
        }else{
            isValid = true
        }
        
                return isValid
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
   
    
    //MARK:- Core Data Saving Methods
    
    @IBAction func saveData(sender: AnyObject?)
    {
        
        
        if managerialRoundFeedback.isSubmitted == true{
            return
        }
        
              managerialRoundFeedback.commentsOnCandidate = NSAttributedString(string: textViewCommentsForOverAllCandidateAssessment.string!)
             managerialRoundFeedback.commentsOnTechnology = NSAttributedString(string: textViewCommentsForOverAllTechnologyAssessment.string!)
            managerialRoundFeedback.commitments = NSAttributedString(string: textViewCommitments.string!)
            managerialRoundFeedback.designation = textFieldDesignation.stringValue
            managerialRoundFeedback.recommendedCg = textFieldCorporateGrade.stringValue
            managerialRoundFeedback.designation = textFieldDesignation.stringValue

            managerialRoundFeedback.jestificationForHire = NSAttributedString(string: textViewJustificationForHire.string!)
            
            managerialRoundFeedback.isSubmitted = false
            print(textFieldGrossAnnualSalary.stringValue)
            
            
            let grossSalaryValue = NSString(string: textFieldGrossAnnualSalary.stringValue)
            managerialRoundFeedback.grossAnnualSalary = NSNumber(integer: grossSalaryValue.integerValue)
            
            managerialRoundFeedback.managerName = textFieldInterviewedBy.stringValue
            let selectedColoumn = matrixForRecommendationState.selectedColumn
            if selectedColoumn != 0
            {
                managerialRoundFeedback.recommendation = "Rejected"
            }else
            {
                managerialRoundFeedback.recommendation = "Shortlisted"
            }
            
            managerialRoundFeedback.skillSet = skillsAndRatingsTitleArray as [SkillSet]
            managerialRoundFeedback.isSubmitted = false
            
            let managerFeedbackAccessLayer = EHManagerFeedbackDataAccessLayer(managerFeedbackModel: managerialRoundFeedback)
        if isFeedBackSaved==false{
            if managerFeedbackAccessLayer.insertManagerFeedback(selectedCandidate!){
                isFeedBackSaved = true
                
                Utility.alertPopup("Success", informativeText: "Feedback for Managerround \((selectedCandidate?.interviewedByManagers?.count)!) has been sucessfully saved",isCancelBtnNeeded:false,okCompletionHandler: nil)
                
                
            }
        }else{
            let sortedResults = toSortArray((selectedCandidate?.interviewedByManagers?.allObjects)!)
            let managerFeedback =  sortedResults[selectedSegment!] as! ManagerFeedBack

            if managerFeedbackAccessLayer.updateManagerFeedback(selectedCandidate!, managerFeedback:managerFeedback){
                Utility.alertPopup("Success", informativeText: "Feedback for Managerround has been updated Successfully",isCancelBtnNeeded:false,okCompletionHandler: nil)

            }
        }
       
        
        
        
        
//        tableView.reloadData()
        
       
       
    }
    
    
    
    //PRAGMAMARK:- Update UI 
    func updateUIElements(feedback: ManagerFeedBack)
    {
        print(feedback.managerName)
        
        
        print (feedback.candidate?.name)
        print (feedback.candidate?.name)

       

        
        //managerialFeedbackModel.managerName = feedback.managerName!
        //textFieldDesignation.stringValue = feedback.designation!
        if feedback.commentsOnCandidate != nil{
            textViewCommentsForOverAllCandidateAssessment.string = feedback.commentsOnCandidate!
        }
        
        if feedback.commentsOnTechnology != nil{
            textViewCommentsForOverAllTechnologyAssessment.string = feedback.commentsOnTechnology
        }
        
        textFieldCandidateName.stringValue = (feedback.candidate?.name)!
        textFieldCorporateGrade.stringValue = feedback.recommendedCg!
        textViewCommitments.string = feedback.commitments
        textViewJustificationForHire.string = feedback.jestificationForHire!
        textFieldPosition.stringValue = feedback.designation!
        textFieldDesignation.stringValue = feedback.designation!
        textFieldInterviewedBy.stringValue = feedback.managerName!
        textFieldGrossAnnualSalary.stringValue = (feedback.grossAnnualSalary?.stringValue)!
        
        managerialRoundFeedback.ratingOnTechnical = Int16((feedback.ratingOnTechnical?.integerValue)!)
        managerialRoundFeedback.ratingOnCandidate = Int16((feedback.ratingOnCandidate?.integerValue)!)
        managerialRoundFeedback.grossAnnualSalary = feedback.grossAnnualSalary
        managerialRoundFeedback.recommendedCg = feedback.recommendedCg
        managerialRoundFeedback.jestificationForHire = NSAttributedString(string: "")
        managerialRoundFeedback.managerName = feedback.managerName
        managerialRoundFeedback.modeOfInterview = feedback.modeOfInterview
        managerialRoundFeedback.recommendation = feedback.recommendation
        managerialRoundFeedback.isCgDeviation = feedback.isCgDeviation
        managerialRoundFeedback.isSubmitted = feedback.isSubmitted
        
        setModeOfInterview(managerialRoundFeedback.modeOfInterview!)
        setRecommendationState(managerialRoundFeedback.recommendation!)
        setCgDeviation(Bool(managerialRoundFeedback.isCgDeviation!.boolValue))
        
         disableAndEnableFields((managerialRoundFeedback.isSubmitted?.boolValue)!)
        skillsAndRatingsTitleArray.removeAll()
        for object in feedback.candidateSkills!
        {
            let skillset = object as! SkillSet
            
            let newSkill = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
            
            newSkill.skillName   = skillset.skillName
            newSkill.skillRating = skillset.skillRating
            skillsAndRatingsTitleArray.append(newSkill)
        }

        
        print(managerialRoundFeedback.skillSet.count)
        
        if !(managerialRoundFeedback.ratingOnTechnical == nil) {
            for starButton in viewOverAllAssessmentOfTechnologyStar.subviews{
                let tempBtn = starButton as! NSButton
                if tempBtn.tag == (managerialRoundFeedback.ratingOnTechnical!-1){
                    displayStar(viewOverAllAssessmentOfTechnologyStar, lbl: labelOverAllAssessmentOfTechnology, sender: tempBtn )
                }
            }
        }
        
        
        if !(managerialRoundFeedback.ratingOnCandidate == nil) {
            for starButton in viewOverAllAssessmentOfCandidateStar.subviews{
                let tempBtn = starButton as! NSButton
                if tempBtn.tag == (managerialRoundFeedback.ratingOnCandidate!-1){
                    displayStar(viewOverAllAssessmentOfCandidateStar, lbl: labelOverAllAssessmentOfCandidate, sender: tempBtn )
                }
            }
        }
        //To Disable the Saved data
        
                tableView.reloadData()
    }
    
    
    func disableAndEnableFields(isDataSubmitted:Bool){
        
        if isDataSubmitted==true{
            saveBtn.enabled = false
            submitBtn.enabled = false
            
            textFieldGrossAnnualSalary.editable = false
            textFieldDesignation.editable = false
            textFieldCorporateGrade.editable = false
            textFieldInterviewedBy.editable = false
            textFieldPosition.editable = false
            textViewCommentsForOverAllCandidateAssessment.editable = false
            textViewCommentsForOverAllTechnologyAssessment.editable = false
            textViewCommitments.editable = false
            textViewJustificationForHire.editable = false
            addNewSkillBtn.enabled = false
            deleteExistingBtn.enabled = false
            for starButton in (viewOverAllAssessmentOfCandidateStar.subviews){
                let tempBtn = starButton as! NSButton
                tempBtn.enabled = false
                
            }
            for starButton in (viewOverAllAssessmentOfTechnologyStar.subviews){
                let tempBtn = starButton as! NSButton
                tempBtn.enabled = false
                
            }
        }else{
            saveBtn.enabled = true
            submitBtn.enabled = true
            textFieldGrossAnnualSalary.editable = true
            textFieldDesignation.editable = true
            textFieldCorporateGrade.editable = true
            textFieldInterviewedBy.editable = true
            textFieldPosition.editable = true
            textViewCommentsForOverAllCandidateAssessment.editable = true
            textViewCommentsForOverAllTechnologyAssessment.editable = true
            textViewCommitments.editable = true
            textViewJustificationForHire.editable = true
            addNewSkillBtn.enabled = true
            deleteExistingBtn.enabled = true
           
            cell?.feedBackRating.editable = false
            for starButton in (viewOverAllAssessmentOfCandidateStar.subviews){
                let tempBtn = starButton as! NSButton
                
                tempBtn.enabled = true
                tempBtn.image = NSImage(named: "deselectStar")
                
            }
            for starButton in (viewOverAllAssessmentOfTechnologyStar.subviews){
                let tempBtn = starButton as! NSButton
                tempBtn.enabled = true
               tempBtn.image = NSImage(named: "deselectStar")
            }
        }
    }
    

    func sortArray (allObj : [AnyObject],index:Int) ->Bool{
        isFeedBackSaved = true
        selectedSegment = index
        let arra = NSArray(array: allObj)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortedResults: NSArray = arra.sortedArrayUsingDescriptors([descriptor])
        
                let managerFeedback =  sortedResults[index] as! ManagerFeedBack
        updateUIElements(managerFeedback)
        return true

    }
    
    func toSortArray(allObj : [AnyObject])->NSArray{
        let arra = NSArray(array: allObj)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortedResults: NSArray = arra.sortedArrayUsingDescriptors([descriptor])
        return sortedResults
    }
    
    //MARK:- Submit Feedback
    @IBAction func submitFeedback(sender: AnyObject?) {
        
        if validation(){
            managerialRoundFeedback.commentsOnCandidate = NSAttributedString(string: textViewCommentsForOverAllCandidateAssessment.string!)
            managerialRoundFeedback.commentsOnTechnology = NSAttributedString(string: textViewCommentsForOverAllTechnologyAssessment.string!)
            managerialRoundFeedback.commitments = NSAttributedString(string: textViewCommitments.string!)
            managerialRoundFeedback.designation = textFieldDesignation.stringValue
            managerialRoundFeedback.recommendedCg = textFieldCorporateGrade.stringValue
            managerialRoundFeedback.designation = textFieldDesignation.stringValue
            
            managerialRoundFeedback.jestificationForHire = NSAttributedString(string: textViewJustificationForHire.string!)
            
            print(textFieldGrossAnnualSalary.stringValue)
            
            
            let grossSalaryValue = NSString(string: textFieldGrossAnnualSalary.stringValue)
            managerialRoundFeedback.grossAnnualSalary = NSNumber(integer: grossSalaryValue.integerValue)
            
            managerialRoundFeedback.managerName = textFieldInterviewedBy.stringValue
            let selectedColoumn = matrixForRecommendationState.selectedColumn
            if selectedColoumn != 0
            {
                managerialRoundFeedback.recommendation = "Rejected"
            }else
            {
                managerialRoundFeedback.recommendation = "Shortlisted"
            }
            managerialRoundFeedback.isSubmitted = true
            
            managerialRoundFeedback.skillSet = skillsAndRatingsTitleArray as [SkillSet]
            
            let managerFeedbackAccessLayer = EHManagerFeedbackDataAccessLayer(managerFeedbackModel: managerialRoundFeedback)
            if isFeedBackSaved==false{
                if managerFeedbackAccessLayer.insertManagerFeedback(selectedCandidate!){
                    
                    Utility.alertPopup("Success", informativeText: "Feedback for Managerround \((selectedCandidate?.interviewedByManagers?.count)!) has been sucessfully saved",isCancelBtnNeeded:false,okCompletionHandler: nil)

                }
            }else{
                let sortedResults = toSortArray((selectedCandidate?.interviewedByManagers?.allObjects)!)
                let managerFeedback =  sortedResults[selectedSegment!] as! ManagerFeedBack
                print(selectedSegment)
                if managerFeedbackAccessLayer.updateManagerFeedback(selectedCandidate!, managerFeedback:managerFeedback){
                    Utility.alertPopup("Success", informativeText: "Feedback for Managerround has been updated Successfully",isCancelBtnNeeded:false,okCompletionHandler: nil)

                }
            }
        
         disableAndEnableFields(true)
            tableView.reloadData()
        }
    }
    
    //MARK:- Refresh All Fields
    func refreshAllFields()
    {
        textFieldCandidateName.stringValue = ""
        textFieldCorporateGrade.stringValue = ""
        textViewCommitments.string = ""
        textViewJustificationForHire.string = ""
        textFieldPosition.stringValue = ""
        textFieldDesignation.stringValue = ""
        textViewCommentsForOverAllCandidateAssessment.string = ""
        textViewCommentsForOverAllTechnologyAssessment.string = ""
        textFieldGrossAnnualSalary.stringValue = ""
        textFieldInterviewedBy.stringValue = ""

        managerialRoundFeedback.isSubmitted = false
         managerialRoundFeedback.ratingOnCandidate = 0
         managerialRoundFeedback.ratingOnTechnical = 0

        skillsAndRatingsTitleArray.removeAll()
        addDefalutSkillSet()

       // tableView.reloadData()
        
        for starButton in viewOverAllAssessmentOfTechnologyStar.subviews{
            let tempBtn = starButton as! NSButton
            tempBtn.image = NSImage(named: "deselectStar")

            }
        
        for starButton in viewOverAllAssessmentOfCandidateStar.subviews{
            let tempBtn = starButton as! NSButton
            tempBtn.image = NSImage(named: "deselectStar")
        }
        labelOverAllAssessmentOfCandidate.stringValue = ""
        labelOverAllAssessmentOfTechnology.stringValue = ""
        
        setRecommendationState("Shortlisted")
        setModeOfInterview("Face To Face")
        setCgDeviation(false)
        setDefaultCgDeviationAndInterviewMode()
        disableAndEnableFields(false)
        isFeedBackSaved = false
        tableView.reloadData()
    }
    
    @IBAction func clearAllFields(sender: AnyObject)
    {
        refreshAllFields()
    }
}

