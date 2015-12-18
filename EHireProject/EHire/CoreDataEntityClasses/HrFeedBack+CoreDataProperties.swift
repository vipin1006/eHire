//
//  HrFeedBack+CoreDataProperties.swift
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

extension HrFeedBack {

    @NSManaged var businessUnit: String?
    @NSManaged var currentAnnualSalary: NSData?
    @NSManaged var currentDesignation: String?
    @NSManaged var currentEmployerFromDate: NSDate?
    @NSManaged var currentEmployerName: String?
    @NSManaged var currentEmployerToDate: NSDate?
    @NSManaged var currentJobType: String?
    @NSManaged var currentLocation: String?
    @NSManaged var educationGap: String?
    @NSManaged var emailId: String?
    @NSManaged var employeeGap: String?
    @NSManaged var entitledForAnyBonusFromCurrentEmployer: String?
    @NSManaged var highestEducationFromDate: String?
    @NSManaged var highestEducationPercentage: String?
    @NSManaged var highestEducationQualificationTitle: String?
    @NSManaged var highestEducationToDate: String?
    @NSManaged var highestEducationUniversity: String?
    @NSManaged var interviewedBy: String?
    @NSManaged var isAgreeBackgroundCheck: NSNumber?
    @NSManaged var isAnyLeavePlan: String?
    @NSManaged var isAnyrelocationRequest: NSNumber?
    @NSManaged var isEveryDocumentChecked: NSNumber?
    @NSManaged var isInterviewPast: String?
    @NSManaged var isLegalObligationWithCurrentCompany: NSNumber?
    @NSManaged var isPassportAvailable: NSNumber?
    @NSManaged var joiningPeriod: String?
    @NSManaged var leavePlanReasons: String?
    @NSManaged var legalObligationDetails: String?
    @NSManaged var missingDocumentsList: String?
    @NSManaged var mobile: String?
    @NSManaged var officialNoticePeriod: String?
    @NSManaged var pastInterviewdDate: NSDate?
    @NSManaged var questionsFromCandidate: String?
    @NSManaged var reasonFromJobchange: String?
    @NSManaged var recentDesignation: String?
    @NSManaged var relevantItExperience: NSNumber?
    @NSManaged var totalItExperience: NSNumber?
    @NSManaged var visaTypeAndValidity: String?
    @NSManaged var candidate: Candidate?

}
