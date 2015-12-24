//
//  Candidate+CoreDataProperties.swift
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

extension Candidate {

    @NSManaged var interviewDate: NSDate?
    @NSManaged var interviewTime: NSDate?
    @NSManaged var name: String?
    @NSManaged var requisition: String?
    @NSManaged var technologyName: String?
    @NSManaged var documentDetails: CandidateDocuments?
    @NSManaged var educationQualification: CandidateQualification?
    @NSManaged var interviewedByManagers: NSSet?
    @NSManaged var interviewedByTechLeads: NSSet?
    @NSManaged var miscellaneousInfo: CandidateMiscellaneous?
    @NSManaged var personalInfo: CandidatePersonalInfo?
    @NSManaged var previousEmployment: CandidatePreviousEmploymentInfo?
    @NSManaged var professionalInfo: CandidateBasicProfessionalInfo?
    @NSManaged var technology: Technology?

}
