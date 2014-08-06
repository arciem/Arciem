//
//  Math.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit
import Darwin
import CoreGraphics

// Double-based versions of these are not needed, as they are provided by Darwin
// CGFloat-based versions of these are not needed, as they are provided by CoreGraphics
public func fmin(n1: Float, n2: Float) -> Float { return fminf(n1, n2) }
public func fmax(n1: Float, n2: Float) -> Float { return fmaxf(n1, n2) }
public func floor(n: Float) -> Float { return floorf(n) }
public func fabs(n: Float) -> Float { return fabsf(n) }
public func sin(n: Float) -> Float { return sinf(n) }
public func cos(n: Float) -> Float { return cosf(n) }
public func sqrt(n: Float) -> Float { return sqrtf(n) }
public func hypot(dx: Float, dy: Float) -> Float { return hypotf(dx, dy) }
public func atan2(dx: Float, dy: Float) -> Float { return atan2f(dx, dy) }

public protocol Arithmeticable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    
    func += (inout lhs: Self, rhs: Self)
    func -= (inout lhs: Self, rhs: Self)
}

extension Float : Arithmeticable { }
extension Double : Arithmeticable { }
extension CGFloat : Arithmeticable { }

public protocol Floorable {
    class func floor(v: Self) -> Self
}

extension Float : Floorable {
    public static func floor(v: Float) -> Float { return Darwin.floorf(v) }
}

extension Double : Floorable {
    public static func floor(v: Double) -> Double { return Darwin.floor(v) }
}

extension CGFloat : Floorable {
    public static func floor(v: CGFloat) -> CGFloat { return CoreGraphics.floor(v) }
}

// The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
public func normalize<T: Arithmeticable>(value: T, i1: T, i2: T) -> T { return (value - i1) / (i2 - i1) }

// The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
public func denormalize<T: Arithmeticable>(value: T, i1: T, i2: T) -> T { return value * (i2 - i1) + i1 }

// The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
public func interpolate<T: Arithmeticable>(value: T, i1: T, i2: T) -> T { return value * (i2 - i1) + i1 }

// The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
public func map<T: Arithmeticable>(value: T, a1: T, a2: T, b1: T, b2: T) -> T { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

// The value clamped into the given interval (default 0...1)
public func clamp<T where T: Arithmeticable, T:IntegerLiteralConvertible>(value: T, _ i: ClosedInterval<T> = 0...1) -> T { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }

// return -1 for negative, 1 for positive, and 0 for zero values
public func sign<T where T: Comparable, T: IntegerLiteralConvertible>(value: T) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

// returns fractional part
public func fract<T where T:Arithmeticable, T:Floorable>(value: T) -> T { return value - T.floor(value) }

public func circularInterpolate<T where T: FloatingPointType, T: AbsoluteValuable, T:FloatLiteralConvertible, T:IntegerLiteralConvertible, T:Arithmeticable>(value: T, i1: T, i2: T) -> T
{
    let c = T.abs(i2 - i1)
    if c <= 0.5 {
        return denormalize(value, i1, i2)
    } else {
        var s: T
        if i1 <= i2 {
            s = denormalize(value, i1, i2 - 1.0)
            if s < 0.0 { s += 1.0 }
        } else {
            s = denormalize(value, i1, i2 + 1.0)
            if s >= 1.0 { s -= 1.0 }
        }
        return s
    }
}
