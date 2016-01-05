//
//  EHTechnologyViewController.swift
//  EHire
//  This class is used to writing test cases for EHTechnologyViewController
//  Created by padalingam agasthian on 04/01/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import XCTest

@testable import EHire

class EHTechnologyTestViewController: XCTestCase
{
    var technologyViewController : EHTechnologyViewController!
    let storyBoard = NSStoryboard(name: "Main", bundle: nil)
    
    //MARK:- Overridden Methods
    
    override func setUp()
    {
        super.setUp()
         technologyViewController = storyBoard.instantiateControllerWithIdentifier("mainView") as? EHTechnologyViewController
        technologyViewController.performSelectorOnMainThread(Selector("loadView"), withObject: nil, waitUntilDone: true)
        XCTAssertNotNil(technologyViewController, "Technology View Controller is not created")
    }
    
    func testThatViewLoads()
    {
    XCTAssertNotNil(technologyViewController.view, "View not initiated properly");
    }
    
    override func tearDown()
    {
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
