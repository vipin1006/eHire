//
//  ShowDetailsViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 02/03/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class ShowDetailsViewController: NSViewController {
    
    var candidate:Candidate?

    @IBOutlet var candidateName: NSTextField!
    
    @IBOutlet var currentCompany: NSTextField!
    
    @IBOutlet var currentDesignation: NSTextField!
    
    @IBOutlet var currentLocation: NSTextField!
    
    @IBOutlet var relocationRequest: NSTextField!
    
    @IBOutlet var noticePeriod: NSTextField!
    
    @IBOutlet var joiningPeriod: NSTextField!
    
    @IBOutlet var currentCtc: NSTextField!
    
    @IBOutlet var expectedCtc: NSTextField!
    
    @IBOutlet var reasonsForJobChange: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        self.view.layer?.backgroundColor = NSColor(calibratedRed:247/255.0, green: 246/255.0, blue: 247/255.0, alpha: 1.0).CGColor
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        let basicInfo = candidate?.professionalInfo as! CandidateBasicProfessionalInfo
        
        let personalInfo = candidate?.personalInfo as! CandidatePersonalInfo
        
        let emplyoymentInfo = candidate?.previousEmployment as! CandidatePreviousEmploymentInfo
       
        candidateName.stringValue = candidate!.name!
        
        currentCompany.stringValue = emplyoymentInfo.previousCompany!
        
        currentDesignation.stringValue = basicInfo.currentDesignation!
        
        currentLocation.stringValue = personalInfo.currentLocation!
        
       if let requested = candidate?.miscellaneousInfo?.candidateRequestForRelocation
       {
          if requested == 1
          {
            relocationRequest.stringValue = "Yes"
          }
          else
          {
            relocationRequest.stringValue = "No"
         }
      }
        
      noticePeriod.stringValue = basicInfo.officialNoticePeriod!
        
        joiningPeriod.stringValue = NSDateFormatter.localizedStringFromDate((candidate?.miscellaneousInfo?.joiningPeriod!)!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        
        if let expected =  candidate?.miscellaneousInfo?.expectedSalary
        {
            expectedCtc.integerValue = Int(expected)
        }
        
        if let current = basicInfo.fixedSalary
        {
            currentCtc.integerValue = Int(current)
        }
    
        reasonsForJobChange.stringValue = (candidate?.miscellaneousInfo?.reasonForJobChange!)!
  
        
        
        
    }
    
    @IBAction func cancelSheet(sender: AnyObject) {
        
        self.dismissViewController(self)
        
    }
}
