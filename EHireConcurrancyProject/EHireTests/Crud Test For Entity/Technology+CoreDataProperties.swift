//
//  Technology+CoreDataProperties.swift
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

extension Technology {

    @NSManaged var technologyName: String?
    @NSManaged var candidates: NSSet?
    @NSManaged var interviewDates: NSSet?

}
