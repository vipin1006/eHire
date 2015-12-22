//
//  EHFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHFeedbackViewController: NSViewController {

    
    //MARK: IBOutlets
    
    @IBOutlet weak var typeOfInterview: NSSegmentedControl!
    
    @IBOutlet weak var subRound: NSSegmentedControl!
    
    @IBOutlet weak var scrollViewHr: NSScrollView!
    
    //MARK: Properties
    
       var hrView:NSView?
    
    var topObjects:NSArray?
    
    var isHrLoaded = false
    var isTechnicalLoaded  = false
    var isManagerLoaded = false
    
    var hrFeedBackViewController:EHHrFeedbackViewController? = nil
    var managerFeedback : EHManagerFeedbackViewController? = nil
    var  techFeedback : EHTechnicalFeedbackViewController? = nil
    
    
    //MARK: View Life Cycle
    
    override func viewDidLoad()
    {
    super.viewDidLoad()
    
      
    
    
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        techFeedback = storyboard?.instantiateControllerWithIdentifier("TechnicalFeedback") as? EHTechnicalFeedbackViewController
        
        
        
        self.scrollViewHr.documentView? = (techFeedback?.view)!
        
        self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1081))
        
        
        self.typeOfInterview.selectedSegment = 0
        
        self.subRound.selectedSegment = 0
        
        self.scrollViewHr.hasVerticalScroller = true
        
        
    }
    
    override var representedObject: AnyObject? {
    didSet {
    
    }
    }
    
    @IBAction func roundType(sender: AnyObject) {
    
        
        self.subRound.hidden = false
        
        let mainRound:NSSegmentedControl = sender as! NSSegmentedControl
        
        switch mainRound.selectedSegment{
            
        case 0 :
            
            print("T")
            
            if !isTechnicalLoaded
            {
                self.scrollViewHr.documentView? = (techFeedback?.view)!
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
            
            print("M")

            
            if !isManagerLoaded
            {
                managerFeedback = storyboard?.instantiateControllerWithIdentifier("ManagerFeedback") as? EHManagerFeedbackViewController
                self.scrollViewHr.documentView = managerFeedback?.view
                
                self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1626))
                createConstraintsForManagerFeedbackController(0.0, trailing: 0.0, top: 0.0, bottom: 0.0)

            }
            self.hrView?.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            
            self.subRound.segmentCount = 2
            
            self.subRound.selectedSegment = 0
            
            self.subRound.setWidth(300, forSegment: 0)
            
            self.subRound.setWidth(300, forSegment: 1)
            
            isHrLoaded = false
            
        case 2:
            
            print("H")

            
            if !isHrLoaded{
                
                self.addHrFeedBackView()
            }
            self.managerFeedback?.view.removeFromSuperview()
            self.techFeedback?.view.removeFromSuperview()
            
            self.subRound.hidden = true
            
        default:
            print("Other")
        }

    
    }
    
    @IBAction func subRound(sender: AnyObject) {
    
    switch self.typeOfInterview.selectedSegment{
    
    case 0:
    
    switch self.subRound.selectedSegment{
    
    case 0:
    
    print("Round One")
    
    case 1:
    
    print("Round Two")
    
    case 2:
    
    print("Round Three")
    
    default:
    
    print("Nothing")
    }
    
    case 1:
    
    switch self.subRound.selectedSegment{
    
    case 0:
    
    print("Round One")
    
    case 1:
    
    print("Round Two")
    
    default:
    
    print("Nothing")
    
    }
    
    default: print("Nothing")
    }
    
    }
    
    
    func addHrFeedBackView(){
    
    print("Added Hr View")
    
    hrFeedBackViewController = self.storyboard?.instantiateControllerWithIdentifier("hrFeedback") as? EHHrFeedbackViewController
    
    if let hrViewController = hrFeedBackViewController {
    
    hrView = hrViewController.view
    
    hrView!.frame = NSMakeRect(self.scrollViewHr.frame.origin.x,self.scrollViewHr.frame.origin.y,self.scrollViewHr.frame.size.width,1450)
    
    self.scrollViewHr.documentView = hrView
    
    self.scrollViewHr.documentView?.scrollPoint(NSPoint(x:0, y:1200))
    
    isHrLoaded = true
    
    }
    
    }
    
    func createConstraintsForManagerFeedbackController(leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat){
        
//        managerFeedback!.view.translatesAutoresizingMaskIntoConstraints = false
//        
//        let width = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: NSLayoutAttribute.Width, relatedBy: .Equal , toItem: self.scrollViewHr, attribute:NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
//        
//        let height = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: self.scrollViewHr, attribute:NSLayoutAttribute.Height, multiplier: 1.0, constant: 400)
//        let xLeadingSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: .Leading, relatedBy: .Equal, toItem:self.scrollViewHr, attribute: .Leading, multiplier: 1, constant: leading)
//        
//        let xTrailingSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: .Trailing, relatedBy: .Equal, toItem: self.scrollViewHr, attribute: .Trailing, multiplier: 1, constant: trailing)
//        
//        let yTopSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute:  .Top, relatedBy: .Equal, toItem: self.scrollViewHr, attribute: .Top, multiplier: 1, constant: top)
//        
//        let yBottomSpace = NSLayoutConstraint(item: (managerFeedback?.view)!, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollViewHr, attribute: .Bottom, multiplier: 1, constant: bottom)
//        self.view .addConstraints([xLeadingSpace,yTopSpace,width,height])
        
    }
    

    
}
