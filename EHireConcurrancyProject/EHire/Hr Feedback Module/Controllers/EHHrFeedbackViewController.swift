//
//  EHHrFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

protocol HRFormScroller:class
{
    func scrollHrFormToPoint(point:NSPoint)
}

class EHHrFeedbackViewController: NSViewController,NSTextFieldDelegate,NSTextViewDelegate {

    //MARK: HR Feedback Form IBOutlets
    
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
    @IBOutlet weak var candidateJoinngPeriod: NSDatePicker!
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
    @IBOutlet weak var hrFeedbackView: NSView!
    
    dynamic var isHrFormEnable = true
    var candidateInfo:Dictionary<String,AnyObject> = [:]
    var candidate:Candidate?
    var managedObjectContext : NSManagedObjectContext?
    weak var delegate:HRFormScroller?
    var feedbackControl = EHFeedbackViewController()
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
              
        if candidate?.miscellaneousInfo?.isHrFormSubmitted == 1
        {
            isHrFormEnable = false
            feedbackControl.submitButton.enabled = false
        }
        else
        {
           feedbackControl.submitButton.enabled = true
           feedbackControl.clearButton.enabled = false
        }
        candidateInfo["isVisaAvailable"] = NSNumber(int:0)
        candidateInfo["isRelocationRequested"] = NSNumber(int:0)
        candidateInfo["isInterviewedBefore"] = NSNumber(int:0)
        candidateInfo["isAnyLeavePlans"] = NSNumber(int:0)
        candidateInfo["backgroundCheck"] = NSNumber(int:0)
        candidateInfo["isAnyDocumentMissing"] = NSNumber(int:0)
        candidateInfo["entitledBonus"] = NSNumber(int:0)
        candidateInfo["anyLegalObligations"] = NSNumber(int:0)
        candidateInfo["isHrFormSubmitted"]   = NSNumber(int:0)
        if candidate?.miscellaneousInfo?.isHrFormSaved == 1
        {
            feedbackControl.clearButton.enabled = false
        }
        
        self.candidateJoinngPeriod.dateValue = NSDate()
        
        self.candidateJoinngPeriod.minDate = NSDate()
        
        self.visaTypeAndValidity.enabled = false
        
        showDetailsOfCandidate()
    }
    
    //MARK: HR Feedback Form IBActions.
    
    @IBAction func saveCandidateDetails(sender: AnyObject) {
        if saveValidations()
        {
            saveCandidate()
        }
    }
    
    @IBAction func subbmitCandidateDetails(sender: AnyObject)
    {
        if self.submitValidations()
        {
            if numericValidations()
            {
                Utility.alertPopup("Are you sure want to \'Submit\' the details?", informativeText:"Once submitted you cannot edit feedback info.",isCancelBtnNeeded:true) { () -> Void in
                    
                    self.candidateInfo["isHrFormSubmitted"] = 1
                    self.isHrFormEnable = false
                    self.feedbackControl.submitButton.enabled = false
                    self.feedbackControl.clearButton.enabled = false
                    self.saveCandidateDetails("")
                }
            }
            
        }
        else
        {
            self.showAlert("More information needed", info:"Please fill up all the required fields")
        }
    }
    
    @IBAction func passportAvailability(sender:NSButton)
        
    {
        if sender.tag == 0
        {
            performCheckAndUncheck(passportYes, unCheck:passportNo)
            candidateInfo["isVisaAvailable"] = 1
            self.visaTypeAndValidity.enabled = true
        }
        else
        {
            performCheckAndUncheck(passportNo, unCheck:passportYes)
            candidateInfo["isVisaAvailable"] = 0
            self.visaTypeAndValidity.enabled = false
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
            candidateInfo["pastInterviewdDate"] = pastInterviedDate.dateValue
        }
        else
        {
            performCheckAndUncheck(interviewdBeforeNo, unCheck:interviewedBeforeYes)
            pastInterviedDate.hidden = true
            candidateInfo["isInterviewedBefore"] = 0
            candidateInfo["pastInterviewdDate"] = pastInterviedDate.dateValue
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
            leavePlanReasons.stringValue = ""
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
            missingDocuments.stringValue = ""
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
            legalObligationDetails.stringValue = ""
            dummyLegalObligations.hidden = true
            dummySpecifyLegalObligations.hidden = true
            candidateInfo["anyLegalObligations"] = 0
        }
    }
    
    //MARK: HR Feedback Form Validations
    
    func submitValidations()->Bool
    {
        var result:Bool = true
        if candidateName.stringValue == ""
        {
            setBoarderColor(candidateName)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if companyName.stringValue == ""
        {
            setBoarderColor(companyName)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if candidateBusinessUnit.stringValue == ""
        {
            setBoarderColor(candidateBusinessUnit)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if currentDesignation.stringValue == ""
        {
            setBoarderColor(currentDesignation)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if candidateSkillOrTechnology.stringValue == ""
        {
            setBoarderColor(candidateSkillOrTechnology)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if currentJobType.stringValue == ""
        {
            setBoarderColor(currentJobType)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if candidateTotalItExperience.stringValue == ""
        {
            setBoarderColor(candidateTotalItExperience)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if candidateRelevantItExperience.stringValue == ""
        {
            setBoarderColor(candidateRelevantItExperience)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if candidateMobile.stringValue == ""
        {
            setBoarderColor(candidateMobile)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if officialMailid.stringValue == ""
        {
            setBoarderColor(officialMailid)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if candidateCurrentLocation.stringValue == ""
        {
            setBoarderColor(candidateCurrentLocation)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if passportYes.intValue == 1
        {
            if visaTypeAndValidity.stringValue == ""
            {
                setBoarderColor(visaTypeAndValidity)
                scrollToTextField(NSPoint(x:0, y:1081))
                result = false
            }
        }
        if previousEmployerName.stringValue == ""
        {
            setBoarderColor(previousEmployerName)
            scrollToTextField(NSPoint(x:0, y:1081))
            result = false
        }
        if highestEducationQualificationTitle.stringValue == ""
        {
            setBoarderColor(highestEducationQualificationTitle)
            scrollToTextField(NSPoint(x:0, y:750))
            result = false
        }
        if highestEducationBoardOrUniversity.stringValue == ""
        {
            setBoarderColor(highestEducationBoardOrUniversity)
            scrollToTextField(NSPoint(x:0, y:750))

            
            result = false
        }
        if highestEducationPercentage.stringValue == ""
        {
            setBoarderColor(highestEducationPercentage)
            scrollToTextField(NSPoint(x:0, y:750))
            result = false
        }
        if jobChangeReasons.stringValue == ""
        {
            setBoarderColor(jobChangeReasons)
            scrollToTextField(NSPoint(x:0, y:550))
            
            result = false
        }
        if leavePlanYes.intValue == 1{
            
            if leavePlanReasons.stringValue == ""
            {
                
                setBoarderColor(leavePlanReasons)
                scrollToTextField(NSPoint(x:0, y:350))
                
                result = false
            }
        }

        
        if allDocumentsYes.intValue == 1 {
            
            if missingDocuments.stringValue == ""
            {
                setBoarderColor(missingDocuments)
                scrollToTextField(NSPoint(x:0, y:0))
                
                result = false
            }
        }
        if currentFixedSalary.stringValue == ""
        {
            setBoarderColor(currentFixedSalary)
            scrollToTextField(NSPoint(x:0, y:0))
            result = false
        }
        
        if expectedSalary.stringValue == ""
        {
            setBoarderColor(expectedSalary)
            scrollToTextField(NSPoint(x:0, y:0))
            result = false
        
        }
        if anyLegalObligationsYes.intValue == 1{
            
            if  legalObligationDetails.stringValue == ""
            {
                
                setBoarderColor(legalObligationDetails)
                scrollToTextField(NSPoint(x:0, y:0))
                
                result = false
            }
        }
        if candidateNoticePeriod.stringValue == ""
        {
            setBoarderColor(candidateNoticePeriod)
             scrollToTextField(NSPoint(x:0, y:0))
            
            result = false
        }
       
        if inetrviewedBy.stringValue == ""
        {
            
            setBoarderColor(inetrviewedBy)
            scrollToTextField(NSPoint(x:0, y:0))
            
            result = false
        }
        if result{
            
            return true
        }
        
        return result
    }
    
    func numericValidations()->Bool
    {
        
        if EHOnlyDecimalValueFormatter.isNumberValid(self.candidateName.stringValue)
        {
            showAlert("Invalid candidate name", info:"candidate name must not be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.candidateName.becomeFirstResponder()
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.companyName.stringValue)
        {
            showAlert("Invalid company name", info:"company name must not be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.companyName.becomeFirstResponder()
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.candidateBusinessUnit.stringValue)
        {
            showAlert("Invalid business unit", info:"business unit must not be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.candidateBusinessUnit.becomeFirstResponder()
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.currentDesignation.stringValue)
        {
            showAlert("Invalid current designation", info:"designation must not be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.currentDesignation.becomeFirstResponder()
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.candidateSkillOrTechnology.stringValue)
        {
            showAlert("Invalid skill/technology", info:"skill/technology must not be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.candidateSkillOrTechnology.becomeFirstResponder()
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.currentJobType.stringValue)
        {
            showAlert("Invalid job type", info:"job type must not be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.currentJobType.becomeFirstResponder()
            return false
        }
        if !EHOnlyDecimalValueFormatter.isNumberValid(self.candidateTotalItExperience.stringValue)
        {
            showAlert("Invalid total IT experience", info:"total IT experience must be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.candidateTotalItExperience.becomeFirstResponder()
            return false
        }
        if !EHOnlyDecimalValueFormatter.isNumberValid(self.candidateRelevantItExperience.stringValue)
        {
            showAlert("Invalid relevant IT experience", info:"relevant IT experience must be a number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.candidateRelevantItExperience.becomeFirstResponder()
            return false
        }
        
        if !EHHrFeedbackViewController.isValidEmail(self.officialMailid.stringValue)
        {
            
            showAlert("Invalid email address ", info:"Please enter a proper email")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.officialMailid.becomeFirstResponder()
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.currentFixedSalary.stringValue) == false
        {
            showAlert("Invalid data entered", info:"Please enter Fixed Salary in numbers")
            scrollToTextField(NSPoint(x:0, y:300))
            setBoarderColor(self.currentFixedSalary)
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.currentSalaryVariable.stringValue) == false
        {
            showAlert("Invalid data entered", info:"Please enter Variable Salary in numbers")
            setBoarderColor(self.currentSalaryVariable)
            scrollToTextField(NSPoint(x:0, y:300))
            setClearColor(self.currentFixedSalary)
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.expectedSalary.stringValue) == false
        {
            showAlert("Invalid data entered", info:"Please enter Expected Salary in numbers")
            setBoarderColor(self.expectedSalary)
            scrollToTextField(NSPoint(x:0, y:300))
            setClearColor(self.currentSalaryVariable)
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.highestEducationPercentage.stringValue) == false
        {
            showAlert("Invalid data entered", info:"Please enter percentage in numbers")
            setBoarderColor(self.highestEducationPercentage)
            scrollToTextField(NSPoint(x:0, y:750))
            setClearColor(self.currentSalaryVariable)
            return false
        }
        if EHOnlyDecimalValueFormatter.isNumberValid(self.candidateMobile.stringValue) == false
        {
            showAlert("Invalid Mobile Number", info: "Please enter a proper mobile number")
            scrollToTextField(NSPoint(x:0, y:1081))
            self.candidateMobile.becomeFirstResponder()
            
            return false
        }else
        {
            if self.candidateMobile.stringValue.characters.count < 10
            {
                
                showAlert("Invalid Mobile Number", info:"Your mobile number must be atleast 10 digits long")
                scrollToTextField(NSPoint(x:0, y:1081))
                self.candidateMobile.becomeFirstResponder()
                return false
                
            }
            
            
        }
       if !EHOnlyDecimalValueFormatter.isNumberValid(candidateNoticePeriod.stringValue)
       {
           showAlert("Invalid official notice period", info:"official notice period must ba a number")
           scrollToTextField(NSPoint(x:0, y:200))
           candidateNoticePeriod.becomeFirstResponder()
        
        return false
        }
        return true
        
    }
    
    func setBoarderColor(hrTextFiled:NSTextField)
    {
        hrTextFiled.wantsLayer = true
        hrTextFiled.layer?.borderColor =  NSColor(calibratedRed:110.0/250.0, green:157.0/250.0, blue:215.0/250.0, alpha:1.0).CGColor
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
    
    func showDetailsOfCandidate()
    {
        
        self.candidateName.stringValue = (candidate?.name)!
        self.candidateMobile.stringValue = (candidate?.phoneNumber)!
        self.candidateSkillOrTechnology.stringValue = (candidate?.technologyName)!
        if let professionalInfo = candidate?.professionalInfo
        {
            let info = professionalInfo as! CandidateBasicProfessionalInfo
            self.companyName.stringValue = info.companyName!
            self.currentDesignation.stringValue = info.currentDesignation!
            self.currentJobType.stringValue = info.currentJobType!
            self.officialMailid.stringValue = info.officialEmailId!
            self.employmentGap.stringValue = info.employmentGap!
            self.candidateNoticePeriod.stringValue = info.officialNoticePeriod!
            self.candidateRelevantItExperience.stringValue = String(info.relevantITExperience!)
            self.candidateTotalItExperience.stringValue = String(info.totalITExperience!)
            self.currentFixedSalary.stringValue = String(info.fixedSalary!)
            self.currentSalaryVariable.stringValue = String(info.variableSalary!)
        }
        
        if let personalInfo = candidate?.personalInfo
        {
            let info = personalInfo as! CandidatePersonalInfo
            
            self.candidateCurrentLocation.stringValue = info.currentLocation!
            self.visaTypeAndValidity.stringValue = info.visaTypeAndValidity!
            if info.passport == 1
            {
                self.passportYes.integerValue = 1
                self.passportNo.integerValue = 0
            }
            else
            {
                self.passportNo.integerValue = 1
                self.passportYes.integerValue = 0
            }
        }
        
        if let pastEmploymentInfo = candidate?.previousEmployment
        {
            let info = pastEmploymentInfo as! CandidatePreviousEmploymentInfo
            
            self.previousEmployerName.stringValue = info.previousCompany!
            self.previousEmployerFromDate.dateValue = info.employmentStartsFrom!
            self.previousEmployerToDate.dateValue = info.employmentEnd!
            self.lastDesignation.stringValue = info.previousCompanyDesignation!
            print(info.previousCompanyDesignation!)
        }
        
        if let educationInfo = candidate?.educationQualification
        {
            let info = educationInfo
            
            self.highestEducationQualificationTitle.stringValue = info.highestEducation!
            self.highestEducationFromDate.dateValue = info.educationStartFrom!
            self.highestEducationToDate.dateValue = info.educationEnd!
            self.educationGapDetails.stringValue = info.educationGap!
            self.highestEducationPercentage.stringValue = String(info.percentage!)
            self.highestEducationBoardOrUniversity.stringValue = info.university!
        }
        if let documentInfo = candidate?.documentDetails
        {
            let info = documentInfo
            
            self.missingDocuments.stringValue = info.missingDocumentsOfEmploymentAndEducation!
            
            if info.documentsOfEmploymentAndEducationPresent == 1
            {
                
                self.allDocumentsYes.integerValue = 1
                self.allDocumentsNo.integerValue = 0
                dummySpecifyMissingDocuments.hidden = false
                missingDocuments.hidden = false
                
                self.missingDocuments.stringValue = info.missingDocumentsOfEmploymentAndEducation!
            }
            else
            {
                self.allDocumentsYes.integerValue = 0
                self.allDocumentsNo.integerValue = 1
            }
        }
        
        if let otherInfo = candidate?.miscellaneousInfo
        {
            let info = otherInfo
            self.candidateBusinessUnit.stringValue = info.businessUnit!
            self.leavePlanReasons.stringValue = info.leavePlanInSixMonths!
            self.jobChangeReasons.stringValue = info.reasonForJobChange!
            self.candidateJoinngPeriod.dateValue = info.joiningPeriod!
            self.inetrviewedBy.stringValue = info.interviewedBy!
            self.expectedSalary.stringValue = String(info.expectedSalary!)
            self.questionsAskedByCandidate.string = info.questionsByCandidate!
            
            if info.candidateRequestForRelocation == 1
            {
                self.relocationYes.integerValue = 1
                self.relocationNo.integerValue = 0
            }
            else
            {
                self.relocationYes.integerValue = 0
                self.relocationNo.integerValue = 1
            }
            
            if info.backgroundVerification == 1
            {
                self.backgroundCheckYes.integerValue = 1
                self.backgroundCheckNo.integerValue = 0
            }
            else
            {
                self.backgroundCheckYes.integerValue = 0
                self.backgroundCheckNo.integerValue = 1
            }
            
            if info.wasInterviewedBefore == 1
            {
                self.interviewedBeforeYes.integerValue = 1
                self.interviewdBeforeNo.integerValue = 0
                pastInterviedDate.hidden = false
                pastInterviedDate.dateValue = info.wasInterviewdBeforeOn!
            }
            else
            {
                self.interviewedBeforeYes.integerValue = 0
                self.interviewdBeforeNo.integerValue = 1
                pastInterviedDate.hidden = true
            }
            
            if info.anyLeavePlanInSixMonths == 1
            {
                self.leavePlanYes.integerValue = 1
                self.leavePlanNo.integerValue = 0
                self.leavePlanReasons.hidden = false
                self.leavePlanReasons.stringValue = info.leavePlanInSixMonths!
                self.dummyPleaseSpecify.hidden = false
                
            }
            else
            {
                self.leavePlanYes.integerValue = 0
                self.leavePlanNo.integerValue = 1
                
            }
            
            if info.anyLegalObligationWithCurrentEmployer == 1
            {
                self.anyLegalObligationsYes.integerValue = 1
                self.anyLegalObligationsNo.integerValue = 0
                legalObligationDetails.hidden = false
                dummyLegalObligations.hidden = false
                dummySpecifyLegalObligations.hidden = false
            }
            else
            {
                self.anyLegalObligationsYes.integerValue = 0
                self.anyLegalObligationsNo.integerValue = 1
            }
            
            if info.anyPendingBonusFromCurrentEmployer == "1"
            {
                self.entitledBonusYes.integerValue = 1
                self.entitledBonusNo.integerValue = 0
            }
            else
            {
                self.entitledBonusYes.integerValue = 0
                self.entitledBonusNo.integerValue = 1
                
            }
        }
    }
    
    func saveValidations()->Bool
    {
        if self.currentFixedSalary.stringValue != ""
        {
            if !EHOnlyDecimalValueFormatter.isNumberValid(self.currentFixedSalary.stringValue){
                showAlert("Invalid data entered", info:"Please enter Fixed Salary in numbers")
                setBoarderColor(self.currentFixedSalary)
                return false
            }
        }
        if self.currentSalaryVariable.stringValue != ""
        {
            if !EHOnlyDecimalValueFormatter.isNumberValid(self.currentSalaryVariable.stringValue){
                showAlert("Invalid data entered", info:"Please enter Fixed Salary in numbers")
                setBoarderColor(self.currentSalaryVariable)
                return false
            }
        }
        
        if self.expectedSalary.stringValue != ""
        {
            if !EHOnlyDecimalValueFormatter.isNumberValid(self.expectedSalary.stringValue){
                showAlert("Invalid data entered", info:"Please enter Fixed Salary in numbers")
                setBoarderColor(self.expectedSalary)
                return false
            }
        }
        
        
        return true
    }
    
    //MARK: Saving Candidate details
    
    func saveCandidate()
    {
        candidateInfo["candidateName"] = candidateName.stringValue
        candidateInfo["candidateBusinessUnit"] = candidateBusinessUnit.stringValue
        candidateInfo["candidateSkillOrTechnology"] = candidateSkillOrTechnology.stringValue
        candidateInfo["candidateTotalItExperience"] = candidateTotalItExperience.floatValue
        candidateInfo["candidateRelevantItExperience"] = candidateRelevantItExperience.floatValue
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
        candidateInfo["highestEducationFromDate"] = highestEducationFromDate.dateValue
        candidateInfo["highestEducationToDate"] = highestEducationToDate.dateValue
        candidateInfo["highestEducationBoardOrUniversity"] = highestEducationBoardOrUniversity.stringValue
        candidateInfo["highestEducationPercentage"] = highestEducationPercentage.floatValue
        candidateInfo["educationGapDetails"] = educationGapDetails.stringValue
        candidateInfo["jobChangeReasons"] = jobChangeReasons.stringValue
        candidateInfo["pastInterviewdDate"] = pastInterviedDate.dateValue
        candidateInfo["jobChangeReasons"] = jobChangeReasons.stringValue
        candidateInfo["missingDocuments"] = missingDocuments.stringValue
        candidateInfo["currentFixedSalary"] = currentFixedSalary.floatValue
        candidateInfo["currentSalaryVariable"] = currentSalaryVariable.floatValue
        candidateInfo["expectedSalary"] = expectedSalary.floatValue
        candidateInfo["LegalObligations"] = legalObligationDetails.stringValue
        candidateInfo["candidateNoticePeriod"] = candidateNoticePeriod.stringValue
        candidateInfo["candidateJoinngPeriod"] = candidateJoinngPeriod.dateValue
        candidateInfo["questionsAskedByCandidate"] = questionsAskedByCandidate.string
        candidateInfo["inetrviewedBy"] = inetrviewedBy.stringValue
        candidateInfo["EmploymentGap"] = employmentGap.stringValue
        candidateInfo["lastDesignation"] = lastDesignation.stringValue
        candidateInfo["leavePlanReasons"] = leavePlanReasons.stringValue
        HrFeedbackDataAccess.saveHrFeedbackOfCandidate(candidate!, candidateInfo: candidateInfo) { (isSucess) -> Void in
            if isSucess{
                if self.isHrFormEnable
                {
                    self.showAlert("Feedback details saved succesfully", info:"")
                }
                else
                {
                    self.showAlert("Feedback details submitted succesfully", info:"")
                }
                
            }
        }
        
    }
    func textDidChange(notification: NSNotification)
    {
        if candidate?.miscellaneousInfo?.isHrFormSaved == 1
        {
            feedbackControl.clearButton.enabled = false
        }else
        {
            feedbackControl.clearButton.enabled = true
        }
        
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        
        if control is NSTextField
        {
            if candidate?.miscellaneousInfo?.isHrFormSaved == 1
            {
                feedbackControl.clearButton.enabled = false
            }else
            {
                feedbackControl.clearButton.enabled = true
            }
            
            let textField = control as! NSTextField
            setClearColor(textField)
        }
        return true
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluateWithObject(testStr)
        {
            return true
        }
        
        return false
    }
    
    @IBAction func clearAllFields(sender: AnyObject)
    {
        candidateName.stringValue = ""
        candidateBusinessUnit.stringValue = ""
        candidateSkillOrTechnology.stringValue = ""
        candidateTotalItExperience.stringValue = ""
        candidateMobile.stringValue = ""
        candidateCurrentLocation.stringValue = ""
        companyName.stringValue = ""
        employmentGap.stringValue = ""
        currentDesignation.stringValue = ""
        currentJobType.stringValue = ""
        candidateRelevantItExperience.stringValue = ""
        officialMailid.stringValue = ""
        visaTypeAndValidity.stringValue = ""
        previousEmployerName.stringValue = ""
        highestEducationQualificationTitle.stringValue = ""
        highestEducationBoardOrUniversity.stringValue = ""
        highestEducationPercentage.stringValue = ""
        educationGapDetails.stringValue = ""
        jobChangeReasons.stringValue = ""
        leavePlanReasons.stringValue = ""
        missingDocuments.stringValue = ""
        currentFixedSalary.stringValue = ""
        currentSalaryVariable.stringValue = ""
        expectedSalary.stringValue = ""
        candidateNoticePeriod.stringValue = ""
        candidateJoinngPeriod.stringValue = ""
        legalObligationDetails.stringValue = ""
        questionsAskedByCandidate.string = ""
        inetrviewedBy.stringValue = ""
        dummyPleaseSpecify.stringValue = ""
        dummySpecifyMissingDocuments.stringValue = ""
        dummyLegalObligations.stringValue = ""
        dummySpecifyLegalObligations.stringValue = ""
        lastDesignation.stringValue = ""
    }
    
    func scrollToTextField(point:NSPoint)
    {
        if let delegate = delegate
        {
            delegate.scrollHrFormToPoint(point)
        }
    }
    
}
