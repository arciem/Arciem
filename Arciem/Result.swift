//
//  Result.swift
//  Arciem
//
//  Created by Robert McNally on 1/29/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Value(Box<T>)
    case Error(NSError)
    
    public init(_ value: T) {
        self = .Value(Box(value))
    }
    
    public init(error: NSError) {
        self = .Error(error)
    }
}

extension Result : Printable {
    public var description: String {
        get {
            switch self {
            case .Value(let v):
                return ".Value: \(v.unbox)"
            case .Error(let e):
                return ".Error: \(e.localizedDescription)"
            }
        }
    }
}

// "next"
public func →<A, B>(lhs: Result<A>, rhs:(A) -> B) -> Result<B> {
    switch lhs {
    case .Value(let v):
        return Result(rhs(v.unbox))
    case .Error(let e):
        return .Error(e)
    }
}

// "mutate Result"
public func ¿<A>(lhs: Result<A>, rhs:(Result<A>) -> Result<A>) -> Result<A> {
    return rhs(lhs)
}

// "success"
public func ★<A>(lhs: Result<A>, rhs:(A) -> Void) -> Result<A> {
    switch lhs {
    case .Value(let v):
        rhs(v.unbox)
    default:
        break
    }
    return lhs
}

// "failure"
public func †<T>(lhs: Result<T>, rhs:(NSError) -> Void) -> Result<T> {
    switch lhs {
    case .Error(let error):
        rhs(error)
    default:
        break
    }
    return lhs
}

// "finally"
public func ‡<T>(lhs: Result<T>, rhs:(Result<T>) -> Void) -> Void {
    rhs(lhs)
}

func testResult<T>(results: Result<T>) {
    switch results {
    case .Value(let v) where v.unbox is Void:
        println("Value:Void")
    case .Value(let v):
        println("Value:\(v.unbox)")
    case .Error(let e):
        println("Error:\(e.localizedDescription)")
    }
}

public func testResults() {
    testResult(Result(false))
    testResult(Result(0))
    testResult(Result("Dog"))
    testResult(Result<String?>(nil))
    testResult(Result<String?>("Dog"))
    testResult(Result( () ))
    let e = NSError(domain: "FooDomain", code: 10, userInfo: nil)
    testResult(Result<String>(error: e))
    
    // Prints:
    //    Value:false
    //    Value:0
    //    Value:Dog
    //    Value:nil
    //    Value:Optional("Dog")
    //    Value:Void
    //    Error:The operation couldn’t be completed. (FooDomain error 10.)
}
