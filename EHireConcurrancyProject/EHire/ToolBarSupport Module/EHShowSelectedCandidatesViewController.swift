//
//  EHShowSelectedCandidatesViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 29/02/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHShowSelectedCandidatesViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {
    
    @IBOutlet var technologyPopUP: NSPopUpButton!
    
    @IBOutlet var candidatesTableView: NSTableView!
    
    
    var techVC:EHTechnologyViewController?
    
    var technologyDataLayer:EHTechnologyDataLayer = EHTechnologyDataLayer()
    
    var candidateAccessLayer:EHCandidateAccessLayer = EHCandidateAccessLayer()
    
    var managedObjectContext:NSManagedObjectContext?
    
    var  technologies:[Technology]?
    
    var shortlistedCandidsates = NSMutableArray()
    
    @IBOutlet var techDates: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor(red: 222, green: 222, blue: 222, alpha: 0.5).CGColor
        self.technologyPopUP.removeAllItems()
        self.techDates.removeAllItems()
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        self.shortlistedCandidsates.removeAllObjects()
        
        technologyDataLayer.managedObjectContext = self.managedObjectContext
        candidateAccessLayer.managedObjectContext = self.managedObjectContext
        technologyDataLayer.getTechnologyListWith(
            {[weak self] (technologyList,error) -> Void in
                if CoreDataError.Success == error
                {
                    self!.technologies = technologyList as? [Technology]
                    
                    if let _ = self!.technologies
                    {
                        
                        for x in self!.technologies!
                        {
                            
                            self!.technologyPopUP.addItemWithTitle(x.technologyName!)
                            
                        }
                        
                        self!.getInterviewDatesForTechnology(0)
                        
                        if self!.shortlistedCandidsates.count > 0
                        {
                            print("PRAISE THE LORD")
                            
                            self?.candidatesTableView.reloadData()
                            
                        }
                        else
                        {
                            print("No Candidates Selected")
                        }
                        
                        
                    }
                    
                }
                else
                {
                    print("Error")
                }
            })
        
        
        
    }
    
    @IBAction func technologyChangeTo(sender: NSPopUpButton) {
        
        self.shortlistedCandidsates.removeAllObjects()
        
        self.candidatesTableView.reloadData()
        
        let index = sender.indexOfItemWithTitle(sender.titleOfSelectedItem!)
        
        getInterviewDatesForTechnology(index)
        
    }
    
    @IBAction func interviewDateChangeTo(sender: NSPopUpButton) {
        
        self.shortlistedCandidsates.removeAllObjects()
        
        let techIndex = self.technologyPopUP.indexOfSelectedItem
        
        let dateIndex = self.techDates.indexOfSelectedItem
        
        let technology = self.technologies![techIndex]
        
        let interviewDate = technology.interviewDates?.allObjects[dateIndex] as! Date
        
        getShortlistedCandidatesOfTechnology(technology.technologyName!, interviewDate:interviewDate.interviewDate!)
        
        if self.shortlistedCandidsates.count > 0
        {
            self.candidatesTableView.reloadData()
            
        }
        else
        {
            self.shortlistedCandidsates.removeAllObjects()
            
            self.candidatesTableView.reloadData()
            
        }
        
    }
    
    
    func getInterviewDatesForTechnology(index:Int)
    {
        
        self.techDates.removeAllItems()
        
        if self.technologies?.count > 0
        {
            
            let firstTechnology = self.technologies![index]
            
            if firstTechnology.interviewDates?.count > 0
            {
                
                let dates = firstTechnology.interviewDates?.allObjects as! [Date]
                
                for (_,x) in dates.enumerate()
                {
                    let date = x as Date
                    
                    let dateS = NSDateFormatter.localizedStringFromDate(date.interviewDate!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle) as String
                    
                    self.techDates.addItemWithTitle(dateS)
                    
                }
                
                if firstTechnology.interviewDates?.allObjects.count > 0
                {
                    let firstDate = firstTechnology.interviewDates?.allObjects[0] as! Date
                    
                    getShortlistedCandidatesOfTechnology(firstTechnology.technologyName!, interviewDate:firstDate.interviewDate!)
                    
                    
                    
                }
                else
                {
                    self.shortlistedCandidsates.removeAllObjects()
                    
                    self.candidatesTableView.reloadData()
                }
                
                
            }
            
        }
        
    }
    
    func getShortlistedCandidatesOfTechnology(technologyName:String,interviewDate:NSDate)
    {
        self.shortlistedCandidsates.removeAllObjects()
        
        candidateAccessLayer.getCandiadteList(technologyName, interviewDate:interviewDate, andCallBack: { [weak self](recordsArray) -> Void in
            
            print(recordsArray.count)
            if recordsArray.count > 0
            {
                for aRec in recordsArray
                {
                    let cEntity = aRec as! Candidate
                    
                    if cEntity.miscellaneousInfo?.isHrFormSubmitted == 1
                    {
                        self!.shortlistedCandidsates.addObject(cEntity)
                    }
                    else
                    {
                        print("Yot yet Shortlisted")
                    }
                    
                }
                
                self?.candidatesTableView.reloadData()
            }
            })
        
        
    }
    @IBAction func goBack(sender: AnyObject) {
        
        NSApp.mainWindow?.contentViewController = self.techVC
        
        let mwc = NSApp.mainWindow?.windowController as! EHMainWindowController
        
        mwc.goBack.view?.hidden = true
        
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        
        return shortlistedCandidsates.count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = self.candidatesTableView.makeViewWithIdentifier("candidate", owner: self) as! EHCandidateCell
        
        if shortlistedCandidsates.count > 0
        {
            
            let candidate = shortlistedCandidsates[row] as! Candidate
            
            cell.candidateName.stringValue = candidate.name!
            
            cell.candidatePhone.stringValue = candidate.phoneNumber!
            
            let basicInfo = candidate.professionalInfo as! CandidateBasicProfessionalInfo
            
            cell.candidateMail.stringValue = basicInfo.officialEmailId!
            
            
        }
        
        
        return cell
    }
    
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 31
    }
    
    func tableViewSelectionDidChange(notification: NSNotification)
    {
        
        
    }
    
    
}

//Future reference

//        let item = self.techVC?.sourceList.itemAtRow((self.techVC?.sourceList.selectedRow)!)
//
//        if item is Technology
//        {
//            print("Technology")
//        }
//    else
//        {
//            let selectedDate = self.techVC?.sourceList.parentForItem(item) as! Technology
//
//            print(selectedDate.technologyName)
//
//            let d = item as! Date
//
//            print(d.interviewDate)
//
//
//       }
//
