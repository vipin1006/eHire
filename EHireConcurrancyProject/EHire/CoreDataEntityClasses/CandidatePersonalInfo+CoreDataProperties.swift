//
//  CandidatePersonalInfo+CoreDataProperties.swift
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

extension CandidatePersonalInfo {

    @NSManaged var candidateName: String?
    @NSManaged var candidateMobile: String?
    @NSManaged var currentLocation: String?
    @NSManaged var passport: NSNumber?
    @NSManaged var visaTypeAndValidity: String?
    @NSManaged var candidate: Candidate?

}
