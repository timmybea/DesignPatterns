//
//  SingletonTests.swift
//  SingletonTests
//
//  Created by Tim Beals on 2018-02-14.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import XCTest
@testable import Singleton

class SingletonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func test_ConfigurableRecordFinder_PopulationTest() {
        let cities = ["alpha", "beta", "gamma"]
        let db = DummyDataBase()
        
        let rf = ConfigurableRecordFinder(db) //put in dummy database...
        let tp = rf.totalPopulation(for: cities)
        XCTAssertEqual(6, tp, "Total population failed")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
