//
//  ManagerFeedBack+CoreDataProperties.swift
//  EHire
//
//  Created by ajaybabu singineedi on 23/12/15.
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
    @NSManaged var grossAnnualSalary: NSNumber?
    @NSManaged var managerName: String?
    @NSManaged var isCgDeviation: NSNumber?
    @NSManaged var jestificationForHire: String?
    @NSManaged var modeOfInterview: String?
    @NSManaged var ratingOnCandidate: NSNumber?
    @NSManaged var ratingOnTechnical: NSNumber?
    @NSManaged var recommendation: String?
    @NSManaged var recommendedCg: String?
    @NSManaged var candidate: Candidate?
    @NSManaged var candidateSkills: NSSet?
    @NSManaged var designation: String?
}
