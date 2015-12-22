//
//  EHCandidateBasicInfo.swift
//  EXEhireInterView
//
//  Created by Pratibha Sawargi on 10/12/15.
//  Copyright © 2015 Pratibha Sawargi. All rights reserved.
//

import Cocoa

 //MARK: Custom Protocol

protocol Callback
{
    func getData(name:String ,experience:String, interViewTime:String ,phoneNum:String)
}

class EHCandidateBasicInfo: NSViewController,NSTextFieldDelegate
{
      //MARK: Variables
    
    weak var candidateObject:EHCandidateController?
    var delegate:Callback?
    
      //MARK: IBOutlets
    
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var experienceField: NSTextField!
    @IBOutlet weak var phoneNumField: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var saveButton: NSButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
      //MARK: Actions
    
    @IBAction func saveInfo(sender: AnyObject)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "hh:mm a"
        let str = dateFormatter.stringFromDate(datePicker.dateValue)
        
        if let del = self.delegate
        {
            del.getData(nameField.stringValue, experience: experienceField.stringValue, interViewTime:str, phoneNum: phoneNumField.stringValue)
        }
        
        nameField.stringValue = ""
        experienceField.stringValue = ""
        phoneNumField.stringValue = ""
        
        self.view.removeFromSuperview()
    }
    
    @IBAction func reset(sender: AnyObject)
    {
        nameField.stringValue = ""
        experienceField.stringValue = ""
        phoneNumField.stringValue = ""
    }
      
    @IBAction func back(sender: AnyObject)
    {
      if let del = self.delegate
        {
          del.getData("", experience :"", interViewTime:"", phoneNum:"")
          self.view.removeFromSuperview()
            
          nameField.stringValue = ""
          experienceField.stringValue = ""
          phoneNumField.stringValue = ""
        }
    }
}
            
            
            
            
  