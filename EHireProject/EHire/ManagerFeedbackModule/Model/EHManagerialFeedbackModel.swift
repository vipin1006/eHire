//
//  ManagerialFeedbackModel.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerialFeedbackModel: NSObject {
      var commentsOnCandidate: NSAttributedString?
      var commentsOnTechnology: NSAttributedString?
      var commitments: NSAttributedString?
      var grossAnnualSalary: String?
      var managerName: String?
      var isCgDeviation: NSNumber?
      var jestificationForHire: NSAttributedString?
      var modeOfInterview: String?
      var ratingOnCandidate: Int16?
      var ratingOnTechnical: Int16?
      var recommendation: String?
      var recommendedCg: String?
      var candidate: EHCandidateDetails?
    var skillSet : [EHSkillSet] = []
    var designation: String?
    
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
