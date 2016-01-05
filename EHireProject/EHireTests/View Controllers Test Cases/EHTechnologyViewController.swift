//
//  EHTechnologyViewController.swift
//  EHire
//  This class is used to writing test cases for EHTechnologyViewController
//  Created by padalingam agasthian on 04/01/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import XCTest

class EHTechnologyViewController: XCTestCase
{
    //MARK:- Overridden Methods
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //MARK:- Performance Test
    func testPerformanceExample()
    {
        @IBOutlet weak var addDate: NSButton!
        // This is an example of a performance test case.
        self.measureBlock
        {
            // Put the code you want to measure the time of here.
        }
    }

}
