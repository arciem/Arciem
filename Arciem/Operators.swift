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

// "successor"
infix operator → { associativity left precedence 170 }

// "failure"
infix operator † { associativity left precedence 170 }

// "finally"
infix operator ‡ { associativity left precedence 170 }

// "operation assign"
infix operator §= { }

// "name assign"
infix operator ¶= { }

// "name extract"
postfix operator ¶ { }

// "value assign"
infix operator ^= { }

// "value extract"
postfix operator ^ { }

// "value equals"
infix operator ^== { precedence 130 }

// "value not equals"
infix operator ^!= { precedence 130 }

//
// Variable and Method Names
//

// "success"
// 😄

// "failure"
// 😡

// "finally"
// 😎
