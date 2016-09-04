//
//  OhmsLawsTests.swift
//  OhmsLawsTests
//
//  Created by Matthew Curtner on 9/3/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import XCTest
@testable import OhmsLaws

class OhmsLawsTests: XCTestCase {
    
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = ViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testCalcVoltage() {
        XCTAssertEqual(vc.calculateVoltage(amp: 10, resistance: 150), 1500.0)
        XCTAssertEqual(vc.calculateVoltage(amps: 10, power: 2), 0.2)
        XCTAssertEqual(vc.calculateVoltage(power: 2, resistance: 10), 4.47214)
    }
    
    func testAmps() {
        XCTAssertEqual(vc.calculateAmps(voltage: 150, resistance: 10), 15.0)
        XCTAssertEqual(vc.calculateAmps(voltage: 250, resistance: 44), 5.68182)
    }
    
    func testWatts() {
        XCTAssertEqual(vc.calculateWatts(voltage: 150, resistance: 10), 2250.0)
    }
}
