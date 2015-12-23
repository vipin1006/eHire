//
//  EHCandidateDataAccessLayer.swift
//  EHire
//
//  Created by Pratibha Sawargi on 23/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHCandidateDataAccessLayer: NSObject
{
   class func saveCandidateInformation(information:Candidate) -> Bool
    {
    
      do
       {
          try information.managedObjectContext?.save()
        
       }
        
       catch
        {
        
          return false
       }
    return true
    }

}
