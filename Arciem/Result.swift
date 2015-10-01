//
//  Result.swift
//  Arciem
//
//  Created by Robert McNally on 1/29/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum 🎁<🍒> {
    case 😄(🍒)
    case 😡(ErrorType)
    
    public init(_ 💌: 🍒) {
        self = .😄(💌)
    }
    
    public init(🚫: ErrorType) {
        self = .😡(🚫)
    }
}

extension 🎁: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .😄(let 📫):
                return ".😄: \(📫)"
            case .😡(let 🚫):
                return ".😡: \(🚫)"
            }
        }
    }
}

// "next"
public func →<🍒, 🍋>(🅛: 🎁<🍒>, 🅡:(🍒) -> 🍋) -> 🎁<🍋> {
    switch 🅛 {
    case .😄(let 📫):
        return 🎁(🅡(📫))
    case .😡(let 🚫):
        return .😡(🚫)
    }
}

// "mutate 🎁"
public func ¿<🍒>(🅛: 🎁<🍒>, 🅡:(🎁<🍒>) -> 🎁<🍒>) -> 🎁<🍒> {
    return 🅡(🅛)
}

// "success"
public func ★<🍒>(🅛: 🎁<🍒>, 🅡:(🍒) -> Void) -> 🎁<🍒> {
    switch 🅛 {
    case .😄(let 📫):
        🅡(📫)
    default:
        break
    }
    return 🅛
}

// "failure"
public func †<🍒>(🅛: 🎁<🍒>, 🅡:(ErrorType) -> Void) -> 🎁<🍒> {
    switch 🅛 {
    case .😡(let 🚫):
        🅡(🚫)
    default:
        break
    }
    return 🅛
}

// "finally"
public func ‡<🍒>(🅛: 🎁<🍒>, 🅡:() -> Void) -> Void {
    🅡()
}

func testResult<🍒>(results: 🎁<🍒>) {
    switch results {
    case .😄(let 📫) where 📫 is Void:
        print("😄:Void")
    case .😄(let 📫):
        print("😄:\(📫)")
    case .😡(let 🚫):
        print("Error:\(🚫)")
    }
}

public func testResults() {
    testResult(🎁(false))
    testResult(🎁(0))
    testResult(🎁("Dog"))
    testResult(🎁<String?>(nil))
    testResult(🎁<String?>("Dog"))
    testResult(🎁( () ))
    let 🚫 = NSError(domain: "FooDomain", code: 10, userInfo: nil)
    testResult(🎁<String>(🚫: 🚫))
    
    // Prints:
    //    😄:false
    //    😄:0
    //    😄:Dog
    //    😄:nil
    //    😄:Optional("Dog")
    //    😄:Void
    //    Error:The operation couldn’t be completed. (FooDomain error 10.)
}
