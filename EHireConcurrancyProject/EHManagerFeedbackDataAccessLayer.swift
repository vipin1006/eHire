//
//  EHManagerFeedbackDataAccessLayer.swift
//  EHire
//
//  Created by Vipin Nambiar on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa
typealias InsertManagerFeedbackReturn = (isSucess:Bool)->Void
typealias SkillSetObjectReturn = (newSkill:SkillSet)->Void

class EHManagerFeedbackDataAccessLayer: NSObject {
    let coreDataStack = EHCoreDataStack.sharedInstance
    var tempContext = NSManagedObjectContext(concurrencyType:.PrivateQueueConcurrencyType)
    var managedObjectContext : NSManagedObjectContext?
//    let managerFeedbackmodel:EHManagerialFeedbackModel?
    
//    init(managerFeedbackModel:EHManagerialFeedbackModel) {
//      self.managerFeedbackmodel = managerFeedbackModel
//    }
    
    func createSkillSetObject(andCallBack:SkillSetObjectReturn){
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
    
    func createdefaultSkillSetObject(skillSetArray:NSArray,feedBackControllerObj:EHManagerFeedbackViewController,andCallBack:SkillSetArrayReturn){
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
    func createSavedSkillSetObject(managerObject:ManagerFeedBack,skillSetArray:NSArray,andCallBack:SkillSetArrayReturn){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                var skillsAndRatingsTitleArray = [SkillSet]()
                
                for (index,_) in skillSetArray.enumerate()
                {
                    
                    let skillSet = NSEntityDescription.insertNewObjectForEntityForName(String(SkillSet), inManagedObjectContext: managerObject.managedObjectContext!) as? SkillSet
                    
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
    
    func createSkillSetWithManagerObject(managerObject:ManagerFeedBack,andCallBack:SkillSetObjectReturn){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
                let skillSet = NSEntityDescription.insertNewObjectForEntityForName(String(SkillSet), inManagedObjectContext: managerObject.managedObjectContext!) as? SkillSet
                dispatch_sync(dispatch_get_main_queue()
                    ,{ () -> Void in
                        andCallBack(newSkill: skillSet!)
                })
        }
    }
    
    func insertManagerFeedback(feedBackControllerObj:EHManagerFeedbackViewController,candidate:Candidate,managerFeedbackModel:EHManagerialFeedbackModel,andCallBack:InsertTechnicalFeedbackReturn){
        
       
        if tempContext.parentContext == self.managedObjectContext{
            
        }else{
            tempContext.parentContext = self.managedObjectContext
        }
        tempContext.performBlock(
            { () -> Void in
        
        let managerFeedback = NSEntityDescription.insertNewObjectForEntityForName(String(ManagerFeedBack), inManagedObjectContext: self.tempContext) as? ManagerFeedBack
       managerFeedback!.setValue((candidate.interviewedByManagers?.count)!+1, forKey: "id")
        managerFeedback!.setValue(managerFeedbackModel.commentsOnCandidate?.string, forKey: "commentsOnCandidate")
            
        managerFeedback!.setValue(managerFeedbackModel.commentsOnTechnology?.string, forKey: "commentsOnTechnology")
        
            
        managerFeedback!.setValue(managerFeedbackModel.commitments?.string, forKey: "commitments")
        
        
        managerFeedback!.setValue(managerFeedbackModel.grossAnnualSalary, forKey: "grossAnnualSalary")
        
//        managerFeedback.setValue(NSNumber(double: Double((self.managerFeedbackmodel?.grossAnnualSalary)!)!), forKey: "grossAnnualSalary")
        
      
        

       
        managerFeedback!.setValue(NSMutableSet(array: (managerFeedbackModel.skillSet)), forKey: "candidateSkills")
        
        managerFeedback!.setValue(managerFeedbackModel.isCgDeviation, forKey: "isCgDeviation")
            
        managerFeedback!.setValue(managerFeedbackModel.jestificationForHire?.string, forKey: "jestificationForHire")
            
        managerFeedback!.setValue(managerFeedbackModel.modeOfInterview, forKey: "modeOfInterview")
            
        managerFeedback!.setValue(NSNumber(short: (managerFeedbackModel.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        
        managerFeedback!.setValue(NSNumber(short: (managerFeedbackModel.ratingOnTechnical)!), forKey: "ratingOnTechnical")
            
        managerFeedback!.setValue(managerFeedbackModel.recommendation, forKey: "recommendation")
            
        managerFeedback!.setValue(managerFeedbackModel.recommendedCg, forKey: "recommendedCg")

        managerFeedback!.setValue(managerFeedbackModel.designation, forKey: "designation")
        managerFeedback!.setValue(managerFeedbackModel.managerName, forKey: "managerName")
        
        let candidateObjectId = candidate.objectID
        managerFeedback?.setValue(self.tempContext.objectWithID(candidateObjectId), forKey: "candidate")
                
         managerFeedback!.setValue(managerFeedbackModel.isSubmitted, forKey: "isSubmitted")
       
                do
                {
                    try self.tempContext.save()
                    dispatch_sync(dispatch_get_main_queue()
                        ,{ () -> Void in
                            feedBackControllerObj.managerFeedbackObject = managerFeedback
                            andCallBack(isSucess: true)
                    })
                    
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
        })
        
       
        
        
        
    }
    
    func updateManagerFeedback(candidate:Candidate,managerFeedback:ManagerFeedBack,managerFeedbackModel:EHManagerialFeedbackModel,andCallBack:InsertTechnicalFeedbackReturn){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            { () -> Void in
        
        managerFeedback.setValue(managerFeedbackModel.commentsOnCandidate?.string, forKey: "commentsOnCandidate")
        
        managerFeedback.setValue(managerFeedbackModel.commentsOnTechnology?.string, forKey: "commentsOnTechnology")
        
        
        managerFeedback.setValue(managerFeedbackModel.commitments?.string, forKey: "commitments")
        
        
        managerFeedback.setValue(managerFeedbackModel.grossAnnualSalary, forKey: "grossAnnualSalary")
        
        //        managerFeedback.setValue(NSNumber(double: Double((self.managerFeedbackmodel?.grossAnnualSalary)!)!), forKey: "grossAnnualSalary")
        
        
        
        
        
        managerFeedback.setValue(NSMutableSet(array: (managerFeedbackModel.skillSet)), forKey: "candidateSkills")
        
        managerFeedback.setValue(managerFeedbackModel.isCgDeviation, forKey: "isCgDeviation")
        
        managerFeedback.setValue(managerFeedbackModel.jestificationForHire?.string, forKey: "jestificationForHire")
        
        managerFeedback.setValue(managerFeedbackModel.modeOfInterview, forKey: "modeOfInterview")
        
        managerFeedback.setValue(NSNumber(short: (managerFeedbackModel.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        
        managerFeedback.setValue(NSNumber(short: (managerFeedbackModel.ratingOnTechnical)!), forKey: "ratingOnTechnical")
        
        managerFeedback.setValue(managerFeedbackModel.recommendation, forKey: "recommendation")
        
        managerFeedback.setValue(managerFeedbackModel.recommendedCg, forKey: "recommendedCg")
        
        managerFeedback.setValue(managerFeedbackModel.designation, forKey: "designation")
        managerFeedback.setValue(managerFeedbackModel.managerName, forKey: "managerName")
        
        
        let candidateObjectId = candidate.objectID
        managerFeedback.setValue(managerFeedback.managedObjectContext!.objectWithID(candidateObjectId), forKey: "candidate")
        managerFeedback.setValue(managerFeedbackModel.isSubmitted, forKey: "isSubmitted")
        
                do
                {
                    
                    try managerFeedback.managedObjectContext!.save()
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
