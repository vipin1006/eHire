//
//  ManagerialFeedbackModel.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerialFeedbackModel: NSObject {
     dynamic var commentsOnCandidate: NSAttributedString?
      dynamic var commentsOnTechnology: NSAttributedString?
     dynamic var commitments: NSAttributedString?
     dynamic var grossAnnualSalary: String?
     dynamic var managerName: String?
     dynamic var isCgDeviation: NSNumber?
     dynamic var jestificationForHire: NSAttributedString?
     dynamic var modeOfInterview: String?
      var ratingOnCandidate: Int16?
      var ratingOnTechnical: Int16?
     dynamic var recommendation: String?
     dynamic var recommendedCg: String?
      var candidate: EHCandidateDetails?
    var skillSet : [EHSkillSet] = []
   dynamic var designation: String?
    
//     init(candidateDetails:EHCandidateDetails) {
//        self.commentsOnCandidate = ""
//        self.commentsOnTechnology = ""
//        self.commitments = ""
//        self.grossAnnualSalary = 0.0
//        self.managerName = ""
//        self.isCgDeviation = 0
//        self.jestificationForHire = ""
//        self.modeOfInterview = ""
//        self.ratingOnCandidate = 0
//        self.ratingOnTechnical = 0
//        self.recommendation = ""
//        self.recommendedCg = ""
//        self.candidate = candidateDetails
//        self.designation = ""
//    }
}
