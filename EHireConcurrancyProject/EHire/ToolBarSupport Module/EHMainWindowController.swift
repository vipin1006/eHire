//
//  EHMainWindowController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 29/02/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa


class EHMainWindowController: NSWindowController,NSWindowDelegate {
    
    var selectedCandidatesViewController:EHShowSelectedCandidatesViewController?
    
    var managedObjectContext:NSManagedObjectContext?
    
    @IBOutlet var goBack: NSToolbarItem!
    
    @IBOutlet var shortlistedToolbarItem: NSToolbarItem!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.delegate = self
        
        self.goBack.toolTip = "Show the previous screen"
        
        self.goBack.view?.hidden = true
    
    }
    
    
    
    @IBAction func showSelectedCandidates(sender:NSToolbarItem) {
        
        var showSelectedCandidatesViewController = false
        
        let presentController = self.contentViewController
        
        if presentController is EHTechnologyViewController
        {
            let technologyController = presentController as! EHTechnologyViewController
            
            if technologyController.technologyArray.count == 0
            {
                Utility.alertPopup("No Technologies present", informativeText:"Please add Technology and schedule interviews", isCancelBtnNeeded:false, okCompletionHandler: { () -> Void in
                    
                })
            }
            else
            {
                
                for x in technologyController.technologyArray
                {
                    if x.interviewDates?.count > 0
                    {
                        showSelectedCandidatesViewController = true
                        
                    }
                }
                
                if showSelectedCandidatesViewController
                {
                    presentShortlistedViewController()
                
                }
                else
                {
                    Utility.alertPopup("No interviews conducted", informativeText:"Please conduct interview by adding a date for any technology", isCancelBtnNeeded:false, okCompletionHandler: { () -> Void in
                        
                    })
                }
                
                
                
                
            }

            
        }
        else
        {
            presentShortlistedViewController()
        
        }
        
        
    }
    
    func presentShortlistedViewController()
    {
        
        if selectedCandidatesViewController != nil
        {
            //self.contentViewController = selectedCandidatesViewController
            
            self.contentViewController?.presentViewController(selectedCandidatesViewController!, animator:EHTransitionAnimator())
            self.goBack.view?.hidden = false
            
        }else
        {
            selectedCandidatesViewController = self.storyboard?.instantiateControllerWithIdentifier("toSelectedCandidates") as? EHShowSelectedCandidatesViewController
            
            selectedCandidatesViewController?.techVC =  self.contentViewController as? EHTechnologyViewController
            
            
            selectedCandidatesViewController!.managedObjectContext = managedObjectContext
            
            selectedCandidatesViewController!.s = self
            
            self.contentViewController?.presentViewController(selectedCandidatesViewController!, animator:EHTransitionAnimator())
            
            self.goBack.view?.hidden = false
            
        }
 
    }
    
}
