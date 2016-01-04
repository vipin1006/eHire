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

        self.scheduleDatePicker.minDate = NSDate()

    }
    
    @IBAction func dateSelection(sender: AnyObject) {
        
        if let del = self.delegate{
            
            del.sendData(self.scheduleDatePicker.dateValue, sender: NSStringFromClass(EHPopOverController))
        }
    }
}
