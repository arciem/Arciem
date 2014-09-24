//
//  CalculatedValue.swift
//  Arciem
//
//  Created by Robert McNally on 9/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation
import CoreGraphics

public class CalculatedValue<T> {
    var _value : T? = nil
    var i : () -> T
    
    public init(i: () -> T) {
        self.i = i
    }
    
    public var value : T {
        get {
            if _value == nil {
                _value = i()
            }

            return _value!
        }
    }
    
    public func reset() {
        _value = nil
    }
}
