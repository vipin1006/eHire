//
//  CandidateQualification+CoreDataProperties.swift
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

extension CandidateQualification {

    @NSManaged var highestEducation: String?
    @NSManaged var educationStartFrom: NSDate?
    @NSManaged var educationEnd: NSDate?
    @NSManaged var educationGap: String?
    @NSManaged var university:String?
    @NSManaged var percentage:NSNumber?
    @NSManaged var candidate: Candidate?

}
