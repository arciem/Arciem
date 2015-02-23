//
//  CheckedValue.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public typealias CheckBlock = () -> Bool

//public class CheckedValue<🍒> /*: Valuable*/ {
//    typealias 🍋 = 🍒?
//    var _value : 🍋 = nil
//    var setCheck : CheckBlock
//    
//    public init(_ setCheck: CheckBlock) {
//        self.setCheck = setCheck
//    }
//    
//    // conformance to Valuable
//    public var value : 🍋 {
//        get {
//            return _value
//        }
//        set {
//            assert(setCheck(), "CheckedValue failed setCheck")
//            _value = newValue
//        }
//    }
//}
