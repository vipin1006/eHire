//
//  CandidateBasicProfessionalInfo+CoreDataProperties.swift
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

extension CandidateBasicProfessionalInfo {

    @NSManaged var primarySkill: String?
    @NSManaged var totalITExperience: NSNumber?
    @NSManaged var companyName: String?
    @NSManaged var currentDesignation: String?
    @NSManaged var currentJobType: String?
    @NSManaged var relevantITExperience: NSNumber?
    @NSManaged var officialEmailId: String?
    @NSManaged var employmentGap: String?
    @NSManaged var fixedSalary: NSNumber?
    @NSManaged var variableSalary: NSNumber?
    @NSManaged var officialNoticePeriod: String?
    @NSManaged var candidate: Candidate?

}
