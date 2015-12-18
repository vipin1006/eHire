//
//  RatingsTableCellView.swift
//  EHire
//
//  Created by Tharani P on 09/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHRatingsTableCellView: NSTableCellView {

    @IBOutlet weak var skilsAndRatingsTitlefield: NSTextField!
    
    @IBOutlet weak var starCustomView: NSView!
    
    @IBOutlet weak var feedback: NSTextField!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
