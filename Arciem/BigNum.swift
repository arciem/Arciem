//
//  BigNum.swift
//  Arciem
//
//  Created by Robert McNally on 8/13/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

// Should be class constant, not yet supported in Swift
private let digitChars = Array("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

public struct BigNum {
    public let radix: Int // 2 for binary, 10 for decimal, 16 for hexadecimal, etc.
    public let digits: [Int] // least-significant digit first
    public let decimalIndex: Int // number of digits to right of decimal point
    public let leastSignificantPosition: Int
    public let mostSignificantPosition: Int
    public let negative: Bool // True if number is negative
    
    public init(digits: [Int], decimalIndex: Int, negative: Bool, radix: Int = 10) {
        assert(radix >= 2, "Radix must be at least 2")
        
        for digit in digits {
            assert(digit < radix, "Every digit must be less than the radix")
        }
        
        var blankedDigits = digits
        while blankedDigits.last == 0 {
            blankedDigits.removeLast()
        }
        self.digits = blankedDigits
        self.decimalIndex = decimalIndex
        self.leastSignificantPosition = -decimalIndex
        self.mostSignificantPosition = self.digits.count - decimalIndex - 1
        self.negative = negative
        self.radix = radix
    }
    
    public init(_ value: Int64, radix: Int = 10) {
        assert(radix >= 2, "Radix must be at least 2")
        
        let radix64 = Int64(radix)
        
        var digits = [Int]()
        var remaining = value
        let negative = value < 0
        if negative {
            remaining = -remaining
        }
        while remaining > 0 {
            let digit = remaining % radix64
            digits.append(Int(digit))
            remaining /= radix64
        }
        self.init(digits: digits, decimalIndex: 0, negative: negative, radix: radix)
    }
    
    public init(_ value: Int, radix: Int = 10) {
        self.init(Int64(value), radix: radix)
    }
    
    //    public toRadix(radix: Int) -> Self {
    //
    //    }
    
    func digitAtPosition(position: Int) -> Int {
        var result: Int
        let digitsArrayIndex = position - self.leastSignificantPosition
        switch digitsArrayIndex {
        case digitsArrayIndex where digitsArrayIndex < 0, digitsArrayIndex where digitsArrayIndex >= digits.count:
            result = 0
        default:
            result = digits[digitsArrayIndex]
        }
        return result
    }
    
    public static func add(#lhs: BigNum, rhs: BigNum) -> BigNum {
        assert(lhs.radix == rhs.radix, "Radices must be the same.")
        
        let radix = lhs.radix
        
        let lsp = min(lhs.leastSignificantPosition, rhs.leastSignificantPosition)
        let msp = max(lhs.mostSignificantPosition, rhs.mostSignificantPosition)
        
        var resultDigits = [Int]()
        var carry = 0
        for position in lsp...msp {
            let lhsDigit = lhs.digitAtPosition(position)
            println("\nlhsDigit:\(lhsDigit)")
            let rhsDigit = rhs.digitAtPosition(position)
            println("rhsDigit:\(rhsDigit)")
            let lhsSignedDigit = lhs.negative ? -lhsDigit : lhsDigit
            println("lhsSignedDigit:\(lhsSignedDigit)")
            let rhsSignedDigit = rhs.negative ? -rhsDigit : rhsDigit
            println("rhsSignedDigit:\(rhsSignedDigit)")
            let accum = lhsSignedDigit + rhsSignedDigit + carry
            println("accum:\(accum)")
            let resultDigit = carry % radix
            println("resultDigit:\(resultDigit)")
            resultDigits.append(resultDigit)
            println("resultDigits:\(resultDigits)")
            carry = accum / radix
            println("carry:\(carry)")
        }
        if(carry > 0) {
            resultDigits.append(carry)
        }
        return BigNum(digits: resultDigits, decimalIndex: -lsp, negative: lhs.negative, radix: radix)
    }
    
    public static func negate(#rhs: BigNum) -> BigNum {
        return BigNum(digits: rhs.digits, decimalIndex: rhs.decimalIndex, negative: !rhs.negative, radix: rhs.radix)
    }
    
    public func add(rhs: BigNum) -> BigNum {
        return BigNum.add(lhs: self, rhs: rhs)
    }
    
    public func toString(leadingPlaces: Int? = nil, trailingPlaces: Int? = nil, blankLeadingZeros: Bool = true, blankMinusSign: Bool = true) -> String {
        assert(self.radix <= digitChars.count, "Radix too large to convert to digits.")
        let lsp = min(self.leastSignificantPosition, trailingPlaces == nil ? 0 : -trailingPlaces!)
        let msp = max(max(self.mostSignificantPosition, 0), leadingPlaces == nil ? 0 : leadingPlaces! - 1)

        var chars = [String]()
        for position in lsp...msp {
            if(position == 0) {
                chars.append(".")
            }
            let digit = self.digitAtPosition(position)
            var s = String(digitChars[digit])
            if blankLeadingZeros {
                if position > self.mostSignificantPosition {
                    s = " "
                }
            }
            chars.append(s)
        }

        chars = reverse(chars)
        if negative {
            chars.insert("-", atIndex: 0)
        } else if blankMinusSign {
            chars.insert(" ", atIndex: 0)
        }
        
        return join("", chars)
    }
}

extension BigNum : Printable {
    public var description: String {
        get {
            var digitStrings: [String] = map(digits, { return "\($0)" } )
            digitStrings.insert(".", atIndex: decimalIndex)
            digitStrings = reverse(digitStrings)
            digitStrings.append("(\(radix))")
            if(negative) {
                digitStrings.insert("-", atIndex: 0)
            }
            let s = join(" ", digitStrings)
            return "BigNum:[\(s)]"
        }
    }
}

extension BigNum : IntegerLiteralConvertible {
    public typealias IntegerLiteralType = Int64
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Int64(value))
    }
}

public func + (lhs: BigNum, rhs: BigNum) -> BigNum {
    return BigNum.add(lhs: lhs, rhs: rhs)
}

public prefix func - (rhs: BigNum) -> BigNum {
    return BigNum.negate(rhs: rhs)
}

public func testBigNum() {
//    let a = BigNum(digits: [1, 1, 1, 1, 1, 0], decimalIndex: 1, negative: false, radix: 2)
//    let b = BigNum(digits: [1], decimalIndex: 0, negative: false, radix: 2)
    let a: BigNum = 999
    let b: BigNum = 888
    let c = a + b
    let d = -c
    
    let leadingPlaces: Int? = 7
    let trailingPlaces: Int? = 2
    println("a:\(a.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
    println("b:\(b.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
    println("c:\(c.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
    println("d:\(d.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
}