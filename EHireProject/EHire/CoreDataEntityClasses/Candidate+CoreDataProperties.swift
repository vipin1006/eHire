//
//  Candidate+CoreDataProperties.swift
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

extension Candidate {

    @NSManaged var experience: NSNumber?
    @NSManaged var interviewDate: NSDate?
    @NSManaged var interviewTime: NSDate?
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var requisition: String?
    @NSManaged var technologyName: String?
    @NSManaged var interviewedByManagers: NSSet?
    @NSManaged var interviewedByTechLeads: NSSet?
    @NSManaged var personalInfo: NSManagedObject?
    @NSManaged var professionalInfo: NSManagedObject?
    @NSManaged var previousEmployment: NSManagedObject?
    @NSManaged var educationQualification: CandidateQualification?
    @NSManaged var miscellaneousInfo: CandidateMiscellaneous?
    @NSManaged var documentDetails: CandidateDocuments?
    @NSManaged var technology: Technology?

}
