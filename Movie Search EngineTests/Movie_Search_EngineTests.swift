//
//  Movie_Search_EngineTests.swift
//  Movie Search EngineTests
//
//  Created by Deekshitha Thumma on 5/17/18.
//  Copyright © 2018 Deekshitha Thumma. All rights reserved.
//

import XCTest
@testable import Movie_Search_Engine

class Movie_Search_EngineTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSearchBarVisible() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ViewController
        let _ = vc.view
        XCTAssert(!vc.searchTextField.isHidden)
    }
    
    func testSearchBarPlaceholder()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ViewController
        let _ = vc.view
        XCTAssertEqual("Search", vc.searchTextField.placeholder)
        
    }
    
    func testSearchBarHitEnter()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ViewController
        let _ = vc.view
        vc.searchTextField.text = "Harry Potter"
        XCTAssert(vc.searchTextField.hasText)

    }
    
    func testISearchTime()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ViewController
        let _ = vc.view
        let maxTime = 20
        vc.searchAPI(term: "cat")
        sleep(UInt32(maxTime))
        XCTAssertEqual("Cat People", vc.movies[0][0])
        
    }
    
}
