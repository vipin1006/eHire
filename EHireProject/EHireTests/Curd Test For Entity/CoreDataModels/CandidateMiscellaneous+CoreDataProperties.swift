//
//  CandidateMiscellaneous+CoreDataProperties.swift
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

extension CandidateMiscellaneous {

    @NSManaged var anyLeavePlanInSixMonths: NSNumber?
    @NSManaged var anyLegalObligationWithCurrentEmployer: NSNumber?
    @NSManaged var anyPendingBonusFromCurrentEmployer: String?
    @NSManaged var backgroundVerification: NSNumber?
    @NSManaged var businessUnit: String?
    @NSManaged var candidateRequestForRelocation: NSNumber?
    @NSManaged var expectedSalary: NSNumber?
    @NSManaged var interviewedBy: String?
    @NSManaged var joiningPeriod: String?
    @NSManaged var leavePlanInSixMonths: String?
    @NSManaged var legalObligationWithCurrentEmployer: String?
    @NSManaged var reasonForJobChange: String?
    @NSManaged var wasInterviewdBeforeOn: NSDate?
    @NSManaged var wasInterviewedBefore: NSNumber?
    @NSManaged var candidate: Candidate?

}
