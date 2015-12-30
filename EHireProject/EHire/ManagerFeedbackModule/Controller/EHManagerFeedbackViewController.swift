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
    
    
    var ratingTitle = NSMutableArray()
    
    @IBOutlet weak var tableView: NSTableView!
    
    let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var managerialFeedbackModel: EHManagerialFeedbackModel!
    let candidateDetails = EHCandidateDetails(inName: "vipin",candidateExperience:"1" , candidateInterviewTiming: "1023.22", candidatePhoneNo:"33131231312") as EHCandidateDetails
   
   
    override func loadView() {
        
        
        
        candidateDetails.interviewDate = NSDate()
       
        let communicationSkill = EHSkillSet()
        communicationSkill.skillName = "Communication"
//        communicationSkill.skillRating = 3
        let organisationStabilitySkill = EHSkillSet()
        organisationStabilitySkill.skillName = "Organisation Stability"
        organisationStabilitySkill.skillRating = 1
        
        let leaderShipSkill = EHSkillSet()
        leaderShipSkill.skillName = "Leadership(if applicable)"
//        leaderShipSkill.skillRating = 4
        
        let growthPotentialSkill = EHSkillSet()
        growthPotentialSkill.skillName = "Growth Potential"
//        growthPotentialSkill.skillRating = 2
        
        managerialFeedbackModel!.skillSet.append(communicationSkill)
        managerialFeedbackModel!.skillSet.append(organisationStabilitySkill)
        managerialFeedbackModel!.skillSet.append(leaderShipSkill)
        managerialFeedbackModel!.skillSet.append(growthPotentialSkill)
        
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
//        if ratingTitle.count == 0
//        {
        
        
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
        
        let skillSetObject = managerialFeedbackModel!.skillSet[row] as EHSkillSet
        cell.titleName.stringValue = skillSetObject.skillName!
        cell.titleName.tag = row
        cell.titleName.target = self
        cell.titleName.delegate = self
        cell.titleName.editable = true
        
        if !(skillSetObject.skillRating == nil) {
            for starBtn in cell.selectStar.subviews{
                let tempBtn = starBtn as! NSButton
                if tempBtn.tag == (skillSetObject.skillRating!-1){
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
        let skillSetObject = EHSkillSet()
        skillSetObject.skillName = "Enter Title"
        managerialFeedbackModel?.skillSet.append(skillSetObject)
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
            let skillSetObject = managerialFeedbackModel!.skillSet[textFieldObject.tag] as EHSkillSet
            skillSetObject.skillRating = ratingValue
            print("name = \(skillSetObject.skillName)")
        }
        else if customView as! NSView == viewOverAllAssessmentOfTechnologyStar{
            managerialFeedbackModel!.ratingOnTechnical=ratingValue
        }
        else if customView as! NSView == viewOverAllAssessmentOfCandidateStar{
            managerialFeedbackModel!.ratingOnCandidate=ratingValue
        }
    }
    func validateInputs()->Bool
    {
        if textFieldPosition.stringValue == ""
        {
            alertPopup("enterPosition", informativeText: "Please enter valid Position")
            return false
        }else if textFieldInterviewedBy.stringValue == ""
        {
            alertPopup("enterInterViewBy", informativeText: "Please enter valid Name")
            return false
        }
        else if textFieldCorporateGrade.stringValue == ""
        {
            alertPopup("enterCG", informativeText: "Please enter valid data valid CG")
            return false
        }
        else if( textViewCommitments.string == "")
        {
            alertPopup("enterCommitments", informativeText: "Please enter valid data Commitments Field")
            return false
        }else if textViewJustificationForHire.string == ""
        {
            alertPopup("justificationForHire", informativeText: "Please enter valid data justificationForHire Field")
            return false
        }else if textFieldGrossAnnualSalary.stringValue == ""
        {
            alertPopup("enterGrossSalary", informativeText: "Please enter valid data in GrossSalary Field")
            return false
        }else if textFieldDesignation.stringValue == ""
        {
            alertPopup("enterDesignation", informativeText: "Please enter valid data in designation Field")
            return false
        }
        return true
    }
    
    
    @IBAction func getInterviewMode(sender: AnyObject) {
        
        let selectedColoumn = sender.selectedColumn
        if selectedColoumn == 0{
          managerialFeedbackModel.modeOfInterview = "Telephonic"
        }else{
            managerialFeedbackModel.modeOfInterview = "Face To Face"
        }
        
     
    }
    
   
    
    @IBAction func saveData(sender: AnyObject)
    {
//        //if validateInputs(){
//            saveManegerFeedbackToToCoreData()
//        //}
        let managerFeedbackAccessLayer = EHManagerFeedbackDataAccessLayer(managerFeedbackModel: managerialFeedbackModel)
        if managerFeedbackAccessLayer.insertManagerFeedback(){
            print("Suceeded")
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
    
    func fetchManagerFeedbackFromCoreData(){
        
    }
}
