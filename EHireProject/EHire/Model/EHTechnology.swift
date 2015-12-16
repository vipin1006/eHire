//
//  EhireTechnology.swift
//  EHire
//
//  Created by Sudhanshu Saraswat on 09/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import Cocoa

class EHTechnology: NSObject
{
   var technologyName :String
    var interviewDates : [EHInterviewDate] = []

    init(technology : String) {
        technologyName = technology
    }
}
