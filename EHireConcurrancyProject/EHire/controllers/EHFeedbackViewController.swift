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
    let dataAccess = EHTechnicalFeedbackDataAccess()
    var managedObjectContext : NSManagedObjectContext?
    
    //MARK: View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        self.view.layer?.backgroundColor = NSColor(calibratedRed:247/255.0, green: 246/255.0, blue: 247/255.0, alpha: 1.0).CGColor
        techFeedback = storyboard?.instantiateControllerWithIdentifier("EHTechnicalFeedbackViewController") as? EHTechnicalFeedbackViewController
        techFeedback?.feedback = self
        defaultSegmentTech()
        //defaultSegmentManager()
        techFeedback!.selectedCandidate = selectedCandidate
        techFeedback?.managedObjectContext = self.managedObjectContext
        self.scrollViewHr.documentView? = (techFeedback?.view)!
        self.scrollViewHr.layer?.backgroundColor = NSColor(calibratedRed:125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0).CGColor
        self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1081))
        self.typeOfInterview.selectedSegment = 0
        self.subRound.selectedSegment = 0
        self.scrollViewHr.hasVerticalScroller = true
        
        
       
        // self.scrollViewHr.hasHorizontalScroller = true
//        self.subRound.layer?.backgroundColor =  NSColor(calibratedRed:245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).CGColor
    }
    
    @IBAction func roundType(sender: AnyObject)
    {
        
        self.subRound.hidden = false
        let mainRound:NSSegmentedControl = sender as! NSSegmentedControl

        let techLeadCount = (selectedCandidate?.interviewedByTechLeads)!.count
        let managerCount =  (selectedCandidate?.interviewedByManagers)!.count
        defaultSegmentManager()
        
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

            
            if techLeadCount < 3
            {
                Utility.alertPopup("Alert", informativeText: "Please complete Technical Round(s) before proceeding to the HR Round", isCancelBtnNeeded:false,okCompletionHandler: nil)
                subRound.selectedSegment = 0
                typeOfInterview.setSelected(true, forSegment: 0)
                return
            }
            else
            {
               
                
                if managerCount < 2
                {
//                    Utility.alertPopup("Alert", informativeText: "Please complete Manager Round(s) before proceeding to the HR Round", isCancelBtnNeeded:false,okCompletionHandler: nil)
                    
                    self.typeOfInterview.selectedSegment = 1

                    return
                }
                
            if !isHrLoaded
            {
               self.addHrFeedBackView()
                
            }
            self.managerFeedback?.view.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            self.subRound.hidden = true
         }
        default:
            print("Other")
        }
    }
    
    @IBAction func subRound(sender: AnyObject)
    {
        //defaultSegmentManager()
        //defaultSegmentTech()
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
                        count++
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
                defaultSegmentManager()
                
            default: print("")
            }
         default: print("")
          
        
        }
    }
    
    func addHrFeedBackView()
    {
        hrFeedBackViewController = self.storyboard?.instantiateControllerWithIdentifier("EHHrFeedbackViewController") as? EHHrFeedbackViewController
        
        hrFeedBackViewController?.candidate = selectedCandidate
        
        hrFeedBackViewController?.delegate = self
        
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
        
            switch self.typeOfInterview.selectedSegment
            {
                
            case 0:
                
                if techFeedback?.submitButton.enabled == true
                {
                    if techFeedback?.isFeedBackSaved == false
                    {
                        if techFeedback?.clearButton.enabled == true
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
                if managerFeedback?.submitBtn.enabled == true
                {
                    if managerFeedback?.isFeedBackSaved == false
                    {
                        if managerFeedback?.clearBtn.enabled == true
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
             
                if hrFeedBackViewController!.submitButton.enabled == true
                {
                    if hrFeedBackViewController!.clearButton.enabled == true
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
    
    
  func scrollHrFormToPoint(point:NSPoint)
  {
    self.scrollViewHr.documentView?.scrollPoint(point)
    
  }
    func defaultSegmentManager()
    {
        if (selectedCandidate?.interviewedByManagers?.count == 0)
        {
            self.subRound.setEnabled(true, forSegment: 0)
            self.subRound.setEnabled(false, forSegment: 1)
            self.typeOfInterview.setEnabled(true, forSegment: 0)
            self.typeOfInterview.setEnabled(true, forSegment: 1)
            self.typeOfInterview.setEnabled(false, forSegment: 2)
        }
        else if (selectedCandidate?.interviewedByManagers?.count == 1)
        {
            self.subRound.setEnabled(true, forSegment: 0)
            self.subRound.setEnabled(true, forSegment: 1)
            self.typeOfInterview.setEnabled(true, forSegment:0 )
            self.typeOfInterview.setEnabled(true, forSegment:1 )
            self.typeOfInterview.setEnabled(false, forSegment:2 )
        }else if(selectedCandidate?.interviewedByManagers?.count == 2)
        {
            
            self.subRound.setEnabled(true, forSegment: 0)
            self.subRound.setEnabled(true, forSegment: 1)
            self.subRound.setEnabled(true, forSegment: 2)
            self.typeOfInterview.setEnabled(true, forSegment:0 )
            self.typeOfInterview.setEnabled(true, forSegment:1 )
            self.typeOfInterview.setEnabled(true, forSegment:2 )
        }
        
    }

 func defaultSegmentTech()
 {
    if (selectedCandidate?.interviewedByTechLeads?.count == 0)
    {
    self.subRound.setEnabled(true, forSegment: 0)
    self.subRound.setEnabled(false, forSegment: 1)
    self.subRound.setEnabled(false, forSegment: 2)
    self.typeOfInterview.setEnabled(true, forSegment: 0)
    self.typeOfInterview.setEnabled(false, forSegment: 1)
    self.typeOfInterview.setEnabled(false, forSegment: 2)
    }else if (selectedCandidate?.interviewedByTechLeads?.count == 1)
    {
        self.subRound.setEnabled(true, forSegment: 0)
        self.subRound.setEnabled(true, forSegment: 1)
        self.subRound.setEnabled(false, forSegment: 2)
        self.typeOfInterview.setEnabled(true, forSegment: 0)
        self.typeOfInterview.setEnabled(false, forSegment: 1)
        self.typeOfInterview.setEnabled(false, forSegment: 2)
    }else if(selectedCandidate?.interviewedByTechLeads?.count == 2)
    {
        self.subRound.setEnabled(true, forSegment: 0)
        self.subRound.setEnabled(true, forSegment: 1)
        self.subRound.setEnabled(true, forSegment: 2)
        self.typeOfInterview.setEnabled(true, forSegment: 0)
        self.typeOfInterview.setEnabled(false, forSegment: 1)
        self.typeOfInterview.setEnabled(false, forSegment: 2)
    }else if(selectedCandidate?.interviewedByTechLeads?.count == 3)
    {
        self.subRound.setEnabled(true, forSegment: 0)
        self.subRound.setEnabled(true, forSegment: 1)
        self.subRound.setEnabled(true, forSegment: 2)
        self.typeOfInterview.setEnabled(true, forSegment: 0)
        self.typeOfInterview.setEnabled(true, forSegment: 1)
        self.typeOfInterview.setEnabled(true, forSegment: 2)
    }
    }
    
}
