//
//  ManagerialFeedbackModel.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHManagerialFeedbackModel: NSObject
{
      var id : Int16?
      var commentsOnCandidate: NSAttributedString?
      var commentsOnTechnology: NSAttributedString?
      var commitments: NSAttributedString?
      var grossAnnualSalary: NSNumber?
      var managerName: String?
      var isCgDeviation: NSNumber?
      var jestificationForHire: NSAttributedString?
      var modeOfInterview: String?
      var ratingOnCandidate: Int16?
      var ratingOnTechnical: Int16?
      var recommendation: String?
      var recommendedCg: String?
      var candidate: Candidate?
      var skillSet : [SkillSet] = []
      var designation: String?
      var isSubmitted: NSNumber?
}
