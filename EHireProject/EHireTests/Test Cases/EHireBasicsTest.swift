//
//  EHireBasicsTest.swift
//  EHire
//  This class is used to write a test cases needed for the ehire basic stuff 
//  Created by padalingam agasthian on 24/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import XCTest

@testable import EHire

class EHireBasicsTest: XCTestCase
{
    //MARK: - Overridden Methods
    
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
    
    //MARK: - Basics Test
    
    func testAppDelegate()
    {
        let appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate
        XCTAssertNotNil(appDelegate, "Appdelegate is not created")
    }
    
    func testStoryBoard()
    {
        
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        let mainWindowController = storyBoard.instantiateControllerWithIdentifier("MainWindowController")
        XCTAssertNotNil(mainWindowController, "Main Story Board is not created")
    }

    //MARK: - Performance Test
    
    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock
        {
            // Put the code you want to measure the time of here.
        }
    }

}
