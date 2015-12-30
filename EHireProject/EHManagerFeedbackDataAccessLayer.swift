//
//  EHManagerFeedbackDataAccessLayer.swift
//  EHire
//
//  Created by Vipin Nambiar on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerFeedbackDataAccessLayer: NSObject {
    let coreDataStack = EHCoreDataStack.sharedInstance
    
    let managerFeedbackmodel:EHManagerialFeedbackModel?
    init(managerFeedbackModel:EHManagerialFeedbackModel) {
      self.managerFeedbackmodel = managerFeedbackModel
    }
    
    func insertManagerFeedback() -> Bool{
        
        let managerFeedbackentity = EHCoreDataHelper.createEntity("ManagerFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        let managerFeedback:ManagerFeedBack = ManagerFeedBack(entity:managerFeedbackentity!, insertIntoManagedObjectContext:coreDataStack.managedObjectContext) as ManagerFeedBack
       
        managerFeedback.setValue(self.managerFeedbackmodel?.commentsOnCandidate, forKey: "commentsOnCandidate")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.commentsOnTechnology, forKey: "commentsOnTechnology")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.commitments, forKey: "commitments")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.grossAnnualSalary, forKey: "grossAnnualSalary")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.managerName, forKey: "managerName")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.isCgDeviation, forKey: "isCgDeviation")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.jestificationForHire, forKey: "jestificationForHire")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.modeOfInterview, forKey: "modeOfInterview")
            
        managerFeedback.setValue(NSNumber(short: (self.managerFeedbackmodel?.ratingOnCandidate)!), forKey: "ratingOnCandidate")
            
        managerFeedback.setValue(NSNumber(short: (self.managerFeedbackmodel?.ratingOnTechnical)!), forKey: "ratingOnTechnical")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.recommendation, forKey: "recommendation")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.recommendedCg, forKey: "recommendedCg")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.candidate, forKey: "candidate")
        
        managerFeedback.setValue(self.managerFeedbackmodel?.skillSet, forKey: "candidateSkills")
        
        managerFeedback.setValue(self.managerFeedbackmodel?.designation, forKey: "designation")
        
        EHCoreDataHelper.saveToCoreData(managerFeedback)
        
        
        return true
    }
    
    func fetchManagerFeedback()->[AnyObject]{
        
        
        let predicate = NSPredicate(format:"name = %@" , (self.managerFeedbackmodel?.candidate?.name)!)
        
        let managerFeedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "ManagerFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        
        return managerFeedbackRecords as! [AnyObject]
        
    }

}
