//
//  Valuable.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public protocol Valuable {
    typealias ValueType
    var value : ValueType { get set }
}

infix operator =^ { }
postfix operator ^ { }

public func =^ <V: Valuable> (inout left: V, right: V.ValueType) {
    left.value = right
}

public func =^ <V: Valuable> (inout left: V.ValueType, right: V) {
    left = right.value
}

public postfix func ^ <V: Valuable> (left: V) -> V.ValueType {
    return left.value
}
