//
//  PicShareUITests.swift
//  PicShareUITests
//
//  Created by James Valaitis on 25/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import XCTest

//	MARK: PicShare UI Tests

class PicShareUITests: XCTestCase {
    
    //	MARK: Set Up
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //	MARK: Test Navigation
    
    func testNavigationToPhoto() {
        let app = XCUIApplication()
        
        app.tables["Users"].cells.elementBoundByIndex(0).tap()
        let albumCell = app.tables["Photo Albums"].cells.elementBoundByIndex(0)
        waitFor(albumCell, seconds: 5.0)
        albumCell.tap()
        let photoCell = app.collectionViews["Photos"].cells.elementBoundByIndex(0)
        waitFor(photoCell, seconds: 5.0)
        photoCell.tap()
    }
    
    func waitFor(element:XCUIElement, seconds waitSeconds:Double) {
            let exists = NSPredicate(format: "exists == 1")
            expectationForPredicate(exists, evaluatedWithObject: element, handler: nil)
            waitForExpectationsWithTimeout(waitSeconds, handler: nil)
    }
}