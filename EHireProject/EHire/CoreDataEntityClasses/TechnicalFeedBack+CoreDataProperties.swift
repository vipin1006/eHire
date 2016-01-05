//
//  TechnicalFeedBack+CoreDataProperties.swift
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

extension TechnicalFeedBack {

    @NSManaged var commentsOnCandidate: String?
    @NSManaged var commentsOnTechnology: String?
    @NSManaged var techLeadName: String?
    @NSManaged var modeOfInterview: String?
    @NSManaged var ratingOnCandidate: NSNumber?
    @NSManaged var ratingOnTechnical: NSNumber?
    @NSManaged var recommendation: String?
    @NSManaged var candidate: Candidate?
    @NSManaged var candidateSkills: NSMutableSet?
    @NSManaged var designation: String?
    @NSManaged var id: NSNumber?
}
