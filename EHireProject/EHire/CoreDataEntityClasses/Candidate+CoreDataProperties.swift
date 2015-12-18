//
//  Candidate+CoreDataProperties.swift
//  EHire
//
//  Created by ajaybabu singineedi on 18/12/15.
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
    @NSManaged var hr: HrFeedBack?
    @NSManaged var managers: NSSet?
    @NSManaged var techleads: NSSet?

}
