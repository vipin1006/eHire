//
//  Employee.swift
//  EXEhireInterView
//
//  Created by Pratibha Sawargi on 11/12/15.
//  Copyright © 2015 Pratibha Sawargi. All rights reserved.
//

import Cocoa

class EHCandidateDetails: NSObject
{
    var name:String
    var experience:String
    var interViewTime:String
    var phoneNum:String
    var interviewDate : NSDate?
    init(inName:String, candidateExperience:String, candidateInterviewTiming:String, candidatePhoneNo:String)
    {
        self.name = inName
        self.experience = candidateExperience
        self.interViewTime = candidateInterviewTiming
        self.phoneNum = candidatePhoneNo
    }
}
