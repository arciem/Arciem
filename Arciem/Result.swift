//
//  Result.swift
//  Arciem
//
//  Created by Robert McNally on 1/29/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum Result<T> {
    case None
    case Value(Box<T>)
    case Error(NSError)
    
    public init() {
        self = .None
    }
    
    public init(value: T) {
        self = .Value(Box(value))
    }
    
    public init(error: NSError) {
        self = .Error(error)
    }
}

extension Result : Printable {
    public var description: String {
        get { switch self {
        case .None:
            return ".None"
        case .Value(let v):
            return ".Value(\(v.unbox))"
        case .Error(let e):
            return ".Error(\(e.localizedDescription))"
            }
        }
    }
}

func testResult<T>(results: Result<T>) {
    switch results {
    case .None:
        println("None")
    case .Value(let v) where v.unbox is Void:
        println("Value:Void")
    case .Value(let v):
        println("Value:\(v.unbox)")
    case .Error(let e):
        println("Error:\(e.localizedDescription)")
    }
}

public func testResults() {
    testResult(Result<Int>())
    testResult(Result(value: false))
    testResult(Result(value: 0))
    testResult(Result(value: "Dog"))
    testResult(Result<String?>(value: nil))
    testResult(Result<String?>(value: "Dog"))
    testResult(Result(value: () ))
    let e = NSError(domain: "FooDomain", code: 10, userInfo: nil)
    testResult(Result<String>(error: e))
    
// Prints:
//    None
//    Value:false
//    Value:0
//    Value:Dog
//    Value:nil
//    Value:Optional("Dog")
//    Value:Void
}
