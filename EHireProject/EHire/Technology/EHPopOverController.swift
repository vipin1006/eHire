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
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.scheduleDatePicker.minDate = NSDate()
        let calendar                    = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let currentDate                 = NSDate()
        let dateComponents              = NSDateComponents()
        dateComponents.month            = 2
        let maxDate                     = calendar?.dateByAddingComponents(dateComponents, toDate: currentDate,                                 options:NSCalendarOptions(rawValue: 0))
        self.scheduleDatePicker.maxDate = maxDate
    }
    
    @IBAction func dateSelection(sender: AnyObject) {
        
        if let del = self.delegate{
            
            del.sendData(self.scheduleDatePicker.dateValue, sender: NSStringFromClass(EHPopOverController))
        }
    }
}
