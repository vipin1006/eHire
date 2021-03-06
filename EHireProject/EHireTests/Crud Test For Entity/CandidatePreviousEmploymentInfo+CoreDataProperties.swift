//
//  CandidatePreviousEmploymentInfo+CoreDataProperties.swift
//  EHire
//
//  Created by padalingam agasthian on 28/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CandidatePreviousEmploymentInfo {

    @NSManaged var employmentEnd: NSDate?
    @NSManaged var employmentStartsFrom: NSDate?
    @NSManaged var previousCompany: String?
    @NSManaged var previousCompanyDesignation: String?
    @NSManaged var candidate: Candidate?

}
