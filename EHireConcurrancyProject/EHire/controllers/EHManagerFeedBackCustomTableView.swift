//
//  EHManagerFeedBackCustomTableView.swift
//  EHire
//
//  Created by Vineet Kumar Singh on 11/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerFeedBackCustomTableView: NSTableCellView {

    @IBOutlet weak var titleName: NSTextField!
    @IBOutlet weak var selectStar: NSView!
    @IBOutlet weak var feedBackRating: NSTextField!
    override func drawRect(dirtyRect: NSRect)
    {
        super.drawRect(dirtyRect)

        
    }
    
}
