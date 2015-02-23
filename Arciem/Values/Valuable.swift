//
//  Valuable.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

//public protocol Valuable {
//    typealias ValueType
//    var value : ValueType { get set }
//}

//// "value assign"
//public func ^= <V: Valuable>(inout 🅛: V, 🅡: V.ValueType) -> V {
//    🅛.value = 🅡
//    return 🅛
//}
//
//// "value extract"
//public postfix func ^ <V: Valuable>(🅛: V) -> V.ValueType? {
//    return 🅛.value
//}
//
//// "value equals"
//public func ^== <V: Valuable where V.ValueType: Equatable> (left: V, right: V.ValueType) -> Bool {
//    return left^ == right
//}
//
//// "value not equals"
//public func ^!= <V: Valuable where V.ValueType: Equatable> (left: V, right: V.ValueType) -> Bool {
//    return !(left ^== right)
//}
