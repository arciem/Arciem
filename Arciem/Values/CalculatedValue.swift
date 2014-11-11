//
//  CalculatedValue.swift
//  Arciem
//
//  Created by Robert McNally on 9/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class CalculatedValue<T> /*: Valuable*/ {
    typealias ValueType = T
    var _value : ValueType? = nil
    var i : () -> ValueType
    
    public init(i: () -> ValueType) {
        self.i = i
    }
    
    // conformance to Valuable
    public var value : ValueType {
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
