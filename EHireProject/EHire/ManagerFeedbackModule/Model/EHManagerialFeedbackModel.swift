//
//  ManagerialFeedbackModel.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerialFeedbackModel: NSObject {
      var commentsOnCandidate: String?
      var commentsOnTechnology: String?
      var commitments: String?
      var grossAnnualSalary: NSNumber?
      var managerName: String?
      var isCgDeviation: NSNumber?
      var jestificationForHire: String?
      var modeOfInterview: String?
      var ratingOnCandidate: NSNumber?
      var ratingOnTechnical: NSNumber?
      var recommendation: String?
      var recommendedCg: String?
      var candidate: Candidate?
      var candidateSkills: NSSet?
      var skillSet  = [EHSkillSet]()
    var designation: String?
}
