//
//  DataflowTests.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import XCTest
import Arciem
import Foundation

private var logger = Logger(tag: "DFTESTS")

class DataflowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        logTags.insert("DFTESTS")
        logLevel = .Trace
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    #if os(iOS)
    func test1() {
        var expectations = SafeQueue<XCTestExpectation>()

        var comp = Component(name: "Test1")
        let producer🅒 = ProducerⒸ<String>("StringProducer", comp)
        let reachability🅒 = ReachabilityⒸ("Reachability", comp, hostname: "google.com")
        let logger🅒 = LoggerⒸ("Logger", comp)
        let consumer🅒 = ConsumerⒸ<String>("Consumer", comp) { _ in expectations.remove().fulfill() }
        
        producer🅒.out🅟 +> logger🅒.inString🅟
        producer🅒.out🅟 +> consumer🅒.in🅟
        reachability🅒.outString🅟 +> logger🅒.inString🅟

        for i in 1...100 {
            expectations.add(expectationWithDescription("\(i)"))
            producer🅒.send("Hello, world! \(i)")
        }
        reachability🅒.enabled = true
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    #endif
}

public class DFNegJSONComponent<A>: DFTransform🎁Ⓒ<JSON, JSON> {
    public init(_ component: Component) {
        super.init(nil, component, transform: { 🅥 in
            switch 🅥 {
            case .😄(let 📫):
                if let n = 📫.numberValue {
                    return 🎁(JSON(-n))
                } else {
                    return .😡(NSError("not a number: \(📫)"))
                }
            default:
                return 🅥
            }
        })
    }
}

public class DFNegFloatComponent<A>: DFTransform🎁Ⓒ<Float, Float> {
    public init(_ component: Component) {
        let transform: TransformⓉ = { 🅥 in
            switch 🅥 {
            case .😄(let 📫):
                return 🎁(-📫)
            default:
                return 🅥
            }
        }
        super.init(nil, component, transform: transform)
    }
}

public typealias DFNegateComponent = DFNegJSONComponent<JSON>
