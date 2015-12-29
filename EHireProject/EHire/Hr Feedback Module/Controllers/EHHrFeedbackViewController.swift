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
    @IBOutlet weak var employmentGap: NSTextField!
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
    
    @IBOutlet weak var lastDesignation: NSTextField!
    
    
    
    var candidateInfo:Dictionary<String,AnyObject> = [:]
    var candidate:Candidate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        candidateInfo["isVisaAvailable"] = NSNumber(int:0)
        candidateInfo["isRelocationRequested"] = NSNumber(int:0)
        candidateInfo["isInterviewedBefore"] = NSNumber(int:0)
        candidateInfo["isAnyLeavePlans"] = NSNumber(int:0)
        candidateInfo["backgroundCheck"] = NSNumber(int:0)
        candidateInfo["isAnyDocumentMissing"] = NSNumber(int:0)
        candidateInfo["entitledBonus"] = NSNumber(int:0)
        candidateInfo["anyLegalObligations"] = NSNumber(int:0)
    }

    //MARK: IBActions.
    @IBAction func saveCandidateDetails(sender: AnyObject) {
        
        if validations() {
            candidateInfo["candidateName"] = candidateName.stringValue
            candidateInfo["candidateBusinessUnit"] = candidateBusinessUnit.stringValue
            candidateInfo["candidateSkillOrTechnology"] = candidateSkillOrTechnology.stringValue
            candidateInfo["candidateTotalItExperience"] = candidateTotalItExperience.stringValue
            candidateInfo["candidateRelevantItExperience"] = candidateRelevantItExperience.stringValue
            candidateInfo["candidateMobile"] = candidateMobile.stringValue
            candidateInfo["candidateCurrentLocation"] = candidateCurrentLocation.stringValue
            candidateInfo["companyName"] = companyName.stringValue
            candidateInfo["currentDesignation"] = currentDesignation.stringValue
            candidateInfo["currentJobType"] = currentJobType.stringValue
            candidateInfo["officialMailid"] = officialMailid.stringValue
            candidateInfo["visaTypeAndValidity"] = visaTypeAndValidity.stringValue
            candidateInfo["previousEmployerName"] = previousEmployerName.stringValue
            candidateInfo["previousEmployerFromDate"] = previousEmployerFromDate.dateValue
            candidateInfo["previousEmployerToDate"] = previousEmployerToDate.dateValue
            candidateInfo["highestEducationQualificationTitle"] = highestEducationQualificationTitle.stringValue
            candidateInfo["highestEducationFromDate"] = highestEducationFromDate.stringValue
            candidateInfo["highestEducationToDate"] = highestEducationToDate.stringValue
            candidateInfo["highestEducationBoardOrUniversity"] = highestEducationBoardOrUniversity.stringValue
            candidateInfo["highestEducationPercentage"] = highestEducationPercentage.stringValue
            candidateInfo["educationGapDetails"] = educationGapDetails.stringValue
            candidateInfo["jobChangeReasons"] = jobChangeReasons.stringValue
            if interviewedBeforeYes.integerValue == 1
            {
                candidateInfo["pastInterviewdDate"] = pastInterviedDate.dateValue
                
            }
            candidateInfo["jobChangeReasons"] = jobChangeReasons.stringValue
            candidateInfo["missingDocuments"] = missingDocuments.stringValue
            candidateInfo["currentFixedSalary"] = currentFixedSalary.stringValue
            candidateInfo["currentSalaryVariable"] = currentSalaryVariable.stringValue
            candidateInfo["expectedSalary"] = currentFixedSalary.stringValue
            candidateInfo["LegalObligations"] = legalObligationDetails.stringValue
            candidateInfo["candidateNoticePeriod"] = candidateNoticePeriod.stringValue
            candidateInfo["candidateJoinngPeriod"] = candidateJoinngPeriod.stringValue
            candidateInfo["questionsAskedByCandidate"] = questionsAskedByCandidate.string
            candidateInfo["inetrviewedBy"] = inetrviewedBy.stringValue
            candidateInfo["EmploymentGap"] = employmentGap.stringValue
            candidateInfo["lastDesignation"] = lastDesignation.stringValue
            //CoreData Candidate Object Comes here from Selected Candidate (Future Reference)
            
            //Dummy Candidate Object for Code Developing
            
            candidate = Candidate(entity:EHCoreDataHelper.createEntity("Candidate",managedObjectContext: AppDelegate.getAppdelegate().managedObjectContext)!, insertIntoManagedObjectContext:AppDelegate.getAppdelegate().managedObjectContext)
            
            
            HrFeedbackDataAccess.saveHrFeedbackOfCandidate(candidate!,candidateInfo: candidateInfo)

            
           }
           else
        {
            showAlert("Some fileds are missing", info:"Please fill up all the required fileds")
         
        }
       
    }
    
    @IBAction func passportAvailability(sender:NSButton)
        
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(passportYes, unCheck:passportNo)
            candidateInfo["isVisaAvailable"] = 1
        }
        else
        {
            performCheckAndUncheck(passportNo, unCheck:passportYes)
            candidateInfo["isVisaAvailable"] = 0
        }
    }
    
    @IBAction func relocationRequest(sender: NSButton)
        
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(relocationYes, unCheck:relocationNo)
            candidateInfo["isRelocationRequested"] = 1
        }
        else
        {
            performCheckAndUncheck(relocationNo, unCheck:relocationYes)
            candidateInfo["isRelocationRequested"] = 0
        }
    }
    
    @IBAction func backgroundCheck(sender:NSButton)
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(backgroundCheckYes, unCheck:backgroundCheckNo)
            candidateInfo["backgroundCheck"] = 1
        }
        else
        {
            performCheckAndUncheck(backgroundCheckNo, unCheck:backgroundCheckYes)
            candidateInfo["backgroundCheck"] = 0
        }
    }
    
    @IBAction func entitledBonus(sender:NSButton)
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(entitledBonusYes, unCheck:entitledBonusNo)
            candidateInfo["entitledBonus"] = 1
        }
        else
        {
            performCheckAndUncheck(entitledBonusNo, unCheck:entitledBonusYes)
            candidateInfo["entitledBonus"] = 0
        }
    }
    
    
    @IBAction func interviewedBefore(sender: NSButton)
        
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(interviewedBeforeYes, unCheck:interviewdBeforeNo)
            pastInterviedDate.hidden = false
            candidateInfo["isInterviewedBefore"] = 1
        }
        else
        {
            performCheckAndUncheck(interviewdBeforeNo, unCheck:interviewedBeforeYes)
            pastInterviedDate.hidden = true
            candidateInfo["isInterviewedBefore"] = 0
        }
    }
    
    @IBAction func leavePlan(sender:NSButton)
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(leavePlanYes, unCheck:leavePlanNo)
            leavePlanReasons.hidden = false
            dummyPleaseSpecify.hidden = false
            candidateInfo["isAnyLeavePlans"] = 1
        }
        else
        {
            performCheckAndUncheck(leavePlanNo, unCheck:leavePlanYes)
            leavePlanReasons.hidden = true
            dummyPleaseSpecify.hidden = true
            candidateInfo["isAnyLeavePlans"] = 0
        }
    }
    @IBAction func allDocumentsExist(sender: NSButton)
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(allDocumentsYes, unCheck:allDocumentsNo)
            allDocumentsYes.hidden = false
            dummySpecifyMissingDocuments.hidden = false
            missingDocuments.hidden = false
            candidateInfo["isAnyDocumentMissing"] = 1
        }else
        {
            performCheckAndUncheck(allDocumentsNo, unCheck:allDocumentsYes)
            dummySpecifyMissingDocuments.hidden = true
            missingDocuments.hidden = true
            candidateInfo["isAnyDocumentMissing"] = 0
        }
    }
    @IBAction func legalObligations(sender:NSButton)
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(anyLegalObligationsYes, unCheck:anyLegalObligationsNo)
            legalObligationDetails.hidden = false
            dummyLegalObligations.hidden = false
            dummySpecifyLegalObligations.hidden = false
            candidateInfo["anyLegalObligations"] = 1
        }else
        {
            performCheckAndUncheck(anyLegalObligationsNo, unCheck:anyLegalObligationsYes)
            legalObligationDetails.hidden = true
            dummyLegalObligations.hidden = true
            dummySpecifyLegalObligations.hidden = true
            candidateInfo["anyLegalObligations"] = 0
        }
    }
    
  //MARK: HR Form Validations
    
    func validations()->Bool
    {
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
        if currentJobType.stringValue == ""
        {
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
    
    func setBoarderColor(hrTextFiled:NSTextField)
    {
        hrTextFiled.wantsLayer = true
        hrTextFiled.layer?.borderColor = NSColor.orangeColor().CGColor
        hrTextFiled.layer?.borderWidth = 2.0
    }
    
    func setClearColor(hrTextFiled:NSTextField)
    {
        hrTextFiled.wantsLayer = false
        hrTextFiled.layer?.borderColor = NSColor.clearColor().CGColor
        hrTextFiled.layer?.borderWidth = 0
    }
    func showAlert(mes:String,info:String)
    {
        let alert:NSAlert = NSAlert()
        alert.messageText = mes
        alert.informativeText = info
        alert.addButtonWithTitle("OK")
        alert.runModal()
    }
    
    func performCheckAndUncheck(check:NSButton,unCheck:NSButton)
    {
        switch check.tag
        {
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
