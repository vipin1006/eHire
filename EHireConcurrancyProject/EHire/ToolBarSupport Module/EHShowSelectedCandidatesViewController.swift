//
//  EHShowSelectedCandidatesViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 29/02/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHShowSelectedCandidatesViewController: NSViewController {
    
    @IBOutlet var technologyPopUP: NSPopUpButton!
    var tech:EHTechnologyViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor(red: 222, green: 222, blue: 222, alpha: 0.5).CGColor
    }
    
    
    
}
