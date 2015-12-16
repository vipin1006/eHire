//
//  EHPopOverController.swift
//  EHire
//
//  Created by Sudhanshu Saraswat on 10/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHPopOverController: NSViewController {
    
     //var popOver:NSPopover = NSPopover()
     var delegate : DataCommunicator?

    @IBOutlet weak var scheduleDatePicker: NSDatePicker!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scheduleDatePicker.dateValue = NSDate()
        
        self.scheduleDatePicker.sendActionOn(1)
 
    }
    
//    func showPopOver(button:NSButton){
//        
////        popOver.behavior = NSPopoverBehavior.Transient
////        
////        popOver.contentViewController = self
////        
////        popOver.showRelativeToRect(button.bounds, ofView:button, preferredEdge:NSRectEdge.MaxX)
//        
//        }
    
    @IBAction func dateSelection(sender: AnyObject) {
        
        print(self.scheduleDatePicker.dateValue)
        
        
        
        if let del = self.delegate{
            
            del.sendData(self.scheduleDatePicker.dateValue, sender: NSStringFromClass(EHPopOverController))
        
        }
        else{
            
            print("Delegate Not set")
        }
        
         
        
    }
   
}
