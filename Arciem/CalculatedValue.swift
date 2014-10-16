//
//  CalculatedValue.swift
//  Arciem
//
//  Created by Robert McNally on 9/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation
import CoreGraphics

public class CalculatedValue<T> : Valuable {
    var _value : T? = nil
    var i : () -> T
    
    public init(i: () -> T) {
        self.i = i
    }
    
    // conformance to Valuable
    public var value : T {
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
