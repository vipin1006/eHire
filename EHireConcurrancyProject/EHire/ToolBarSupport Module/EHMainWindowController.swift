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
