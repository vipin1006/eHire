//
//  EHAddTechnology.swift
//  EHire
//
//  Created by Sudhanshu Saraswat on 10/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa
/*protocol addNewTechnologyDelegate
{
    func newTechnology(nameTeechno :String)
}*/



class EHAddTechnology: NSViewController {
    
       var delegate:DataCommunicator?

    @IBOutlet weak var txtTechnologyName: NSTextField!
    var newTechnologyName :String = String()

    override func viewDidLoad() {
     
       super.viewDidLoad()
        
       
        
        // Do view setup here.
    }
    
    @IBAction func submitTechnology(sender: AnyObject)
    {
//        self.newTechnologyName = self.txtTechnologyName.stringValue
//        
//  
//        
//        if let del = self.delegate{
//          
//            del.sendData(self.newTechnologyName,sender: NSStringFromClass(EHAddTechnology))
//        }
//        else{
//            
//            print("Delegate Not set")
//        }
//   
//    
//        self.dismissController(self)
        
        
        if self.txtTechnologyName.stringValue == ""
        {
            let alert: NSAlert = NSAlert()
            alert.messageText = "Alert Message"
            alert.informativeText = "Text Field Should not be Empty"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("Ok")
            alert.addButtonWithTitle("Cancel")
            alert.runModal()
            
        }
        else
        {
            self.newTechnologyName = self.txtTechnologyName.stringValue
            
            if let del = self.delegate{
                
                del.sendData(self.newTechnologyName,sender: NSStringFromClass(EHAddTechnology))
            }
            else{
                
                print("Delegate Not set")
            }
            
            
        }
        
        
        
        
        
        
        
        self.dismissController(self)
    
    }
    @IBAction func cacelTechnology(sender: AnyObject)
    {
        self.dismissController(self)
        
    }
    
}
