//
//  TechnicalFeedbackDataAccess.swift
//  EHire
//
//  Created by Tharani P on 23/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa
typealias InsertTechnicalFeedbackReturn = (isSucess:Bool)->Void
typealias SkillSetReturn = (newSkill:SkillSet)->Void
typealias SkillSetArrayReturn = (newSkill:[SkillSet])->Void

class EHTechnicalFeedbackDataAccess: NSObject
{
    var tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
    let coreDataStack = EHCoreDataStack.sharedInstance
    var managedObjectContext : NSManagedObjectContext?
    var skillArray = NSMutableArray()
    func createSkillSetObject(andCallBack:SkillSetReturn){
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        tempContext.performBlock(
            { () -> Void in
                let skillSet = NSEntityDescription.insertNewObjectForEntityForName(String(SkillSet), inManagedObjectContext: self.tempContext) as? SkillSet
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        andCallBack(newSkill: skillSet!)
                })        })
    }
    
    func createdefaultSkillSetObject(skillSetArray:NSArray,feedBackControllerObj:EHTechnicalFeedbackViewController,andCallBack:SkillSetArrayReturn){
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        tempContext.performBlock(
            { () -> Void in
                var skillsAndRatingsTitleArray = [SkillSet]()
//                self.skillArray = [ "Communication","Organisation Stability","Leadership(if applicable)","Growth Potential"]
                for (index,_) in skillSetArray.enumerate()
                {
                    if feedBackControllerObj.arrTemp.count>0{
                        
                        feedBackControllerObj.arrTemp.removeLast()
                    }
                    let skillSet = NSEntityDescription.insertNewObjectForEntityForName(String(SkillSet), inManagedObjectContext: self.tempContext) as? SkillSet
                    skillSet!.skillName = skillSetArray.objectAtIndex(index) as? String
                    skillsAndRatingsTitleArray.append(skillSet!)
                }
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        andCallBack(newSkill: skillsAndRatingsTitleArray)
                })        })
    }
    func createSavedSkillSetObject(technicalManagerObject:TechnicalFeedBack,skillSetArray:NSArray,andCallBack:SkillSetArrayReturn){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                var skillsAndRatingsTitleArray = [SkillSet]()
                
                for (index,_) in skillSetArray.enumerate()
                {
                    
                    let skillSet = NSEntityDescription.insertNewObjectForEntityForName(String(SkillSet), inManagedObjectContext: technicalManagerObject.managedObjectContext!) as? SkillSet
                    
                    let skillSetObject = skillSetArray.objectAtIndex(index) as? SkillSet
                    skillSet?.skillName = skillSetObject?.skillName
                    skillSet?.skillRating = skillSetObject?.skillRating
                    skillsAndRatingsTitleArray.append(skillSet!)
                }
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        andCallBack(newSkill: skillsAndRatingsTitleArray)
                })
        }
    }
    
    func createSkillSetWithTechnicalManagerObject(technicalManagerObject:TechnicalFeedBack,andCallBack:SkillSetReturn){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                
//                if technicalManagerObject.commitEditing() {
                    let skillSet = NSEntityDescription.insertNewObjectForEntityForName(String(SkillSet), inManagedObjectContext: technicalManagerObject.managedObjectContext!) as? SkillSet
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            andCallBack(newSkill: skillSet!)
                    })
//                }
                
        }
    }
    
    
    func insertIntoTechnicalFeedback(feedBackControllerObj:EHTechnicalFeedbackViewController,technicalFeedbackmodel : EHTechnicalFeedbackModel, selectedCandidate : Candidate,andCallBack:InsertTechnicalFeedbackReturn)
    {
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        tempContext.performBlock(
            { () -> Void in
                let technicalFeedback = NSEntityDescription.insertNewObjectForEntityForName(String(TechnicalFeedBack), inManagedObjectContext: self.tempContext) as? TechnicalFeedBack
                technicalFeedback!.setValue(technicalFeedbackmodel.commentsOnCandidate,  forKey: "commentsOnCandidate")
                technicalFeedback!.setValue(technicalFeedbackmodel.commentsOnTechnology,  forKey: "commentsOnTechnology")
                technicalFeedback!.setValue(technicalFeedbackmodel.techLeadName,          forKey: "techLeadName")
                technicalFeedback!.setValue(technicalFeedbackmodel.modeOfInterview,       forKey: "modeOfInterview")
                technicalFeedback!.setValue(technicalFeedbackmodel.recommendation,        forKey: "recommendation")
                technicalFeedback!.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnCandidate)!), forKey: "ratingOnCandidate")
                technicalFeedback!.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnTechnical)!), forKey: "ratingOnTechnical")
                let candidateObjectId = selectedCandidate.objectID
                technicalFeedback?.setValue(self.tempContext.objectWithID(candidateObjectId), forKey: "candidate")
//                technicalFeedback!.setValue(selectedCandidate, forKey: "candidate")
                
                technicalFeedback!.setValue((selectedCandidate.interviewedByTechLeads?.count)!, forKey: "id")
                technicalFeedback!.candidateSkills = NSMutableSet(array: technicalFeedbackmodel.skills!)
                technicalFeedback!.setValue(technicalFeedbackmodel.designation, forKey: "designation")
                technicalFeedback!.setValue(technicalFeedbackmodel.isFeedbackSubmitted, forKey: "isFeedbackSubmitted")
                selectedCandidate.interviewedByTechLeads?.setByAddingObject(technicalFeedback!)
                do
                {
                    try self.tempContext.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            feedBackControllerObj.technicalFeedbackObject = technicalFeedback
                             andCallBack(isSucess: true)
                    })
                   
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
        })
        
        
        
    
//        EHCoreDataHelper.saveToCoreData(selectedCandidate)
    
      
    }
    
    func updateManagerFeedback(candidate:Candidate,technicalFeedback:TechnicalFeedBack,technicalFeedbackmodel : EHTechnicalFeedbackModel,andCallBack:InsertTechnicalFeedbackReturn)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnCandidate, forKey: "commentsOnCandidate")
        technicalFeedback.setValue(technicalFeedbackmodel.commentsOnTechnology, forKey: "commentsOnTechnology")
        technicalFeedback.setValue(NSMutableSet(array: (technicalFeedbackmodel.skills)!), forKey: "candidateSkills")
        
        technicalFeedback.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        technicalFeedback.setValue(NSNumber(short: (technicalFeedbackmodel.ratingOnTechnical)!), forKey: "ratingOnTechnical")
        technicalFeedback.setValue(technicalFeedbackmodel.modeOfInterview, forKey: "modeOfInterview")
        technicalFeedback.setValue(technicalFeedbackmodel.recommendation, forKey: "recommendation")
        technicalFeedback.setValue(technicalFeedbackmodel.designation, forKey: "designation")
        technicalFeedback.setValue(technicalFeedbackmodel.techLeadName, forKey: "techLeadName")
        let candidateObjectId = candidate.objectID
        technicalFeedback.setValue(technicalFeedback.managedObjectContext!.objectWithID(candidateObjectId), forKey: "candidate")
//        technicalFeedback.setValue(candidate, forKey: "candidate")
        technicalFeedback.setValue(technicalFeedbackmodel.isFeedbackSubmitted, forKey: "isFeedbackSubmitted")
//        candidate.interviewedByTechLeads?.setByAddingObject(technicalFeedback)
                
                do
                {
                    
                    try technicalFeedback.managedObjectContext!.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            
                            andCallBack(isSucess: true)
                    })
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
        
        }
    }
}

