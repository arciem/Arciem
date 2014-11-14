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

public func ⁂<A, B>(lhs: A, rhs: B) -> A {
    return lhs
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
