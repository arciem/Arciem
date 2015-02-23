//
//  Result.swift
//  Arciem
//
//  Created by Robert McNally on 1/29/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum 🎁<🍒> {
    case 😄(📦<🍒>)
    case 😡(NSError)
    
    public init(_ 💌: 🍒) {
        self = .😄(💌⬇️)
    }
    
    public init(🚫: NSError) {
        self = .😡(🚫)
    }
}

extension 🎁: Printable {
    public var description: String {
        get {
            switch self {
            case .😄(let 📫):
                return ".😄: \(📫⬆️)"
            case .😡(let 🚫):
                return ".😡: \(🚫.localizedDescription)"
            }
        }
    }
}

// "next"
public func →<🍒, 🍋>(🅛: 🎁<🍒>, 🅡:(🍒) -> 🍋) -> 🎁<🍋> {
    switch 🅛 {
    case .😄(let 📫):
        return 🎁(🅡(📫⬆️))
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
        🅡(📫⬆️)
    default:
        break
    }
    return 🅛
}

// "failure"
public func †<🍒>(🅛: 🎁<🍒>, 🅡:(NSError) -> Void) -> 🎁<🍒> {
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
    case .😄(let 📫) where 📫⬆️ is Void:
        println("😄:Void")
    case .😄(let 📫):
        println("😄:\(📫⬆️)")
    case .😡(let 🚫):
        println("Error:\(🚫.localizedDescription)")
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
