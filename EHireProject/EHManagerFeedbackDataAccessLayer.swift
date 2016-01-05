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
    
    func insertManagerFeedback(candidate:Candidate) -> Bool{
        
       
        
        let managerFeedbackentity = EHCoreDataHelper.createEntity("ManagerFeedBack", managedObjectContext: candidate.managedObjectContext!)
        let managerFeedback:ManagerFeedBack = ManagerFeedBack(entity:managerFeedbackentity!, insertIntoManagedObjectContext:candidate.managedObjectContext)
       
        managerFeedback.setValue(self.managerFeedbackmodel?.commentsOnCandidate?.string, forKey: "commentsOnCandidate")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.commentsOnTechnology?.string, forKey: "commentsOnTechnology")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.commitments?.string, forKey: "commitments")
        
        print(self.managerFeedbackmodel?.grossAnnualSalary)
        managerFeedback.setValue(self.managerFeedbackmodel?.grossAnnualSalary, forKey: "grossAnnualSalary")
        
//        managerFeedback.setValue(NSNumber(double: Double((self.managerFeedbackmodel?.grossAnnualSalary)!)!), forKey: "grossAnnualSalary")
        
        print(self.managerFeedbackmodel?.skillSet)
        

       
        managerFeedback.setValue(NSMutableSet(array: (self.managerFeedbackmodel?.skillSet)!), forKey: "candidateSkills")
        managerFeedback.setValue(self.managerFeedbackmodel?.managerName, forKey: "managerName")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.isCgDeviation, forKey: "isCgDeviation")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.jestificationForHire?.string, forKey: "jestificationForHire")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.modeOfInterview, forKey: "modeOfInterview")
            
        managerFeedback.setValue(NSNumber(short: (self.managerFeedbackmodel?.ratingOnCandidate)!), forKey: "ratingOnCandidate")
        
        managerFeedback.setValue(NSNumber(short: (self.managerFeedbackmodel?.ratingOnTechnical)!), forKey: "ratingOnTechnical")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.recommendation, forKey: "recommendation")
            
        managerFeedback.setValue(self.managerFeedbackmodel?.recommendedCg, forKey: "recommendedCg")

        managerFeedback.setValue(self.managerFeedbackmodel?.designation, forKey: "designation")
        
        managerFeedback.setValue(candidate as Candidate, forKey: "candidate")
        candidate.interviewedByManagers?.setByAddingObject(managerFeedback)
        
        EHCoreDataHelper.saveToCoreData(candidate)
        
        return true
    }
    
    func fetchManagerFeedback()->[AnyObject]{
        
        
        let predicate = NSPredicate(format:"candidate.name = %@", (self.managerFeedbackmodel?.candidate?.name)!)
        
        let managerFeedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "ManagerFeedBack", managedObjectContext: coreDataStack.managedObjectContext)
        
        if managerFeedbackRecords?.count > 0{
        return managerFeedbackRecords as! [AnyObject]
        }
        
        return []
    }
    
    func fetchCandidate()->[Candidate]{
        let predicate = NSPredicate(format:"name = %@ AND interviewDate = %@" , (self.managerFeedbackmodel?.candidate?.name)!,(self.managerFeedbackmodel?.candidate?.interviewDate)!)
        
        let managerFeedbackRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predicate, sortDescriptor: nil, entityName: "Candidate", managedObjectContext: coreDataStack.managedObjectContext)
        
        return managerFeedbackRecords as! [Candidate]
    }
    
    func fetchManagerialFeedback() ->EHManagerialFeedbackModel
    {
        
        
        return self.managerFeedbackmodel!
    }
    

}
