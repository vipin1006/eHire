//
//  EHTechnicalFeedbackModel.swift
//  EHire
//
//  Created by Tharani P on 29/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnicalFeedbackModel: NSObject
{
    var commentsOnCandidate: String?
    var commentsOnTechnology: String?
    var techLeadName: String?
    var modeOfInterview: String?
    var ratingOnCandidate: Int32?
    var ratingOnTechnical: Int32?
    var recommendation: String?
    var candidate: Candidate?
    var skills : [SkillSet]?
    var isFeedbackSubmitted:NSNumber = 0
    var designation: String?
}
