//
//  HrFeedbackDataAccess.swift
//  EHire
//
//  Created by ajaybabu singineedi on 22/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class HrFeedbackDataAccess: NSObject {
    
    class func saveHrFeedbackForCandidate(candidateInfo:HrFeedBack)->Bool
    {
        do
        {
            try candidateInfo.managedObjectContext?.save()
        }
        catch
        {
            
            return false
        }
        
        return true
    }
    
    class func fetchHrFeedbackForCandidate(candidate:Candidate) -> HrFeedBack
    {
        
        // Here fetching happens.
        
        return HrFeedBack()
        
    }

}
