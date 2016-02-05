//
//  CandidateMiscellaneous+CoreDataProperties.swift
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

extension CandidateMiscellaneous {

    @NSManaged var businessUnit: String?
    @NSManaged var leavePlanInSixMonths: String?
    @NSManaged var candidateRequestForRelocation: NSNumber?
    @NSManaged var reasonForJobChange: String?
    @NSManaged var backgroundVerification: NSNumber?
    @NSManaged var expectedSalary: NSNumber?
    @NSManaged var joiningPeriod: NSDate?
    @NSManaged var interviewedBy: String?
    @NSManaged var wasInterviewedBefore: NSNumber?
    @NSManaged var wasInterviewdBeforeOn: NSDate?
    @NSManaged var anyLeavePlanInSixMonths: NSNumber?
    @NSManaged var anyPendingBonusFromCurrentEmployer: String?
    @NSManaged var anyLegalObligationWithCurrentEmployer: NSNumber?
    @NSManaged var legalObligationWithCurrentEmployer: String?
    @NSManaged var questionsByCandidate:String?
    @NSManaged var isHrFormSubmitted:NSNumber?
    @NSManaged var isHrFormSaved:NSNumber?
    @NSManaged var candidate: Candidate?

}
