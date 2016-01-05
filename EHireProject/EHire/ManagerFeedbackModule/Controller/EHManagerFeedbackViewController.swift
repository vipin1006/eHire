//
//  EHManagerFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerFeedbackViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate {

    @IBOutlet var managerFeedbackMainView: NSView!
   
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
   
   
    override func loadView() {
        
       candidateDetails = EHCandidateDetails(inName: selectedCandidate!.name!,candidateExperience:(selectedCandidate?.experience)! , candidateInterviewTiming: "1023.22", candidatePhoneNo:(selectedCandidate?.phoneNumber)!) as EHCandidateDetails
        
        
        
        candidateDetails!.interviewDate = NSDate()
        managerialFeedbackModel.candidate = candidateDetails
        let skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"] as NSMutableArray
        
        for index in 0...3
        {
            let skillSetObject = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:(selectedCandidate?.managedObjectContext)!)!,insertIntoManagedObjectContext:selectedCandidate?.managedObjectContext)
            skillSetObject.skillName = skillArray.objectAtIndex(index) as? String
            managerialFeedbackModel.skillSet.append(skillSetObject)
        }
        
        
        
        //            self.ratingTitle.addObject("Communication")
        //            self.ratingTitle.addObject("Organisation Stability")
        //            self.ratingTitle.addObject("Leadership(if applicable)")
        //            self.ratingTitle.addObject("Growth Potential")
        //        }
        
        super.loadView()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        managerFeedbackMainView.wantsLayer = true
        managerFeedbackMainView.layer?.backgroundColor = NSColor.gridColor().colorWithAlphaComponent(0.5).CGColor
        tableView.reloadData()
        setDefaultCgDeviationAndInterviewMode()
//        numberFieldVilidation()
//        if ratingTitle.count == 0
//        {
        
        
        
        if selectedCandidate != nil
        {
            for x in (selectedCandidate?.interviewedByManagers)!
            {
                let feedback = x as! ManagerFeedBack
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
            
            if !(managerialFeedbackModel.ratingOnTechnical == nil) {
                for starBtn in viewOverAllAssessmentOfTechnologyStar.subviews{
                    let tempBtn = starBtn as! NSButton
                    if tempBtn.tag == (managerialFeedbackModel.ratingOnTechnical!-1){
                        displayStar(viewOverAllAssessmentOfTechnologyStar, lbl: labelOverAllAssessmentOfTechnology, sender: tempBtn )
                    }
                }
            }
            
            
            if !(managerialFeedbackModel.ratingOnCandidate == nil) {
                for starBtn in viewOverAllAssessmentOfCandidateStar.subviews{
                    let tempBtn = starBtn as! NSButton
                    if tempBtn.tag == (managerialFeedbackModel.ratingOnCandidate!-1){
                        displayStar(viewOverAllAssessmentOfCandidateStar, lbl: labelOverAllAssessmentOfCandidate, sender: tempBtn )
                    }
                }
            }

            
            tableView.reloadData()
        }
            }
        
        print("name = \(managerialFeedbackModel.designation)")
    }
    
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
        
        if !(skillSetObject.skillRating == nil) {
            for starBtn in cell.selectStar.subviews{
                let tempBtn = starBtn as! NSButton
                if tempBtn.tag+1 == (skillSetObject.skillRating!){
                    displayStar(cell, lbl: cell.feedBackRating, sender: tempBtn )
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
    
    func alertPopup(data:String, informativeText:String){
        
        let alert:NSAlert = NSAlert()
        alert.messageText = data
        alert.informativeText = informativeText
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.runModal()
    }
    
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
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        let skillSetObject =  managerialFeedbackModel?.skillSet[control.tag]
        skillSetObject?.skillName = fieldEditor.string!
        return true
    }
    
    @IBAction func addSkillSet(sender: NSButton)
    {
        
       let newSkill = SkillSet(entity:EHCoreDataHelper.createEntity("SkillSet", managedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)!,insertIntoManagedObjectContext:EHCoreDataStack.sharedInstance.managedObjectContext)
        newSkill.skillName = "Enter Title"
        newSkill.skillRating = 0
        managerialFeedbackModel?.skillSet.append(newSkill)
        tableView.reloadData()
    }
    
    @IBAction func deleteSkillSet(sender: NSButton)
    {
        managerialFeedbackModel?.skillSet.removeAtIndex(tableView.selectedRow)
            tableView.reloadData()
    }
    
    @IBAction func addOverAllAssessmentForTechnology(sender: AnyObject)
    {
        
            displayStar(viewOverAllAssessmentOfTechnologyStar, lbl:labelOverAllAssessmentOfTechnology, sender: sender as! NSButton)
        
    }
    
    @IBAction func addOverAllAssessmentForCandidate(sender: AnyObject)
    {
       
            displayStar(viewOverAllAssessmentOfCandidateStar, lbl:labelOverAllAssessmentOfCandidate, sender: sender as! NSButton)
            
       
        
    }
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
   
    
    
    //MARK:- Getting Matrix Value
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
    
    
    @IBAction func selectCgDeviation(sender: AnyObject) {
        
        let selectedColoumn = sender.selectedColumn
        if selectedColoumn == 0{
            managerialFeedbackModel.isCgDeviation = true
        }else{
            managerialFeedbackModel.isCgDeviation = false
        }
    }
    
    //MARK:- Setting Matrix Value
    func setModeOfInterview(value:String){
        if value == "Telephonic"{
            matrixForInterviewMode.setState(NSOnState, atRow: 0, column: 0)
            matrixForInterviewMode.setState(NSOffState, atRow: 0, column: 1)
            
        }else{
             matrixForInterviewMode.setState(NSOnState, atRow: 0, column: 1)
            matrixForInterviewMode.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    

    
    func setRecommendationState(value:String){
        if value == "Shortlisted"{
            matrixForRecommendationState.setState(NSOnState, atRow: 0, column: 0)
             matrixForRecommendationState.setState(NSOffState, atRow: 0, column: 1)
        }else{
            matrixForRecommendationState.setState(NSOnState, atRow: 0, column: 1)
             matrixForRecommendationState.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
    func setCgDeviation(value:Bool){
        if value{
            matrixForCgDeviation.setState(NSOnState, atRow: 0, column: 0)
             matrixForCgDeviation.setState(NSOffState, atRow: 0, column: 1)
        }else{
            matrixForCgDeviation.setState(NSOnState, atRow: 0, column: 1)
             matrixForCgDeviation.setState(NSOffState, atRow: 0, column: 0)
        }
    }
    
   
    
    
    func setDefaultCgDeviationAndInterviewMode(){
        managerialFeedbackModel.modeOfInterview = "Face To Face"
        managerialFeedbackModel.isCgDeviation = false
        managerialFeedbackModel.recommendation = "Shortlisted"
    }
    
    
    //MARK:- Validation Methods
    
    func validation() -> Bool
    {
        var isValid : Bool = false
        isValid =  validationForTextView(textViewCommentsForOverAllCandidateAssessment)
        isValid =  validationForTextView(textViewCommentsForOverAllTechnologyAssessment)
        isValid =  validationForTextView(textViewJustificationForHire)
        isValid =  validationForTextView(textViewCommitments)
        isValid =  validationForTextfield(textFieldCorporateGrade)
        isValid =  validationForTextfield(textFieldDesignation)
        isValid =  validationForTextfield(textFieldGrossAnnualSalary)
        isValid =  validationForTextfield(textFieldInterviewedBy)
        isValid =  validationForTextfield(textFieldPosition)
        isValid =  validationForTextfield(labelOverAllAssessmentOfCandidate)
        isValid =  validationForTextfield(labelOverAllAssessmentOfTechnology)
        
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
    func validationForTextView(subView : NSTextView) -> Bool
    {
        if subView.string == ""
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
        
        else
        {
            subView.wantsLayer = true
            subView.layer?.backgroundColor = NSColor.clearColor().CGColor
            return true
        }
    }
   
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
    
    //MARK:- NumberField Validation for Textfields
    

   
    
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
            print("Suceeded")
        }
        }
        
//        tableView.reloadData()
        
       
       
    }
    
    //MARK:- CoreDataMethods
    func saveManegerFeedbackToToCoreData(){
        
//        let newTechnologyEntityDescription = EHCoreDataHelper.createEntity("ManagerFeedBack", managedObjectContext: appDelegate.managedObjectContext)
        
        let newTechnologyEntityDescription = EHCoreDataHelper.createEntity("ManagerFeedBack", managedObjectContext: appDelegate.managedObjectContext)
        let newMangerFeedbackManagedObject:ManagerFeedBack = ManagerFeedBack(entity:newTechnologyEntityDescription!, insertIntoManagedObjectContext:appDelegate.managedObjectContext) as ManagerFeedBack
        
        newMangerFeedbackManagedObject.managerName = "pavi"
        EHCoreDataHelper.saveToCoreData(newMangerFeedbackManagedObject)

    }
    
}
