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

class EHFeedbackViewController: NSViewController,HRFormScroller
{
    //MARK: IBOutlets
    @IBOutlet var feedbackMainView: NSView!
    @IBOutlet weak var typeOfInterview: NSSegmentedControl!
    @IBOutlet weak var subRound: NSSegmentedControl!
    @IBOutlet weak var scrollViewHr: NSScrollView!
    @IBOutlet var clearButton: NSButton!
    @IBOutlet var submitButton: NSButton!
    
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
    let dataAccess = EHTechnicalFeedbackDataAccess()
    var managedObjectContext : NSManagedObjectContext?
    var technicalFeedbackData : TechnicalFeedBack?
    var managerialFeedbackData :  ManagerFeedBack?
    
    //MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        techFeedback = storyboard?.instantiateControllerWithIdentifier("EHTechnicalFeedbackViewController") as? EHTechnicalFeedbackViewController
        techFeedback?.feedbackControl = self
        techFeedback!.selectedCandidate = selectedCandidate
        techFeedback?.managedObjectContext = self.managedObjectContext
        self.scrollViewHr.documentView? = (techFeedback?.view)!
        self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1081))
        self.typeOfInterview.selectedSegment = 0
        self.subRound.selectedSegment = 0
        enablingAndDisablingOfSegments()
        self.scrollViewHr.hasVerticalScroller = true
    }
    
    @IBAction func roundType(sender: AnyObject)
    {
        self.subRound.hidden = false
        let mainRound:NSSegmentedControl = sender as! NSSegmentedControl
        let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
        
        enablingAndDisablingOfSegments()
        switch mainRound.selectedSegment
        {
        case 0 :
            if !isTechnicalLoaded
            {
                self.scrollViewHr.documentView? = (techFeedback?.view)!
                animateView(self.scrollViewHr.documentView!)
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
            
            for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
            {
                let feedback = feedbackOfTechLead as! TechnicalFeedBack
                
                if feedback.recommendation == "Rejected"
                {
                    Utility.alertPopup("Alert", informativeText: "This candidate has been 'Rejected' in the Technical Round. Hence you cannot proceed to this round.",isCancelBtnNeeded:false, okCompletionHandler: nil)
                    
                    self.typeOfInterview.selectedSegment = 0
                    
                    return
                }
            }

            if techLeadCount < 1
            {
                Utility.alertPopup("Alert", informativeText: "Please complete the Technical Round(s) before proceeding to the Managerial Round",isCancelBtnNeeded:false, okCompletionHandler: nil)
                subRound.selectedSegment = 0
                typeOfInterview.setSelected(true, forSegment: 0)
                return
            }
           
            if !isManagerLoaded
            {
               managerFeedback = storyboard?.instantiateControllerWithIdentifier("EHManagerFeedbackViewController") as? EHManagerFeedbackViewController
                managerFeedback?.managerFeedbackData = self
                managerFeedback?.selectedCandidate = selectedCandidate
                managerFeedback?.managedObjectContext = self.managedObjectContext
                self.scrollViewHr.documentView = managerFeedback?.view
                animateView(self.scrollViewHr.documentView!)
                self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1542))
                self.subRound.setEnabled(true, forSegment: 0)
            }
            self.hrView?.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            self.subRound.segmentCount = 2
            self.subRound.selectedSegment = 0
            self.subRound.setWidth(300, forSegment: 0)
            self.subRound.setWidth(300, forSegment: 1)
            isHrLoaded = false
            
        case 2:
            
            for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
            {
                let feedback = feedbackOfTechLead as! TechnicalFeedBack
                
                if feedback.recommendation == "Rejected"
                {
                    Utility.alertPopup("Alert", informativeText: "This candidate has been 'Rejected' in the Technical Round. Hence you cannot proceed to this round.",isCancelBtnNeeded:false, okCompletionHandler: nil)
                    
                    self.typeOfInterview.selectedSegment = 0
                    
                    return
                }
            }
            
            for feedbackOfManager in (selectedCandidate?.interviewedByManagers)!
            {
                let feedback = feedbackOfManager as! ManagerFeedBack
                
                if feedback.recommendation == "Rejected"
                {
                    Utility.alertPopup("Alert", informativeText: "This candidate has been 'Rejected' in the Manager Round. Hence you cannot proceed to this round.",isCancelBtnNeeded:false, okCompletionHandler: nil)
                    
                    if self.subRound.segmentCount == 3
                    {
                        self.typeOfInterview.selectedSegment = 0
                    }
                    else if self.subRound.segmentCount == 2
                    {
                        self.typeOfInterview.selectedSegment = 1
                    }
                    return
                }
            }
                
            if !isHrLoaded
            {
                
               self.addHrFeedBackView()
                
            }
            self.managerFeedback?.view.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            self.subRound.hidden = true
        // }
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
                animateView(scrollViewHr.documentView!)
                print("Round One")
                if selectedCandidate?.interviewedByTechLeads?.count != 0
                {
                    let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                    techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                }

        case 1:
                animateView(scrollViewHr.documentView!)
                print("Round Two")
                
                let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
                switch techLeadCount
                {
                case 0:
                       Utility.alertPopup("Alert", informativeText: "Please complete Round 1 before proceeding to Round 2.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                       subRound.selectedSegment = 0
                    
                    
                case 1:
                    
                    for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
                     {
                        let feedback = feedbackOfTechLead as! TechnicalFeedBack
                        if feedback.recommendation == "Rejected"
                        {
                            Utility.alertPopup("Candidate Rejected", informativeText: "This candidate has been 'Rejected' in Round One. Hence you cannot proceed to this round.",isCancelBtnNeeded:false,okCompletionHandler: nil)
                            subRound.selectedSegment = 0
                        }
                        else if feedback.isFeedbackSubmitted == false
                        {
                             Utility.alertPopup("Candidate Rejected", informativeText: "Please complete Round 1 before proceeding to Round 2.",isCancelBtnNeeded:false,okCompletionHandler: nil)
                            subRound.selectedSegment = 0
                        }
                        else
                        {
                            techFeedback?.refreshAllFields()
                            techFeedback?.selectedRound = self.subRound.selectedSegment
                        }
                      break
                     }

                default:
                    if techLeadCount > 1
                    {
                        let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                        techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                    }
                    
                }
            case 2:
                
                print("Round Three")
                 animateView(scrollViewHr.documentView!)
                let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
                switch techLeadCount
                {
                case 0:
                    
                    Utility.alertPopup("Alert", informativeText: "RoundOne not yet Completed", isCancelBtnNeeded:false,okCompletionHandler: nil)
                    subRound.selectedSegment = 0
                    
                    
                case 1:
                    for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
                    {
                        let feedback = feedbackOfTechLead as! TechnicalFeedBack

                        
                            if feedback.recommendation == "Rejected"
                            {
                                Utility.alertPopup("Candidate Rejected", informativeText: "Selected Candidate Rejected has been in Technical Round One. Hence you cannot proceed to round three.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                                subRound.selectedSegment = 0
                            }
                        
                            else if feedback.isFeedbackSubmitted == false
                            {
                                Utility.alertPopup("Alert", informativeText: "Round 1 is not yet Submitted.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                                subRound.selectedSegment = 0
                            }
                            else
                            {
                                techFeedback?.refreshAllFields()
                                subRound.selectedSegment = 1
                                techFeedback?.selectedRound = self.subRound.selectedSegment
                                Utility.alertPopup("Alert", informativeText: "Please complete Round 2 before proceeding to Round 3.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                            }

                    break
                    }
                case 2:
                    var count = 0
                    for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
                    {
                        count += 1
                    let feedback = feedbackOfTechLead as! TechnicalFeedBack
                    if feedback.recommendation == "Rejected"
                    {
                        Utility.alertPopup("Alert", informativeText: "Selected Candidate Rejected has been in Technical Round Two. Hence you cannot proceed to round three.", isCancelBtnNeeded:false,okCompletionHandler: nil)
                        subRound.selectedSegment = 1
                        let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                        techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                         break
                    }
                    else if feedback.isFeedbackSubmitted == false
                    {
                        Utility.alertPopup("Candidate Rejected", informativeText: "Please complete Round 2 before proceeding to Round 3.",isCancelBtnNeeded:false,okCompletionHandler: nil)
                        subRound.selectedSegment = 1
                        let candidateObjects = selectedCandidate?.interviewedByTechLeads?.allObjects
                        techFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                        break
                    }

                    else
                    {
                        if count == 2
                        {
                        techFeedback?.refreshAllFields()

                        techFeedback?.selectedRound = self.subRound.selectedSegment


                        }

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
                animateView(scrollViewHr.documentView!)
                if selectedCandidate?.interviewedByManagers?.count != 0
                {
                    let allObjects = selectedCandidate?.interviewedByManagers?.allObjects
                    managerFeedback?.sortArray(allObjects!, index:self.subRound.selectedSegment)
                }
  
            case 1:
                animateView(scrollViewHr.documentView!)

                print (self.subRound.selectedSegment)
                let managerFeedbackCount = (selectedCandidate?.interviewedByManagers)!.count
                switch managerFeedbackCount
                {
                case 0:
                    Utility.alertPopup("Alert", informativeText: "Please complete Round 1   before proceeding to Round 2.",isCancelBtnNeeded:false, okCompletionHandler: nil)
                    //Disabling proceeding to next round
                    subRound.selectedSegment = 0
                    
                case 1:
                    for feedbackOfManager in (selectedCandidate?.interviewedByManagers)!
                    {
                        let feedback = feedbackOfManager as! ManagerFeedBack
                        
                        if feedback.recommendation == "Rejected"
                        {
                            
                            Utility.alertPopup("Candidate Rejected", informativeText: "This candidate has been 'Rejected' in Round One. Hence you cannot proceed to this round.",isCancelBtnNeeded:false, okCompletionHandler: nil)
                            
                            //Disabling proceeding to next round
                            subRound.selectedSegment = 0

                         
                         }
                        //Disabling proceeding to next round before submitting previous round.
                        else if feedback.isSubmitted == false
                        {
                            Utility.alertPopup("Round One not submitted", informativeText: "Please submit round 1 to proceed to round 2", isCancelBtnNeeded: false, okCompletionHandler: nil)
                            subRound.selectedSegment = 0
                        }
                        else if managerFeedback?.selectedCandidate?.interviewedByManagers?.count > self.subRound.selectedSegment{
                            
                            let candidateObjects = selectedCandidate?.interviewedByManagers?.allObjects
                            managerFeedback?.sortArray(candidateObjects!, index:self.subRound.selectedSegment)
                           
                        }
                    
                       
                        else
                        {
                            managerFeedback?.refreshAllFields()
                            managerFeedback?.selectedSegment = self.subRound.selectedSegment
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
         hrFeedBackViewController?.feedbackControl = self
        hrFeedBackViewController?.candidate = selectedCandidate
        
        hrFeedBackViewController?.delegate = self
        
        if let hrViewController = hrFeedBackViewController
        {
            hrView = hrViewController.view
            hrView!.frame = NSMakeRect(self.scrollViewHr.frame.origin.x,self.scrollViewHr.frame.origin.y,self.scrollViewHr.frame.size.width,1328)//1450
            self.scrollViewHr.documentView = hrView
            animateView(self.scrollViewHr.documentView!)
            
            self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1200))
            isHrLoaded = true
        }
    }
    
    func animateView(docview : AnyObject)
    {
        let animate = CATransition()
        animate.delegate = self
        animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animate.duration = 0.3
        animate.type = kCATransitionPush
        animate.subtype = kCATransition
        docview.layer?.addAnimation(animate, forKey: "")
    }
    
    @IBAction func dismissFeedbackView(sender: AnyObject)
    {
        
            switch self.typeOfInterview.selectedSegment
            {
                
            case 0:
                
                if submitButton.enabled == true
                {
                    if techFeedback?.isFeedBackSaved == false
                    {
                        if clearButton.enabled == true
                        {
                   Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                    print("Technical")
                    self.techFeedback?.saveDetailsAction("")
                   })
                        }
                     }
                    else
                    {
                        Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                            print("Technical")
                            self.techFeedback?.saveDetailsAction("")
                             })
                    }
                
                 }
                
            case 1:
                if submitButton.enabled == true
                {
                    if managerFeedback?.isFeedBackSaved == false
                    {
                        if clearButton.enabled == true
                        {
                            Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                                print("Manager")
                                self.managerFeedback?.saveData("")
                            })
                        }
                    }
                    else
                    {
                        Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                            print("Manager")
                            self.self.managerFeedback?.saveData("")
                        })
                    }
                    
                }

//                if managerFeedback?.submitBtn.enabled == true
//                {
//                    Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
//                        self.managerFeedback?.saveData("")
//                        self.techFeedback?.clearButton.enabled = false
//                        print("Manager")
//
//                    })
//                }
            default:
             
                if submitButton.enabled == true
                {
                    if clearButton.enabled == true
                    {
                    Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                        self.hrFeedBackViewController?.saveCandidate()
                         })
                }
                    else{
                        
                        if selectedCandidate?.miscellaneousInfo?.isHrFormSaved == true
                        {
                            Utility.alertPopup("Do you want to save the changes?", informativeText: "Click on Yes to keep all the entered data", isCancelBtnNeeded: true, okCompletionHandler: { () -> Void in
                                self.hrFeedBackViewController?.saveCandidate()
                            })
                        }
                    }
                }
        }
            
//        self.view.removeFromSuperview()
        self.presentingViewController?.dismissViewController(self)
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
    
    
  func scrollHrFormToPoint(point:NSPoint)
  {
    self.scrollViewHr.documentView?.scrollPoint(point)
    
  }
    func enablingAndDisablingOfSegments()
    {
        
        for feedbackOfTechLead in (selectedCandidate?.interviewedByTechLeads)!
        {
            technicalFeedbackData = feedbackOfTechLead as? TechnicalFeedBack
        }
        for feedbackOfTechLead in (selectedCandidate?.interviewedByManagers)!
        {
            managerialFeedbackData = feedbackOfTechLead as? ManagerFeedBack
        }

        if self.typeOfInterview.selectedSegment == 0
        {
            if (selectedCandidate?.interviewedByTechLeads?.count == 0)
            {
                self.subRound.setEnabled(true, forSegment: 0)
                self.subRound.setEnabled(false, forSegment: 1)
                self.subRound.setEnabled(false, forSegment: 2)
                self.typeOfInterview.setEnabled(true, forSegment: 0)
                self.typeOfInterview.setEnabled(false, forSegment: 1)
                self.typeOfInterview.setEnabled(false, forSegment: 2)
            }
            else if (selectedCandidate?.interviewedByTechLeads?.count == 1)
            {
                if technicalFeedbackData!.isFeedbackSubmitted == true
                    {
                        if technicalFeedbackData!.recommendation == "Rejected"
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(false, forSegment: 1)
                            self.subRound.setEnabled(false, forSegment: 2)
                            self.typeOfInterview.setEnabled(true, forSegment: 0)
                            self.typeOfInterview.setEnabled(false, forSegment: 1)
                            self.typeOfInterview.setEnabled(false, forSegment: 2)
                        }
                        else
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.subRound.setEnabled(false, forSegment: 2)
                            self.typeOfInterview.setEnabled(true, forSegment: 0)
                            self.typeOfInterview.setEnabled(false, forSegment: 1)
                            self.typeOfInterview.setEnabled(false, forSegment: 2)
                            
                        }
                    }
                    else
                    {
                        self.subRound.setEnabled(true, forSegment: 0)
                        self.subRound.setEnabled(false, forSegment: 1)
                        self.subRound.setEnabled(false, forSegment: 2)
                        self.typeOfInterview.setEnabled(true, forSegment: 0)
                        self.typeOfInterview.setEnabled(false, forSegment: 1)
                        self.typeOfInterview.setEnabled(false, forSegment: 2)
                    }
                }
            else if(selectedCandidate?.interviewedByTechLeads?.count == 2)
            {
                if technicalFeedbackData!.isFeedbackSubmitted == true
                    {
                        if technicalFeedbackData!.recommendation == "Rejected"
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.subRound.setEnabled(false, forSegment: 2)
                            self.typeOfInterview.setEnabled(true, forSegment: 0)
                            self.typeOfInterview.setEnabled(false, forSegment: 1)
                            self.typeOfInterview.setEnabled(false, forSegment: 2)
                        }
                        else
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.subRound.setEnabled(true, forSegment: 2)
                            self.typeOfInterview.setEnabled(true, forSegment: 0)
                            self.typeOfInterview.setEnabled(true, forSegment: 1)
                            if managerialFeedbackData != nil
                            {
                            if managerialFeedbackData!.isSubmitted == true
                            {
                                if managerialFeedbackData!.recommendation == "Rejected"
                                {
                                    self.typeOfInterview.setEnabled(false, forSegment: 2)
                                }
                                else
                                {
                                    self.typeOfInterview.setEnabled(true, forSegment: 2)
                                }
                             }
                            }
                            else
                            {
                                self.typeOfInterview.setEnabled(false, forSegment: 2)
                            }

                        }
                    }
                    else
                    {
                        self.subRound.setEnabled(true, forSegment: 0)
                        self.subRound.setEnabled(true, forSegment: 1)
                        self.subRound.setEnabled(false, forSegment: 2)
                        self.typeOfInterview.setEnabled(true, forSegment: 0)
                        self.typeOfInterview.setEnabled(false, forSegment: 1)
                        self.typeOfInterview.setEnabled(false, forSegment: 2)
                    }
                    
            }
            else //if(selectedCandidate?.interviewedByTechLeads?.count == 3)
            {
                    if technicalFeedbackData!.isFeedbackSubmitted == true
                    {
                        if technicalFeedbackData!.recommendation == "Rejected"
                        {
                            
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.subRound.setEnabled(true, forSegment: 2)
                            self.typeOfInterview.setEnabled(true, forSegment: 0)
                            self.typeOfInterview.setEnabled(false, forSegment: 1)
                            self.typeOfInterview.setEnabled(false, forSegment: 2)
                        }
                        else
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.subRound.setEnabled(true, forSegment: 2)
                            self.typeOfInterview.setEnabled(true, forSegment: 0)
                            self.typeOfInterview.setEnabled(true, forSegment: 1)
                            if managerialFeedbackData != nil
                            {
                            if managerialFeedbackData!.isSubmitted == true
                            {
                                if managerialFeedbackData!.recommendation == "Rejected"
                                {
                                    self.typeOfInterview.setEnabled(false, forSegment: 2)
                                }
                                else
                                {
                                    self.typeOfInterview.setEnabled(true, forSegment: 2)
                                }
                            }
                            }
                            else
                            {
                                self.typeOfInterview.setEnabled(false, forSegment: 2)
                            }
                        }
                    }
                    else
                    {
                        self.subRound.setEnabled(true, forSegment: 0)
                        self.subRound.setEnabled(true, forSegment: 1)
                        self.subRound.setEnabled(true, forSegment: 2)
                        self.typeOfInterview.setEnabled(true, forSegment: 0)
                        self.typeOfInterview.setEnabled(false, forSegment: 1)
                        self.typeOfInterview.setEnabled(false, forSegment: 2)
                    }
            }
        }
        else if typeOfInterview.selectedSegment == 1
        {
            if selectedCandidate?.interviewedByManagers?.count == 0
            {
                self.subRound.setEnabled(true, forSegment: 0)
                self.subRound.setEnabled(false, forSegment: 1)
                self.typeOfInterview.setEnabled(true, forSegment: 0)
                self.typeOfInterview.setEnabled(true, forSegment: 1)
                self.typeOfInterview.setEnabled(false, forSegment: 2)
            }
            else if (selectedCandidate?.interviewedByManagers?.count == 1)
            {
                
                    if managerialFeedbackData!.isSubmitted == true
                    {
                        if managerialFeedbackData!.recommendation == "Rejected"
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(false, forSegment: 1)
                            self.typeOfInterview.setEnabled(true, forSegment:0 )
                            self.typeOfInterview.setEnabled(true, forSegment:1 )
                            self.typeOfInterview.setEnabled(false, forSegment:2 )
                        }
                        else
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.typeOfInterview.setEnabled(true, forSegment:0 )
                            self.typeOfInterview.setEnabled(true, forSegment:1 )
                            self.typeOfInterview.setEnabled(true, forSegment:2 )
                        }
                    }
                    else
                    {
                        self.subRound.setEnabled(true, forSegment: 0)
                        self.subRound.setEnabled(false, forSegment: 1)
                        self.typeOfInterview.setEnabled(true, forSegment:0 )
                        self.typeOfInterview.setEnabled(true, forSegment:1 )
                        self.typeOfInterview.setEnabled(false, forSegment:2 )
                        
                    }
            }
                
            else if(selectedCandidate?.interviewedByManagers?.count == 2)
            {
                   if managerialFeedbackData!.isSubmitted == true
                    {
                        if managerialFeedbackData!.recommendation == "Rejected"
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.typeOfInterview.setEnabled(true, forSegment:0 )
                            self.typeOfInterview.setEnabled(true, forSegment:1 )
                            self.typeOfInterview.setEnabled(false, forSegment:2 )
                        }
                        else
                        {
                            self.subRound.setEnabled(true, forSegment: 0)
                            self.subRound.setEnabled(true, forSegment: 1)
                            self.typeOfInterview.setEnabled(true, forSegment:0 )
                            self.typeOfInterview.setEnabled(true, forSegment:1 )
                            self.typeOfInterview.setEnabled(true, forSegment:2 )
                        }
                    }
                    else
                    {
                        self.subRound.setEnabled(true, forSegment: 0)
                        self.subRound.setEnabled(true, forSegment: 1)
                        self.typeOfInterview.setEnabled(true, forSegment:0 )
                        self.typeOfInterview.setEnabled(true, forSegment:1 )
                        self.typeOfInterview.setEnabled(false, forSegment:2 )
                    }
            }
        }
    }

    @IBAction func clearAllFields(sender: AnyObject)
    {
        if typeOfInterview.selectedSegment == 0
        {
            techFeedback?.clearAllFields("")
        }
        else if typeOfInterview.selectedSegment == 1
        {
            managerFeedback?.clearAllFields("")
        }
        else
        {
            hrFeedBackViewController?.clearAllFields("")
        }
    }
    
    @IBAction func SubmitDetails(sender: AnyObject)
    {
        if typeOfInterview.selectedSegment == 0
        {
           techFeedback?.submitDetails("")
        }
        else if typeOfInterview.selectedSegment == 1
        {
            
            managerFeedback?.submitFeedback("")
        }
        else{
            
           hrFeedBackViewController?.subbmitCandidateDetails("")
        }

        
        
    }
    
    
//    func defaultSegmentManager()
//    {
//        if (selectedCandidate?.interviewedByManagers?.count == 0)
//        {
//            self.subRound.setEnabled(true, forSegment: 0)
//            self.subRound.setEnabled(false, forSegment: 1)
//            self.typeOfInterview.setEnabled(true, forSegment: 0)
//            self.typeOfInterview.setEnabled(true, forSegment: 1)
//            self.typeOfInterview.setEnabled(false, forSegment: 2)
//        }
//        else if (selectedCandidate?.interviewedByManagers?.count == 1)
//        {
//            self.subRound.setEnabled(true, forSegment: 0)
//            self.subRound.setEnabled(true, forSegment: 1)
//            self.typeOfInterview.setEnabled(true, forSegment:0 )
//            self.typeOfInterview.setEnabled(true, forSegment:1 )
//            self.typeOfInterview.setEnabled(false, forSegment:2 )
//        }else if(selectedCandidate?.interviewedByManagers?.count == 2)
//        {
//            
//            self.subRound.setEnabled(true, forSegment: 0)
//            self.subRound.setEnabled(true, forSegment: 1)
//            self.subRound.setEnabled(true, forSegment: 2)
//            self.typeOfInterview.setEnabled(true, forSegment:0 )
//            self.typeOfInterview.setEnabled(true, forSegment:1 )
//            self.typeOfInterview.setEnabled(true, forSegment:2 )
//        }
//        
//    }
//
// func defaultSegmentTech()
// {
//    if (selectedCandidate?.interviewedByTechLeads?.count == 0)
//    {
//    self.subRound.setEnabled(true, forSegment: 0)
//    self.subRound.setEnabled(false, forSegment: 1)
//    self.subRound.setEnabled(false, forSegment: 2)
//    self.typeOfInterview.setEnabled(true, forSegment: 0)
//    self.typeOfInterview.setEnabled(false, forSegment: 1)
//    self.typeOfInterview.setEnabled(false, forSegment: 2)
//    }else if (selectedCandidate?.interviewedByTechLeads?.count == 1)
//    {
//        self.subRound.setEnabled(true, forSegment: 0)
//        self.subRound.setEnabled(true, forSegment: 1)
//        self.subRound.setEnabled(false, forSegment: 2)
//        self.typeOfInterview.setEnabled(true, forSegment: 0)
//        self.typeOfInterview.setEnabled(false, forSegment: 1)
//        self.typeOfInterview.setEnabled(false, forSegment: 2)
//    }else if(selectedCandidate?.interviewedByTechLeads?.count == 2)
//    {
//        self.subRound.setEnabled(true, forSegment: 0)
//        self.subRound.setEnabled(true, forSegment: 1)
//        self.subRound.setEnabled(true, forSegment: 2)
//        self.typeOfInterview.setEnabled(true, forSegment: 0)
//        self.typeOfInterview.setEnabled(false, forSegment: 1)
//        self.typeOfInterview.setEnabled(false, forSegment: 2)
//    }else if(selectedCandidate?.interviewedByTechLeads?.count == 3)
//    {
//        self.subRound.setEnabled(true, forSegment: 0)
//        self.subRound.setEnabled(true, forSegment: 1)
//        self.subRound.setEnabled(true, forSegment: 2)
//        self.typeOfInterview.setEnabled(true, forSegment: 0)
//        self.typeOfInterview.setEnabled(true, forSegment: 1)
//        self.typeOfInterview.setEnabled(true, forSegment: 2)
//    }
//    }
}
