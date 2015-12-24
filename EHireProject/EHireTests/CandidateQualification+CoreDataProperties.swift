//
//  CandidateQualification+CoreDataProperties.swift
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

extension CandidateQualification {

    @NSManaged var educationEnd: NSDate?
    @NSManaged var educationGap: String?
    @NSManaged var educationStartFrom: NSDate?
    @NSManaged var highestEducation: String?
    @NSManaged var candidate: Candidate?

}
