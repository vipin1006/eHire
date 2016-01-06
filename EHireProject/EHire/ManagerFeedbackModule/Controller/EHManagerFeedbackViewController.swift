//
//  EHManagerFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerFeedbackViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate {

    @IBOutlet weak var saveBtn: NSButton!
    @IBOutlet var managerFeedbackMainView: NSView!
   
    @IBOutlet weak var textFieldCandidateName: NSTextField!
    
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
    
    @IBOutlet dynamic var  managerialFeedbackModel: EHManagerialFeedbackModel!
    var candidateDetails : EHCandidateDetails?
    
    
    var selectedCandidate : Candidate?
   
    var cell : EHManagerFeedBackCustomTableView?
   
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
        managerFeedbackMainView.wantsLayer = true
        managerFeedbackMainView.layer?.backgroundColor = NSColor.gridColor().colorWithAlphaComponent(0.5).CGColor
        tableView.reloadData()
        setDefaultCgDeviationAndInterviewMode()
        
        
        
        if selectedCandidate != nil
        { if selectedCandidate?.interviewedByManagers?.count != 0{
            sortArray((selectedCandidate?.interviewedByManagers?.allObjects)!,index: 0)

            }
            tableView.reloadData()
        }
        
        
        print("name = \(managerialFeedbackModel.designation)")
    }
    
    //MARK:- Method for Adding Default Skills
    func addDefalutSkillSet(){
        let skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"] as NSMutableArray
        
        for index in 0...3
        {
            let skillSetObject = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
            skillSetObject.skillName = skillArray.objectAtIndex(index) as? String
            managerialFeedbackModel.skillSet.append(skillSetObject)
        }
        
    }

    //MARK:-TableView DataSource Methods
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return (managerialFeedbackModel?.skillSet.count)!
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 25
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = tableView.makeViewWithIdentifier("DataCell", owner: self) as! EHManagerFeedBackCustomTableView
        
        let skillSetObject = managerialFeedbackModel!.skillSet[row] as SkillSet
        cell.titleName.stringValue = skillSetObject.skillName!
        cell.titleName.tag = row
        cell.titleName.target = self
        cell.titleName.delegate = self
        cell.titleName.editable = true
      self.cell = cell
        if !(skillSetObject.skillRating == nil) {
            for starButton in cell.selectStar.subviews{
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
            view.target = self
            view.action = "selectedStarCount:"
            
        }
        return cell
    }
    
    
    //MARK:- Method to select star in tableview
    func selectedStarCount(sender : NSButton)
    {
        let ratingCell = sender.superview?.superview as! EHManagerFeedBackCustomTableView
        if ratingCell.titleName.stringValue == "Enter Title"
        {
            alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name")
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
            
            let skillSetObject =  managerialFeedbackModel?.skillSet[textFieldObject.tag]
            skillSetObject?.skillName = textFieldObject.stringValue
        }
    }
    
 //MARK:- Method to add new skills
    @IBAction func addSkillSet(sender: NSButton)
    {
        if managerialFeedbackModel.skillSet.count > 0 && cell?.titleName.stringValue == "Enter Title"
        {
            alertPopup("Enter Title", informativeText: "Please enter previous selected title")
        }
        else
        {
       let newSkill = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
        newSkill.skillName = "Enter Title"
        newSkill.skillRating = 0
        managerialFeedbackModel?.skillSet.append(newSkill)
        tableView.reloadData()
        }
    }
    
    //MARK:-Method to delete skills
    @IBAction func deleteSkillSet(sender: NSButton)
    {
        managerialFeedbackModel?.skillSet.removeAtIndex(tableView.selectedRow)
            tableView.reloadData()
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
            let skillSetObject = managerialFeedbackModel!.skillSet[textFieldObject.tag] as SkillSet
            skillSetObject.skillRating = NSNumber(short: ratingValue)
            print("name = \(skillSetObject.skillName)")
        }
        else if customView as! NSView == viewOverAllAssessmentOfTechnologyStar{
            managerialFeedbackModel!.ratingOnTechnical=ratingValue
        }
        else if customView as! NSView == viewOverAllAssessmentOfCandidateStar{
            managerialFeedbackModel!.ratingOnCandidate=ratingValue
        }
    }
   
    
    
    //MARK:- Method to get interviewmode
    @IBAction func getInterviewMode(sender: AnyObject) {
        
       
        
        
        if (sender.selectedCell() == sender.cells[0])
        {
            managerialFeedbackModel.modeOfInterview = sender.cells[0].title
        }
        else
        {
           managerialFeedbackModel.modeOfInterview = sender.cells[1].title
        }
        
     
    }
    
    //MARK:- Method to get cgdeviation
    @IBAction func selectCgDeviation(sender: AnyObject) {
        
        let selectedColoumn = sender.selectedColumn
        if selectedColoumn == 0{
            managerialFeedbackModel.isCgDeviation = true
        }else{
            managerialFeedbackModel.isCgDeviation = false
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
        managerialFeedbackModel.modeOfInterview = "Face To Face"
        managerialFeedbackModel.isCgDeviation = false
        managerialFeedbackModel.recommendation = "Shortlisted"
    }
    
    
    //MARK:- Method to validate is any field empty
    
    func validation() -> Bool
    {
        var isValid : Bool = false
        if cell?.feedBackRating.stringValue==""{
            alertPopup("Select Stars", informativeText: "Please provide rating for technical skills")
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
            alertPopup(title,informativeText:informativeText)
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
            alertPopup(title,informativeText:informativeText)
            return false
        }
        
        else
        {
            
            return true
        }
    }
   
    //MARK:- Method to shoe alert
    func alertPopup(data:String, informativeText:String){
        
        let alert:NSAlert = NSAlert()
        alert.messageText = data
        alert.informativeText = informativeText
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.runModal()
    }
    
    //MARK:- Core Data Saving Methods
    
    @IBAction func saveData(sender: AnyObject)
    {
        
        
        if validation(){
            
            let selectedColoumn = matrixForRecommendationState.selectedColumn
            if selectedColoumn != 0
            {
                managerialFeedbackModel.recommendation = "Rejected"
            }else
            {
                managerialFeedbackModel.recommendation = "Shortlisted"
            }
        let managerFeedbackAccessLayer = EHManagerFeedbackDataAccessLayer(managerFeedbackModel: managerialFeedbackModel)
        if managerFeedbackAccessLayer.insertManagerFeedback(selectedCandidate!){
           alertPopup("Success",informativeText:"Feedback for Managerround \((selectedCandidate?.interviewedByManagers?.count)!) has been sucessfully saved")
        }
        }
        
//        tableView.reloadData()
        
       
       
    }
    
    
    
    //PRAGMAMARK:- Update UI 
    func updateUIElements(feedback: ManagerFeedBack){
        print(feedback.managerName)
        
        
        print (feedback.candidate?.name)
        
        
        //managerialFeedbackModel.managerName = feedback.managerName!
        managerialFeedbackModel.designation = feedback.designation!
        if feedback.commentsOnCandidate != nil{
            managerialFeedbackModel.commentsOnCandidate = NSAttributedString(string: feedback.commentsOnCandidate!)
        }
        
        if feedback.commentsOnTechnology != nil{
            managerialFeedbackModel.commentsOnTechnology = NSAttributedString(string: feedback.commentsOnTechnology!)
        }
        managerialFeedbackModel.commitments = NSAttributedString(string: feedback.commitments!)
        managerialFeedbackModel.ratingOnTechnical = Int16((feedback.ratingOnTechnical?.integerValue)!)
        managerialFeedbackModel.ratingOnCandidate = Int16((feedback.ratingOnCandidate?.integerValue)!)
        managerialFeedbackModel.grossAnnualSalary = feedback.grossAnnualSalary
        managerialFeedbackModel.recommendedCg = feedback.recommendedCg
        managerialFeedbackModel.jestificationForHire = NSAttributedString(string: feedback.jestificationForHire!)
        managerialFeedbackModel.managerName = feedback.managerName
        managerialFeedbackModel.modeOfInterview = feedback.modeOfInterview
        managerialFeedbackModel.recommendation = feedback.recommendation
        managerialFeedbackModel.isCgDeviation = feedback.isCgDeviation
        
        setModeOfInterview(managerialFeedbackModel.modeOfInterview!)
        setRecommendationState(managerialFeedbackModel.recommendation!)
        setCgDeviation(Bool(managerialFeedbackModel.isCgDeviation!.boolValue))
        
        
        managerialFeedbackModel!.skillSet.removeAll()
        for object in feedback.candidateSkills!{
            let skillset = object as! SkillSet
            
            //                let communicationSkill = EHSkillSet()
            //                communicationSkill.skillName = skillset.skillName
            //                communicationSkill.skillRating = Int16((skillset.skillRating?.integerValue)!)
            managerialFeedbackModel!.skillSet.append(skillset)
        }
        
        print(managerialFeedbackModel!.skillSet.count)
        
        if !(managerialFeedbackModel.ratingOnTechnical == nil) {
            for starButton in viewOverAllAssessmentOfTechnologyStar.subviews{
                let tempBtn = starButton as! NSButton
                if tempBtn.tag == (managerialFeedbackModel.ratingOnTechnical!-1){
                    displayStar(viewOverAllAssessmentOfTechnologyStar, lbl: labelOverAllAssessmentOfTechnology, sender: tempBtn )
                }
            }
        }
        
        
        if !(managerialFeedbackModel.ratingOnCandidate == nil) {
            for starButton in viewOverAllAssessmentOfCandidateStar.subviews{
                let tempBtn = starButton as! NSButton
                if tempBtn.tag == (managerialFeedbackModel.ratingOnCandidate!-1){
                    displayStar(viewOverAllAssessmentOfCandidateStar, lbl: labelOverAllAssessmentOfCandidate, sender: tempBtn )
                }
            }
        }
        tableView.reloadData()

    }
    

    func sortArray (allObj : [AnyObject],index:Int) ->Bool{
        let arra = NSArray(array: allObj)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortedResults: NSArray = arra.sortedArrayUsingDescriptors([descriptor])//                let feedback = allObj![0]
        
//        if sortedResults.count != 0{
//           let managerFeedback =  sortedResults[0] as! ManagerFeedBack
//            if managerFeedback.recommendation == "Rejected" && index == 1 {
//                Utility.alertPopup("Alert", informativeText: "Candidate has been rejected", okCompletionHandler: nil)
//                return false
//            }
//        }
        let managerFeedback =  sortedResults[index] as! ManagerFeedBack
        updateUIElements(managerFeedback)
        return true

    }
    
    
    func refreshAllFields()
    {
        
        managerialFeedbackModel.commentsOnCandidate = NSAttributedString(string: "")

        managerialFeedbackModel.commentsOnTechnology = NSAttributedString(string: "")
        managerialFeedbackModel.commitments = NSAttributedString(string: "")
        managerialFeedbackModel.grossAnnualSalary = NSNumber(integer: 0)
        
        managerialFeedbackModel.managerName = ""
        //managerialFeedbackModel. isCgDeviation = NSNumber(integer: 0)
 
        managerialFeedbackModel.jestificationForHire = NSAttributedString(string: "")
        managerialFeedbackModel.modeOfInterview = ""
        managerialFeedbackModel.ratingOnCandidate = 0
        managerialFeedbackModel.ratingOnTechnical = 0
        managerialFeedbackModel.recommendation = ""
        managerialFeedbackModel.recommendedCg = ""
        managerialFeedbackModel.designation = ""
        managerialFeedbackModel?.skillSet.removeAll()
        addDefalutSkillSet()

        tableView.reloadData()
        
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
        
        setRecommendationState("Rejected")
        setModeOfInterview("Face To Face")
        setCgDeviation(false)
//        saveBtn.enabled = true
    }
    
}

