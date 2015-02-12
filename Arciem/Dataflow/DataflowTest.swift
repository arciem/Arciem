//
//  DataflowTest.swift
//  ArciemTests
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Arciem
import XCTest

var logger = Logger(tag: "TESTS")

class DataflowTest: XCTestCase {
    var expectations = SafeQueue<XCTestExpectation>()
    
    override class func setUp() {
        super.setUp()
        
        logTags.add("TESTS")
        logLevel = .Trace
    }
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testDataflow() {
        func receive(packet: Packet) {
            packet
                ★ { json in
                    logger?.trace("value: \(json.object)")
                    XCTAssert(true) }
                † { error in
                    logger?.trace("error: \(error)")
                    XCTAssert(false) }
                ‡ { _ in
                    self.expectations.remove().fulfill() }
        }
        
        for _ in 1...4 {
            expectations.add(expectationWithDescription("done"))
        }
        
        let paramPort = ParameterPort()

        let resultPort = ResultPort(synchronous: true, receive: receive)

        let negateComponent = NegateComponent()

        paramPort ≈> negateComponent.inPort
        negateComponent.outPort ≈> resultPort
        paramPort ≈> resultPort
        
        paramPort.sendObject(3.14)
        paramPort.sendObject(100)
//        paramPort.sendError(NSError("foobar"))

        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}