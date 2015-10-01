//
//  Math.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit
import CoreGraphics

// Double-based versions of these are not needed, as they are provided by Foundation
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

public protocol Addable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self

    func += (inout lhs: Self, rhs: Self)
    func -= (inout lhs: Self, rhs: Self)
}

public protocol Arithmeticable : Addable {
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self

    func *= (inout lhs: Self, rhs: Self)
    func /= (inout lhs: Self, rhs: Self)
    func %= (inout lhs: Self, rhs: Self)
}

extension Float : Arithmeticable { }
extension Double : Arithmeticable { }
extension CGFloat : Arithmeticable { }

public protocol Mathable {
    static func floor(v: Self) -> Self
    static func abs(v: Self) -> Self

    static func fmin(a: Self, _ b: Self) -> Self
    static func fmax(a: Self, _ b: Self) -> Self

    static func sqrt(v: Self) -> Self
    static func sin(v: Self) -> Self
    static func cos(v: Self) -> Self
    static func hypot(x: Self, _ y:Self) -> Self
    static func atan2(x: Self, _ y:Self) -> Self
}

extension Float : Mathable {
    public static func floor(v: Float) -> Float { return Foundation.floorf(v) }
    public static func abs(v: Float) -> Float { return v < 0.0 ? -v : v }
    
    public static func fmin(a: Float, _ b: Float) -> Float { return Foundation.fminf(a, b) }
    public static func fmax(a: Float, _ b: Float) -> Float { return Foundation.fmaxf(a, b) }

    public static func sqrt(v: Float) -> Float  { return Foundation.sqrtf(v) }
    public static func sin(v: Float) -> Float { return Foundation.sinf(v) }
    public static func cos(v: Float) -> Float { return Foundation.cosf(v) }
    public static func hypot(x: Float, _ y:Float) -> Float { return Foundation.hypotf(x, y) }
    public static func atan2(x: Float, _ y:Float) -> Float { return Foundation.atan2f(x, y) }
}

extension Double : Mathable {
    public static func floor(v: Double) -> Double { return Foundation.floor(v) }
    public static func abs(v: Double) -> Double { return v < 0.0 ? -v : v }

    public static func fmin(a: Double, _ b: Double) -> Double { return Foundation.fmin(a, b) }
    public static func fmax(a: Double, _ b: Double) -> Double { return Foundation.fmax(a, b) }

    public static func sqrt(v: Double) -> Double { return Foundation.sqrt(v) }
    public static func sin(v: Double) -> Double { return Foundation.sin(v) }
    public static func cos(v: Double) -> Double { return Foundation.cos(v) }
    public static func hypot(x: Double, _ y:Double) -> Double { return Foundation.hypot(x, y) }
    public static func atan2(x: Double, _ y:Double) -> Double { return Foundation.atan2(x, y) }
}

extension CGFloat : Mathable {
    public static func floor(v: CGFloat) -> CGFloat { return CoreGraphics.floor(v) }
    public static func abs(v: CGFloat) -> CGFloat { return v < 0.0 ? -v : v }

    public static func fmin(a: CGFloat, _ b: CGFloat) -> CGFloat { return CoreGraphics.fmin(a, b) }
    public static func fmax(a: CGFloat, _ b: CGFloat) -> CGFloat { return CoreGraphics.fmax(a, b) }

    public static func sqrt(v: CGFloat) -> CGFloat { return CoreGraphics.sqrt(v) }
    public static func sin(v: CGFloat) -> CGFloat  { return CoreGraphics.sin(v) }
    public static func cos(v: CGFloat) -> CGFloat  { return CoreGraphics.cos(v) }
    public static func hypot(x: CGFloat, _ y:CGFloat) -> CGFloat { return CoreGraphics.hypot(x, y) }
    public static func atan2(x: CGFloat, _ y:CGFloat) -> CGFloat { return CoreGraphics.atan2(x, y) }
}

public protocol IntInitable {
    init(_: UInt8)
    init(_: UInt16)
    init(_: Int16)
    init(_: UInt32)
    init(_: Int32)
    init(_: UInt64)
    init(_: Int64)
    init(_: UInt)
    init(_: Int)
}

public protocol FloatInitable {
    init(_: Float)
    init(_: Double)
}

public protocol NumericInitable : IntInitable, FloatInitable { }

extension Float : NumericInitable { }
extension Double : NumericInitable { }
extension CGFloat : NumericInitable { }

public protocol Floatable : NumericInitable, Arithmeticable, Mathable, IntegerLiteralConvertible, FloatLiteralConvertible, Comparable { }

extension Float : Floatable { }
extension Double : Floatable { }
extension CGFloat : Floatable { }

public class Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize<T: Floatable>(value: T, _ i1: T, _ i2: T) -> T { return (value - i1) / (i2 - i1) }

    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize<T: Floatable>(value: T, _ i1: T, _ i2: T) -> T { return value * (i2 - i1) + i1 }

    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate<T: Floatable>(value: T, _ i1: T, _ i2: T) -> T { return value * (i2 - i1) + i1 }

    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map<T: Floatable>(value: T, _ a1: T, _ a2: T, _ b1: T, _ b2: T) -> T { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

    // The value clamped into the given interval (default 0...1)
    public class func clamp<T: Floatable>(value: T, _ i: ClosedInterval<T> = 0...1) -> T { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }

    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign<T: Floatable>(value: T) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

    // returns fractional part
    public class func fract<T: Floatable>(value: T) -> T { return value - T.floor(value) }

    public class func circularInterpolate<T: Floatable>(value: T, _ i1: T, _ i2: T) -> T
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
}
