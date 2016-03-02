//
//  EHCandidateCell.swift
//  EHire
//
//  Created by ajaybabu singineedi on 01/03/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHCandidateCell: NSTableCellView {

    
        @IBOutlet var candidateName: NSTextField!
        
        @IBOutlet var candidatePhone: NSTextField!
        
        @IBOutlet var candidateMail: NSTextField!
        
        @IBOutlet var sendMail: NSButton!
    
        @IBOutlet var showInfo: NSButton!
        
        override func drawRect(dirtyRect: NSRect) {
            super.drawRect(dirtyRect)
            
            ///Drawing code here.
        }
    
    
    
        
    }


