//
//  EHFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa
protocol FeedbackControllerDelegate
{
    func feedbackViewControllerDidFinish(selectedCandidate:Candidate)
}

class EHFeedbackViewController: NSViewController
{
    //MARK: IBOutlets
    @IBOutlet weak var typeOfInterview: NSSegmentedControl!
    @IBOutlet weak var subRound: NSSegmentedControl!
    @IBOutlet weak var scrollViewHr: NSScrollView!
    
    //MARK: Properties
    var delegate:FeedbackControllerDelegate?
    var hrView:NSView?
    var topObjects:NSArray?
    var isHrLoaded = false
    var isTechnicalLoaded  = false
    var isManagerLoaded = false
    var hrFeedBackViewController:EHHrFeedbackViewController?
    var managerFeedback : EHManagerFeedbackViewController?
    var techFeedback : EHTechnicalFeedbackViewController?
    var technicalFeedbackModel = EHTechnicalFeedbackModel()
    var selectedCandidate:Candidate?
    //var candidateObject:EHCandidateController?
    let dataAccess = TechnicalFeedbackDataAccess()
    
    //MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        techFeedback = storyboard?.instantiateControllerWithIdentifier("EHTechnicalFeedbackViewController") as? EHTechnicalFeedbackViewController
        techFeedback!.selectedCandidate = selectedCandidate
        self.scrollViewHr.documentView? = (techFeedback?.view)!
        self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1081))
        self.typeOfInterview.selectedSegment = 0
        self.subRound.selectedSegment = 0
        self.scrollViewHr.hasVerticalScroller = true
        self.scrollViewHr.hasHorizontalScroller = true
    }
    
    @IBAction func roundType(sender: AnyObject)
    {
        self.subRound.hidden = false
        let mainRound:NSSegmentedControl = sender as! NSSegmentedControl
        switch mainRound.selectedSegment
        {
        case 0 :
            if !isTechnicalLoaded
            {
                self.scrollViewHr.documentView? = (techFeedback?.view)!
                self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1081))
            }
            if isHrLoaded
            {
                self.hrView?.removeFromSuperview()
            }
            if isManagerLoaded
            {
                self.managerFeedback?.view.removeFromSuperview()
            }
            self.subRound.segmentCount = 3
            self.subRound.setWidth(200, forSegment: 2)
            self.subRound.setWidth(200, forSegment: 0)
            self.subRound.setWidth(200, forSegment: 1)
            self.subRound.setLabel("Round 3", forSegment:2)
            isHrLoaded = false
            
        case 1:
            let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
            if techLeadCount == 0
            {
                Utility.alertPopup("Alert", informativeText: "Technical round is not yet Completed", okCompletionHandler: nil)
                subRound.selectedSegment = 0
                typeOfInterview.setSelected(true, forSegment: 0)
                return
            }

            if !isManagerLoaded
            {
                managerFeedback = storyboard?.instantiateControllerWithIdentifier("EHManagerFeedbackViewController") as? EHManagerFeedbackViewController
                managerFeedback?.selectedCandidate = selectedCandidate
                self.scrollViewHr.documentView = managerFeedback?.view
                self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1565))
            }
            self.hrView?.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            self.subRound.segmentCount = 2
            self.subRound.selectedSegment = 0
            self.subRound.setWidth(300, forSegment: 0)
            self.subRound.setWidth(300, forSegment: 1)
            isHrLoaded = false
            
        case 2:
            if !isHrLoaded
            {
               self.addHrFeedBackView()
            }
            self.managerFeedback?.view.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            self.subRound.hidden = true
        default:
            print("Other")
        }
    }
    
    @IBAction func subRound(sender: AnyObject)
    {
        switch self.typeOfInterview.selectedSegment
        {
        //For Technical Feedback Rounds
                case 0:
            switch self.subRound.selectedSegment
            {
            case 0:
                print("Round One")
                if selectedCandidate?.interviewedByTechLeads?.count != 0
                {
                    let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                    techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                }

            case 1:
                
                print("Round Two")
                let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
                switch techLeadCount
                {
                case 0:
                       Utility.alertPopup("Alert", informativeText: "Round One not yet Completed", okCompletionHandler: nil)
                       subRound.selectedSegment = 0
                case 1:
                      for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
                     {
                        let feedback = feedbackOfTechLead as! TechnicalFeedBack
                        if feedback.recommendation == "Rejected"
                        {
                            Utility.alertPopup("Candidate Rejected", informativeText: "Selected Candidate Rejected in Round One",okCompletionHandler: nil)
                            subRound.selectedSegment = 0
                        }
                        else
                        {
                            techFeedback?.refreshAllFields()
                        }
                      break
                     }
                  default:
                        if selectedCandidate?.interviewedByTechLeads?.count > self.subRound.selectedSegment
                        {
                            let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                            techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                        }
                     }
            case 2:
                
                print("Round Three")
                let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
                switch techLeadCount
                {
                case 0:
                    
                    Utility.alertPopup("Alert", informativeText: "RoundOne not yet Completed", okCompletionHandler: nil)
                    subRound.selectedSegment = 0
                    
                    
                case 1:
                    for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
                    {
                        let feedback = feedbackOfTechLead as! TechnicalFeedBack
                        if subRound.selectedSegment == 1
                        {
                            if feedback.recommendation == "Rejected"
                            {
                                Utility.alertPopup("Candidate Rejected", informativeText: "Selected Candidate Rejected in Round Two", okCompletionHandler: nil)
                                subRound.selectedSegment = 0
                            }
                        }
                        else if selectedCandidate?.interviewedByTechLeads!.count == 1
                        {
                            Utility.alertPopup("Alert", informativeText: "Round Two not yet Completed", okCompletionHandler: nil)
                            subRound.selectedSegment = 1
                        }
                        else
                        {
                            techFeedback?.refreshAllFields()
                        }
                        break
                        
                    }
    
                case 2:
                    
                    for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
                    {
                        let feedback = feedbackOfTechLead as! TechnicalFeedBack
                      
                    if feedback.recommendation == "Selected"
                    {
                        techFeedback?.refreshAllFields()
                    }
                    if feedback.recommendation == "Rejected"
                    {
                                Utility.alertPopup("Candidate Rejected", informativeText: "Selected Candidate Rejected in Round Two", okCompletionHandler: nil)
                                subRound.selectedSegment = 1
                    }
                        
                    
                    
                    
                    }
                    
                default:
                    if selectedCandidate?.interviewedByTechLeads?.count > 2
                    {
                    let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                    techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                    }
                }
            default: print("")
        }
            
        case 1: // for managerial feedback sub rounds
        switch self.subRound.selectedSegment
        {
            case 0:
                print("Round One")
                if selectedCandidate?.interviewedByManagers?.count != 0
                {
                    let allObjects = selectedCandidate?.interviewedByManagers?.allObjects
                    managerFeedback?.sortArray(allObjects!, index:self.subRound.selectedSegment)
                }
  
            case 1:

                print (self.subRound.selectedSegment)

                 let managerFeedbackCount = (selectedCandidate?.interviewedByManagers)!.count
                switch managerFeedbackCount
                {
                case 0:
                    managerFeedback?.alertPopup("Alert", informativeText: "Round One not yet Completed")
                    
                case 1:
                    for feedbackOfManager in (selectedCandidate?.interviewedByManagers)!
                    {
                        let feedback = feedbackOfManager as! ManagerFeedBack
                        
                        if feedback.recommendation == "Rejected"
                        {
                            managerFeedback?.alertPopup("Candidate Rejected", informativeText: "Selected Candidate Rejected in Round One")
                            subRound.selectedSegment = 0
                        }
                        else if managerFeedback?.selectedCandidate?.interviewedByManagers?.count > self.subRound.selectedSegment{
                            
                            let candidateObjects = selectedCandidate?.interviewedByManagers?.allObjects
                            managerFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                        }
                        else
                        {
                            managerFeedback?.refreshAllFields()
                            
                        }
                        
                    }
                case 2:
                    
                    let candidateObjects = selectedCandidate?.interviewedByManagers?.allObjects
                    managerFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                    
                default: print("")

               
                                }
                print("Round Two")
                
            default: print("")
            }
         default: print("")
        }
    }
    
    func addHrFeedBackView()
    {
        hrFeedBackViewController = self.storyboard?.instantiateControllerWithIdentifier("EHHrFeedbackViewController") as? EHHrFeedbackViewController
        
        hrFeedBackViewController?.candidate = selectedCandidate
        if let hrViewController = hrFeedBackViewController
        {
            hrView = hrViewController.view
            hrView!.frame = NSMakeRect(self.scrollViewHr.frame.origin.x,self.scrollViewHr.frame.origin.y,self.scrollViewHr.frame.size.width,1450)
            self.scrollViewHr.documentView = hrView
            self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1200))
            isHrLoaded = true
        }
    }
    
    @IBAction func dismissFeedbackView(sender: AnyObject)
    {
//        candidateObject = EHCandidateController()
//        candidateObject?.feedbackButton!.enabled = false
//        candidateObject?.removeButton!.enabled = false

        self.view.removeFromSuperview()
        NSApp.windows.first?.title = "List of Candidates"
        self.delegate?.feedbackViewControllerDidFinish(selectedCandidate!)
        
    }
    
    func createConstraintsForManagerFeedbackController(leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat)
    {
        managerFeedback!.view.translatesAutoresizingMaskIntoConstraints = false
        let xLeadingSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: .Leading, relatedBy: .Equal, toItem:self.scrollViewHr, attribute: .Leading, multiplier: 1, constant: leading)
        let xTrailingSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: .Trailing, relatedBy: .Equal, toItem: self.scrollViewHr, attribute: .Trailing, multiplier: 1, constant: trailing)
        let yTopSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute:  .Top, relatedBy: .Equal, toItem: self.scrollViewHr, attribute: .Top, multiplier: 1, constant: top)
        let yBottomSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollViewHr, attribute: .Bottom, multiplier: 1, constant: bottom)
        self.view .addConstraints([xLeadingSpace,xTrailingSpace,yTopSpace,yBottomSpace])
    }
}
