//
//  Operators.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

//
// This file declares things like glyphic operators and Emoji variable and method names used throughout this module.
//
// I don't care what you think about Emoji. I like it.
// It's a shame that Swift doesn't currently allow operator declarations to use Emoji.
//

//
// Operators
//

// "new"
prefix operator • { }

// "name extract"
postfix operator ¶ { }

// "value extract"
postfix operator ^ { }

// "value equals"
infix operator ^== { precedence 130 }

// "value not equals"
infix operator ^!= { precedence 130 }

// "successor"
infix operator → { associativity left precedence 170 }

// "failure"
infix operator † { associativity left precedence 170 }

// "finally"
infix operator ‡ { associativity left precedence 170 }

// "chaining"
infix operator ⁂ { associativity left precedence 108 }

// "operation assign"
infix operator §= { associativity left precedence 105 }

// "name assign"
infix operator ¶= { associativity left precedence 105 }

// "value assign"
infix operator ^= { associativity left precedence 105 }

// "layout attribute must equal"
infix operator ==⦿ { }

// "layout attribute must be greater than or equal to"
infix operator >=⦿ { }

// "layout attribute must be less than or equal to"
infix operator <=⦿ { }

// "priority assign"
infix operator =⦿= { associativity left precedence 95 }

public func ⁂<A, B>(lhs: A, rhs: B) -> A {
    return lhs
}

// "rightward assign"
infix operator => { associativity right precedence 95 }

public func =><T>(lhs:T, inout rhs:T) {
    rhs = lhs
}

//
// Variable and Method Names
//

// "success"
// 😄

// "failure"
// 😡

// "finally"
// 😎
