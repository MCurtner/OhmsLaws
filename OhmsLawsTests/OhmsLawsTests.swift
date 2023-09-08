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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testOhms() {
        let oc = OhmsController(object: Ohms(volts: nil, amps: 5, ohms: 4, watts: nil))
        let c = oc.calculate()
        
        XCTAssertEqual(c?.volts?.roundToDecimal(0), 20)
        XCTAssertEqual(c?.amps?.roundToDecimal(0), 5)
        XCTAssertEqual(c?.ohms?.roundToDecimal(0), 4)
        XCTAssertEqual(c?.watts?.roundToDecimal(0), 100)
    }
    
    func testOhms3() {
        let oc = OhmsController(object: Ohms(volts: nil, amps: nil, ohms: 0.555, watts: 0.256))
        let c = oc.calculate()
        
        XCTAssertEqual(c?.volts?.roundToDecimal(3), 0.377)
        XCTAssertEqual(c?.amps?.roundToDecimal(3), 0.679)
        XCTAssertEqual(c?.ohms?.roundToDecimal(3), 0.555)
        XCTAssertEqual(c?.watts?.roundToDecimal(3), 0.256)
    }
    
    func testOhms4() {
        let oc = OhmsController(object: Ohms(volts: 0.256, amps: 0.555, ohms: nil, watts: nil))
        let c = oc.calculate()
        
        XCTAssertEqual(c?.volts?.roundToDecimal(4), 0.256)
        XCTAssertEqual(c?.amps?.roundToDecimal(4), 0.555)
        XCTAssertEqual(c?.ohms?.roundToDecimal(4), 0.4613)
        XCTAssertEqual(c?.watts?.roundToDecimal(4), 0.1421)
    }
    
    func testOhms5() {
        let oc = OhmsController(object: Ohms(volts: 0.256, amps: 0.555, ohms: nil, watts: nil))
        let c = oc.calculate()
        
        XCTAssertEqual(c?.volts?.roundToDecimal(5), 0.256)
        XCTAssertEqual(c?.amps?.roundToDecimal(5), 0.555)
        XCTAssertEqual(c?.ohms?.roundToDecimal(5), 0.46126)
        XCTAssertEqual(c?.watts?.roundToDecimal(5), 0.14208)
    }
    
}
