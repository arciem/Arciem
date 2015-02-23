//
//  CalculatedValue.swift
//  Arciem
//
//  Created by Robert McNally on 9/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class CalculatedValue<🍒> /*: Valuable*/ {
    var _value : 🍒? = nil
    var i : () -> 🍒
    
    public init(i: () -> 🍒) {
        self.i = i
    }
    
    // conformance to Valuable
    public var value : 🍒 {
        get {
            if _value == nil {
                _value = i()
            }

            return _value!
        }
        set {
            _value = newValue
        }
    }
    
    public func reset() {
        _value = nil
    }
}
