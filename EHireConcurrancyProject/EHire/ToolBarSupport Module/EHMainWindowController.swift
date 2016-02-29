//
//  EHMainWindowController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 29/02/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHMainWindowController: NSWindowController {
    
    var selectedCandidatesViewController:EHShowSelectedCandidatesViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
       
    }
    @IBAction func showSelectedCandidates(sender:NSToolbarItem) {
        
        
        
        if selectedCandidatesViewController != nil
        {
            return
        }
        
       selectedCandidatesViewController = self.storyboard?.instantiateControllerWithIdentifier("toSelectedCandidates") as? EHShowSelectedCandidatesViewController
        
        self.contentViewController = selectedCandidatesViewController
      
    }

}
