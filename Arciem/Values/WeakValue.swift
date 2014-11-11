//
//  WeakValue.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct WeakValue<T: AnyObject> /*: Valuable*/ {
    typealias ValueType = T?
    weak public var value: ValueType
    
    init(_ value: ValueType) {
        self.value = value
    }
}
