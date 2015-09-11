//
//  BigNum.swift
//  Arciem
//
//  Created by Robert McNally on 8/13/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

// Should be class constant, not yet supported in Swift
private let digitChars = Array(arrayLiteral: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

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
    
    public static func add(🅛 🅛: BigNum, 🅡: BigNum) -> BigNum {
        assert(🅛.radix == 🅡.radix, "Radices must be the same.")
        
        let radix = 🅛.radix
        
        let lsp = min(🅛.leastSignificantPosition, 🅡.leastSignificantPosition)
        let msp = max(🅛.mostSignificantPosition, 🅡.mostSignificantPosition)
        
        var resultDigits = [Int]()
        var carry = 0
        for position in lsp...msp {
            let lhsDigit = 🅛.digitAtPosition(position)
            print("\nlhsDigit:\(lhsDigit)")
            let rhsDigit = 🅡.digitAtPosition(position)
            print("rhsDigit:\(rhsDigit)")
            let lhsSignedDigit = 🅛.negative ? -lhsDigit : lhsDigit
            print("lhsSignedDigit:\(lhsSignedDigit)")
            let rhsSignedDigit = 🅡.negative ? -rhsDigit : rhsDigit
            print("rhsSignedDigit:\(rhsSignedDigit)")
            let accum = lhsSignedDigit + rhsSignedDigit + carry
            print("accum:\(accum)")
            let resultDigit = carry % radix
            print("resultDigit:\(resultDigit)")
            resultDigits.append(resultDigit)
            print("resultDigits:\(resultDigits)")
            carry = accum / radix
            print("carry:\(carry)")
        }
        if(carry > 0) {
            resultDigits.append(carry)
        }
        return BigNum(digits: resultDigits, decimalIndex: -lsp, negative: 🅛.negative, radix: radix)
    }
    
    public static func negate(🅡 🅡: BigNum) -> BigNum {
        return BigNum(digits: 🅡.digits, decimalIndex: 🅡.decimalIndex, negative: !🅡.negative, radix: 🅡.radix)
    }
    
    public func add(🅡: BigNum) -> BigNum {
        return BigNum.add(🅛: self, 🅡: 🅡)
    }
    
    public func toString(leadingPlaces leadingPlaces: Int? = nil, trailingPlaces: Int? = nil, blankLeadingZeros: Bool = true, blankMinusSign: Bool = true) -> String {
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

        chars = chars.reverse()
        if negative {
            chars.insert("-", atIndex: 0)
        } else if blankMinusSign {
            chars.insert(" ", atIndex: 0)
        }
        
        return chars.joinWithSeparator("")
    }
}

extension BigNum : CustomStringConvertible {
    public var description: String {
        get {
            var digitStrings: [String] = digits.map( { return "\($0)" } )
            digitStrings.insert(".", atIndex: decimalIndex)
            digitStrings = digitStrings.reverse()
            digitStrings.append("(\(radix))")
            if(negative) {
                digitStrings.insert("-", atIndex: 0)
            }
            let s = digitStrings.joinWithSeparator(" ")
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

public func + (🅛: BigNum, 🅡: BigNum) -> BigNum {
    return BigNum.add(🅛: 🅛, 🅡: 🅡)
}

public prefix func - (🅡: BigNum) -> BigNum {
    return BigNum.negate(🅡: 🅡)
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
    print("a:\(a.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
    print("b:\(b.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
    print("c:\(c.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
    print("d:\(d.toString(leadingPlaces: leadingPlaces, trailingPlaces: trailingPlaces))")
}