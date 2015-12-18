//
//  EHManagerFeedbackViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerFeedbackViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate {

    @IBOutlet weak var enterCG: NSTextField!
    @IBOutlet weak var enterPosition: NSTextField!
    @IBOutlet weak var enterInterviewBy: NSTextField!
    @IBOutlet var enterCommitments: NSTextView!
    @IBOutlet var justificationForHire: NSTextView!
    @IBOutlet weak var enterGrossSalary: NSTextField!
    @IBOutlet weak var enterDesignation: NSTextField!
    
    @IBOutlet weak var assestmentCandLabel: NSTextField!
    @IBOutlet weak var assessmentCandView: NSView!
    @IBOutlet weak var assessmentTechView: NSView!
    @IBOutlet weak var assessmentTechLabel: NSTextField!
    var ratingTitle = [String]()
    var selectRow : Int?
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return ratingTitle.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("DataCell", owner: self) as! EHManagerFeedBackCustomTableView
        cell.titleName.stringValue = ratingTitle[row]
        cell.titleName.tag = row
        cell.titleName.target = self
        cell.titleName.delegate = self
        cell.titleName.editable = true
        
        for ratingsView in cell.selectStar.subviews
        {
            let view = ratingsView as! NSButton
            view.target = self
            view.action = "selectedStarCount:"
            
        }
        return cell
    }
    
    func alertPopup(data:String, informativeText:String){
        
        let alert:NSAlert = NSAlert()
        alert.messageText = data
        alert.informativeText = informativeText
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.runModal()
    }
    
    func selectedStarCount(sender : NSButton)
    {
        let ratingCell = sender.superview?.superview as! EHManagerFeedBackCustomTableView
        if ratingCell.titleName.stringValue == "Enter Title"
        {
            alertPopup("Enter the Title", informativeText: "Please select and click on Enter Title field to give title name")
            return
        }
        displayStar(ratingCell.selectStar, lbl: ratingCell.feedBackRating, btn: sender )
        
        
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        selectRow = row
        return true
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        ratingTitle[control.tag] = fieldEditor.string!
        return true
    }
    
    
    
    @IBAction func addRating(sender: NSButton)
    {
        ratingTitle.append("Enter Title")
        tableView.reloadData()
        
    }
    @IBAction func deleteRating(sender: NSButton)
    {
        ratingTitle.removeAtIndex(selectRow!)
        tableView.reloadData()
    }
    
    
    
    @IBAction func assessmentBtn(sender: AnyObject)
    {
        for ratingsView in assessmentTechView.subviews
        {
            let view = ratingsView as! NSButton
            view.target = self
            displayStar(assessmentTechView, lbl:assessmentTechLabel, btn: sender as! NSButton)
            
        }
    }
    
    @IBAction func assessmentCandidateBtn(sender: AnyObject)
    {
        for ratingsView in assessmentCandView.subviews
        {
            let view = ratingsView as! NSButton
            view.target = self
            displayStar(assessmentCandView, lbl:assestmentCandLabel, btn: sender as! NSButton)
            
        }
        
    }
    func displayStar(customView:NSView,lbl:NSTextField,btn:NSButton)
    {
        let totalView = customView.subviews
        var totalStarCount : Int?
        func countingOfStars(total: Int, deselectStars : Int?...)
        {
            print(total)
            print(deselectStars)
            if deselectStars.count == 0
            {
                if total == -1
                {
                    btn.image = NSImage(named: "selectStar")
                    
                    for starCount in 1...4
                    {
                        let countBtn = totalView[starCount] as! NSButton
                        if countBtn.image?.name() == "selectStar"
                        {
                            countBtn.image = NSImage(named: "deselectStar")
                        }
                    }
                }
                    
                else
                {
                    for countStar in 0...total
                    {
                        let countBtn = totalView[countStar] as! NSButton
                        if countBtn.image?.name() == "deselectStar"
                        {
                            countBtn.image = NSImage(named: "selectStar")
                        }
                    }
                }
            }
            else
            {
                for stars in deselectStars{
                    
                    let star = totalView[stars!] as! NSButton
                    
                    if star.image?.name() == "selectStar"{
                        
                        star.image = NSImage(named: "deselectStar")
                    }
                }
            }
        }
        if btn.image?.name() == "selectStar"
        {
            btn.image = NSImage(named: "deselectStar")
        }
        else
        {
            btn.image = NSImage(named: "deselectStar")
        }
        print(btn.tag)
        
        
        
        switch (btn.tag)
        {
        case 0:
            countingOfStars(-1)
            
            lbl.stringValue = "Not Satisfactory"
            
            
        case 1:
            countingOfStars(1)
            lbl.stringValue = "Satisfactory"
            countingOfStars(0, deselectStars: 2,3,4)
            
        case 2:
            countingOfStars(2)
            lbl.stringValue = "Good"
            countingOfStars(0, deselectStars: 3,4)
            
        case 3:
            countingOfStars(3)
            lbl.stringValue = "Very Good"
            countingOfStars(0, deselectStars: 4)
            
        case 4:
            countingOfStars(4)
            lbl.stringValue = "Excellent"
        default : print("")
        }
        
    }
    func validateField()->Bool
    {
        if enterPosition.stringValue == ""
        {
            alertPopup("enterPosition", informativeText: "Please enter valid Position")
        }else if enterInterviewBy.stringValue == ""
        {
            alertPopup("enterInterViewBy", informativeText: "Please enter valid Name")
        }
        else if enterCG.stringValue == ""
        {
            alertPopup("enterCG", informativeText: "Please enter valid data valid CG")
        }
        else if( enterCommitments.string == "")
        {
            alertPopup("enterCommitments", informativeText: "Please enter valid data Commitments Field")
        }else if justificationForHire.string == ""
        {
            alertPopup("justificationForHire", informativeText: "Please enter valid data justificationForHire Field")
        }else if enterGrossSalary.stringValue == ""
        {
            alertPopup("enterGrossSalary", informativeText: "Please enter valid data in GrossSalary Field")
        }else if enterDesignation.stringValue == ""
        {
            alertPopup("enterDesignation", informativeText: "Please enter valid data in designation Field")
        }
        return true
    }
    @IBAction func saveData(sender: AnyObject)
    {
        validateField()
    }
   
    
    
    
    
}
