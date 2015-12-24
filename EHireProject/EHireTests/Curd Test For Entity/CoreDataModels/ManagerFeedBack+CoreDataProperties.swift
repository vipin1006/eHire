//
//  ManagerFeedBack+CoreDataProperties.swift
//  EHire
//
//  Created by padalingam agasthian on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ManagerFeedBack {

    @NSManaged var commentsOnCandidate: String?
    @NSManaged var commentsOnTechnology: String?
    @NSManaged var commitments: String?
    @NSManaged var designation: String?
    @NSManaged var grossAnnualSalary: NSNumber?
    @NSManaged var isCgDeviation: NSNumber?
    @NSManaged var jestificationForHire: String?
    @NSManaged var managerName: String?
    @NSManaged var modeOfInterview: String?
    @NSManaged var ratingOnCandidate: NSNumber?
    @NSManaged var ratingOnTechnical: NSNumber?
    @NSManaged var recommendation: String?
    @NSManaged var recommendedCg: String?
    @NSManaged var candidate: Candidate?
    @NSManaged var candidateSkills: NSSet?

}
