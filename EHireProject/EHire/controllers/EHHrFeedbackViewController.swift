//
//  EHHrFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHHrFeedbackViewController: NSViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var candidateName: NSTextField!
    
    @IBOutlet weak var candidateBusinessUnit: NSTextField!
    
    @IBOutlet weak var candidateSkillOrTechnology: NSTextField!
    
    @IBOutlet weak var candidateTotalItExperience: NSTextField!
    
    @IBOutlet weak var candidateMobile: NSTextField!
    
    @IBOutlet weak var candidateCurrentLocation: NSTextField!
    
    @IBOutlet weak var companyName: NSTextField!
    
    @IBOutlet weak var currentDesignation: NSTextField!
    
    @IBOutlet weak var currentJobType: NSTextField!
    
    @IBOutlet weak var candidateRelevantItExperience: NSTextField!
    
    @IBOutlet weak var officialMailid: NSTextField!
    
    @IBOutlet weak var visaTypeAndValidity: NSTextField!
    
    
    @IBOutlet weak var passportYes: NSButton!
    
    
    @IBOutlet weak var passportNo: NSButton!
    
    
    @IBOutlet weak var relocationYes: NSButton!
    
    
    @IBOutlet weak var relocationNo: NSButton!
    
    
    @IBOutlet weak var previousEmployerName: NSTextField!
    
    @IBOutlet weak var previousEmployerFromDate: NSDatePicker!
    
    @IBOutlet weak var previousEmployerToDate: NSDatePicker!
    
    @IBOutlet weak var highestEducationQualificationTitle: NSTextField!
    
    @IBOutlet weak var highestEducationFromDate: NSDatePicker!
    
    @IBOutlet weak var highestEducationToDate: NSDatePicker!
    
    @IBOutlet weak var highestEducationBoardOrUniversity: NSTextField!
    
    @IBOutlet weak var highestEducationPercentage: NSTextField!
    
    @IBOutlet weak var educationGapDetails: NSTextField!
    
    
    @IBOutlet weak var jobChangeReasons: NSTextField!
    
    @IBOutlet weak var interviewedBeforeYes: NSButton!
    
    @IBOutlet weak var interviewdBeforeNo: NSButton!
    
    @IBOutlet weak var pastInterviedDate: NSDatePicker!
    
    
    @IBOutlet weak var leavePlanYes: NSButton!
    
    
    @IBOutlet weak var leavePlanNo: NSButton!
    
    
    @IBOutlet weak var leavePlanReasons: NSTextField!
    
    @IBOutlet weak var backgroundCheckYes: NSButton!
    
    @IBOutlet weak var backgroundCheckNo: NSButton!
    
    @IBOutlet weak var allDocumentsYes: NSButton!
    
    
    @IBOutlet weak var allDocumentsNo: NSButton!
    
    @IBOutlet weak var missingDocuments: NSTextField!
    
    
    @IBOutlet weak var currentFixedSalary: NSTextField!
    
    @IBOutlet weak var currentSalaryVariable: NSTextField!
    
    @IBOutlet weak var expectedSalary: NSTextField!
    
    @IBOutlet weak var entitledBonusYes: NSButton!
    
    
    @IBOutlet weak var entitledBonusNo: NSButton!
    
    @IBOutlet weak var candidateNoticePeriod: NSTextField!
    
    
    @IBOutlet weak var candidateJoinngPeriod: NSTextField!
    
    @IBOutlet weak var anyLegalObligationsYes: NSButton!
    
    @IBOutlet weak var anyLegalObligationsNo: NSButton!
    
    @IBOutlet weak var legalObligationDetails: NSTextField!
    
    @IBOutlet var questionsAskedByCandidate: NSTextView!
    
    @IBOutlet weak var inetrviewedBy: NSTextField!
    
    @IBOutlet weak var dummyPleaseSpecify: NSTextField!
    
    @IBOutlet weak var dummySpecifyMissingDocuments: NSTextField!
    
    @IBOutlet weak var dummyLegalObligations: NSTextField!
    
    @IBOutlet weak var dummySpecifyLegalObligations: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    //MARK: IBActions
    
    
    @IBAction func saveCandidateDetails(sender: AnyObject) {
        
        if validations() {
            
            print(candidateName.stringValue)
        }else{
            
            showAlert("Some fileds are missing", info:"Please fill up all the required fileds")
            
            print("Showing Alert")
            
        }
    }
    
    @IBAction func passportAvailability(sender:NSButton) {
        
        
        
        if sender.tag == 0{
            
            performCheckAndUncheck(passportYes, unCheck:passportNo)
            
        }else{
            
            performCheckAndUncheck(passportNo, unCheck:passportYes)
        }
        
        
    }
    
    @IBAction func relocationRequest(sender: NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(relocationYes, unCheck:relocationNo)
            
        }else{
            
            performCheckAndUncheck(relocationNo, unCheck:relocationYes)
            
        }
        
    }
    
    @IBAction func backgroundCheck(sender:NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(backgroundCheckYes, unCheck:backgroundCheckNo)
            
        }else{
            
            performCheckAndUncheck(backgroundCheckNo, unCheck:backgroundCheckYes)
        }
    }
    
    @IBAction func entitledBonus(sender:NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(entitledBonusYes, unCheck:entitledBonusNo)
            
        }else{
            
            performCheckAndUncheck(entitledBonusNo, unCheck:entitledBonusYes)
        }
        
        
    }
    
    
    @IBAction func interviewedBefore(sender: NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(interviewedBeforeYes, unCheck:interviewdBeforeNo)
            
            pastInterviedDate.hidden = false
            
            
        }else{
            
            performCheckAndUncheck(interviewdBeforeNo, unCheck:interviewedBeforeYes)
            
            pastInterviedDate.hidden = true
        }
        
    }
    
    
    
    @IBAction func leavePlan(sender:NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(leavePlanYes, unCheck:leavePlanNo)
            
            leavePlanReasons.hidden = false
            
            dummyPleaseSpecify.hidden = false
            
        }else{
            
            performCheckAndUncheck(leavePlanNo, unCheck:leavePlanYes)
            
            leavePlanReasons.hidden = true
            
            dummyPleaseSpecify.hidden = true
        }
        
    }
    
    
    
    @IBAction func allDocumentsExist(sender: NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(allDocumentsYes, unCheck:allDocumentsNo)
            
            allDocumentsYes.hidden = false
            
            dummySpecifyMissingDocuments.hidden = false
            
            missingDocuments.hidden = false
            
        }else{
            
            performCheckAndUncheck(allDocumentsNo, unCheck:allDocumentsYes)
            
            dummySpecifyMissingDocuments.hidden = true
            
            missingDocuments.hidden = true
        }
    }
    
    
    
    @IBAction func legalObligations(sender:NSButton) {
        
        if sender.tag == 0{
            
            performCheckAndUncheck(anyLegalObligationsYes, unCheck:anyLegalObligationsNo)
            
            legalObligationDetails.hidden = false
            
            dummyLegalObligations.hidden = false
            
            dummySpecifyLegalObligations.hidden = false
            
            
        }else{
            
            performCheckAndUncheck(anyLegalObligationsNo, unCheck:anyLegalObligationsYes)
            
            legalObligationDetails.hidden = true
            
            dummyLegalObligations.hidden = true
            
            dummySpecifyLegalObligations.hidden = true
        }
        
    }
    
    
    //MARK: HR Form Validations
    
    func validations()->Bool{
        
        var result:Bool = true
        
        if candidateName.stringValue == ""
        {
            
            setBoarderColor(candidateName)
            
            result = false
        }
        if companyName.stringValue == ""
        {
            
            setBoarderColor(companyName)
            
            result = false
        }
        if candidateBusinessUnit.stringValue == ""
        {
            
            setBoarderColor(candidateBusinessUnit)
            
            result = false
            
        }
        if currentDesignation.stringValue == ""
        {
            
            setBoarderColor(currentDesignation)
            
            result = false
            
        }
        
        if candidateSkillOrTechnology.stringValue == ""
        {
            
            setBoarderColor(candidateSkillOrTechnology)
            
            result = false
            
        }
        if currentJobType.stringValue == ""{
            
            setBoarderColor(currentJobType)
            
            result = false
            
        }
        if candidateTotalItExperience.stringValue == ""
            
        {
            
            setBoarderColor(candidateTotalItExperience)
            
            result = false
            
        }
        
        if candidateRelevantItExperience.stringValue == ""
        {
            
            setBoarderColor(candidateRelevantItExperience)
            
            result = false
            
        }
        if candidateMobile.stringValue == ""
        {
            
            setBoarderColor(candidateMobile)
            
            result = false
            
        }
        if officialMailid.stringValue == ""
        {
            
            setBoarderColor(officialMailid)
            
            result = false
            
        }
        
        if candidateCurrentLocation.stringValue == ""
        {
            
            setBoarderColor(candidateCurrentLocation)
            
            result = false
            
        }
        if passportYes.intValue == 1
        {
            
            if visaTypeAndValidity.stringValue == ""
                
            {
                setBoarderColor(visaTypeAndValidity)
                
                result = false
                
            }
            
            
            
        }
        
        if previousEmployerName.stringValue == ""
        {
            
            setBoarderColor(previousEmployerName)
            
            result = false
            
        }
        
        if highestEducationQualificationTitle.stringValue == ""
            
        {
            setBoarderColor(highestEducationQualificationTitle)
            
            result = false
            
        }
        
        if highestEducationBoardOrUniversity.stringValue == ""
        {
            setBoarderColor(highestEducationBoardOrUniversity)
            
            result = false
        }
        if highestEducationPercentage.stringValue == ""
        {
            setBoarderColor(highestEducationPercentage)
            
            result = false
            
        }
        if jobChangeReasons.stringValue == ""
        {
            setBoarderColor(jobChangeReasons)
            
            result = false
            
        }
        if candidateNoticePeriod.stringValue == ""
        {
            setBoarderColor(candidateNoticePeriod)
            
            result = false
            
            
        }
        if candidateJoinngPeriod.stringValue == ""
        {
            setBoarderColor(candidateJoinngPeriod)
            
            result = false
            
        }
        if inetrviewedBy.stringValue == ""
        {
            
            setBoarderColor(inetrviewedBy)
            
            result = false
        }
        if allDocumentsYes.intValue == 1 {
            
            if missingDocuments.stringValue == ""
            {
                setBoarderColor(missingDocuments)
                
                result = false
                
            }
            
            
        }
        
        if leavePlanYes.intValue == 1{
            
            if leavePlanReasons.stringValue == ""
            {
                
                setBoarderColor(leavePlanReasons)
                
                result = false
            }
            
            
        }
        
        if anyLegalObligationsYes.intValue == 1{
            
            if  legalObligationDetails.stringValue == ""
            {
                
                setBoarderColor(legalObligationDetails)
                
                result = false
            }
            
        }
        
        if result{
            
            return true
        }
        
        return result
    }
    
    
    
    func setBoarderColor(hrTextFiled:NSTextField){
        
        hrTextFiled.wantsLayer = true
        
        hrTextFiled.layer?.borderColor = NSColor.orangeColor().CGColor
        
        hrTextFiled.layer?.borderWidth = 2.0
        
        
    }
    
    func setClearColor(hrTextFiled:NSTextField){
        
        hrTextFiled.wantsLayer = false
        
        hrTextFiled.layer?.borderColor = NSColor.clearColor().CGColor
        
        hrTextFiled.layer?.borderWidth = 0
        
    }
    
    
    func showAlert(mes:String,info:String){
        
        let alert:NSAlert = NSAlert()
        
        alert.messageText = mes
        
        alert.informativeText = info
        
        alert.addButtonWithTitle("OK")
        
        alert.runModal()
    }
    
    func performCheckAndUncheck(check:NSButton,unCheck:NSButton){
        
        switch check.tag{
            
        case 0 :
            
            unCheck.integerValue = 0
            
            check.integerValue = 1
            
            
        case 1 :
            
            check.integerValue = 1
            
            unCheck.integerValue = 0
            
            
        default:
            
            print("Never")
            
        }
        
    }

    
    
}
