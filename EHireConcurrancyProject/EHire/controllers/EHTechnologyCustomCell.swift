//
//  EHParentCustomCell.swift
//  EHire
//
//  Created by Sudhanshu Saraswat on 10/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnologyCustomCell: NSTableCellView,DataCommunicator {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    

    @IBOutlet weak var lblParent: NSTextField!
    
    @IBOutlet weak var btnParent: NSButton!
    
    
    
    
    @IBAction func btnCalenderPopOver(sender: NSButton)
    {
       
        
        let storyB = NSStoryboard.init(name:"Main", bundle:NSBundle.mainBundle())
        
        
        
        let popOver = storyB.instantiateControllerWithIdentifier("popover") as! EHPopOverController
        
        Swift.print(popOver)
        
        
        
        
        let button:NSButton = sender as! NSButton
        
        let storyBoard:NSStoryboard = NSStoryboard(name:"Main", bundle:NSBundle.mainBundle())
        
        let pop = storyBoard.instantiateControllerWithIdentifier("popover") as! EHPopOverController
        
        //pop.showPopOver(button)
    }
    
    func sendData<T>(sendingData: T,sender:String) {
        
        let selected = sendingData as! NSDate
        
        Swift.print(selected)
        
        
    }

    
   }
