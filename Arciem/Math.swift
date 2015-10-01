//
//  Math.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

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

public protocol MathematicType { }

extension Float : MathematicType { }
extension Double : MathematicType { }
extension CGFloat : MathematicType { }

//public protocol IntInitable {
//    init(_ v: UInt8)
//    init(_ v: Int8)
//    init(_ v: UInt16)
//    init(_ v: Int16)
//    init(_ v: UInt32)
//    init(_ v: Int32)
//    init(_ v: UInt64)
//    init(_ v: Int64)
//    init(_ v: UInt)
//    init(_ v: Int)
//}

//public protocol MathematicType: Comparable, SignedNumberType, IntegerLiteralConvertible, FloatLiteralConvertible {
//    prefix func -(🅡: Self) -> Self
//    func +(🅛: Self, 🅡: Self) -> Self
//    func -(🅛: Self, 🅡: Self) -> Self
//    func *(🅛: Self, 🅡: Self) -> Self
//    func /(🅛: Self, 🅡: Self) -> Self
//    func %(🅛: Self, 🅡: Self) -> Self
//    func += (inout 🅛: Self, 🅡: Self)
//    func -= (inout 🅛: Self, 🅡: Self)
//    func *= (inout 🅛: Self, 🅡: Self)
//    func /= (inout 🅛: Self, 🅡: Self)
//    func %= (inout 🅛: Self, 🅡: Self)
//    
//    init(_ v: Int)
//    init(_ v: Float)
//    init(_ v: Double)
//
//    static func floor(v: Self) -> Self
//    static func abs(v: Self) -> Self
//    
//    static func fmin(a: Self, _ b: Self) -> Self
//    static func fmax(a: Self, _ b: Self) -> Self
//    
//    static func sqrt(v: Self) -> Self
//    static func sin(v: Self) -> Self
//    static func cos(v: Self) -> Self
//    static func hypot(x: Self, _ y:Self) -> Self
//    static func atan2(x: Self, _ y:Self) -> Self
//}

//extension Float : MathematicType {
//    public static func floor(v: Float) -> Float { return Foundation.floorf(v) }
//    public static func abs(v: Float) -> Float { return v < 0.0 ? -v : v }
//
//    public static func fmin(a: Float, _ b: Float) -> Float { return Foundation.fminf(a, b) }
//    public static func fmax(a: Float, _ b: Float) -> Float { return Foundation.fmaxf(a, b) }
//
//    public static func sqrt(v: Float) -> Float  { return Foundation.sqrtf(v) }
//    public static func sin(v: Float) -> Float { return Foundation.sinf(v) }
//    public static func cos(v: Float) -> Float { return Foundation.cosf(v) }
//    public static func hypot(x: Float, _ y:Float) -> Float { return Foundation.hypotf(x, y) }
//    public static func atan2(x: Float, _ y:Float) -> Float { return Foundation.atan2f(x, y) }
//}

//extension Double : MathematicType {
//    public static func floor(v: Double) -> Double { return Foundation.floor(v) }
//    public static func abs(v: Double) -> Double { return v < 0.0 ? -v : v }
//
//    public static func fmin(a: Double, _ b: Double) -> Double { return Foundation.fmin(a, b) }
//    public static func fmax(a: Double, _ b: Double) -> Double { return Foundation.fmax(a, b) }
//
//    public static func sqrt(v: Double) -> Double { return Foundation.sqrt(v) }
//    public static func sin(v: Double) -> Double { return Foundation.sin(v) }
//    public static func cos(v: Double) -> Double { return Foundation.cos(v) }
//    public static func hypot(x: Double, _ y:Double) -> Double { return Foundation.hypot(x, y) }
//    public static func atan2(x: Double, _ y:Double) -> Double { return Foundation.atan2(x, y) }
//}
//
//extension CGFloat : MathematicType {
//    public static func floor(v: CGFloat) -> CGFloat { return CoreGraphics.floor(v) }
//    public static func abs(v: CGFloat) -> CGFloat { return v < 0.0 ? -v : v }
//
//    public static func fmin(a: CGFloat, _ b: CGFloat) -> CGFloat { return CoreGraphics.fmin(a, b) }
//    public static func fmax(a: CGFloat, _ b: CGFloat) -> CGFloat { return CoreGraphics.fmax(a, b) }
//
//    public static func sqrt(v: CGFloat) -> CGFloat { return CoreGraphics.sqrt(v) }
//    public static func sin(v: CGFloat) -> CGFloat  { return CoreGraphics.sin(v) }
//    public static func cos(v: CGFloat) -> CGFloat  { return CoreGraphics.cos(v) }
//    public static func hypot(x: CGFloat, _ y:CGFloat) -> CGFloat { return CoreGraphics.hypot(x, y) }
//    public static func atan2(x: CGFloat, _ y:CGFloat) -> CGFloat { return CoreGraphics.atan2(x, y) }
//}
//

public class Math {
}

// Float
extension Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize(value: Float, _ i1: Float, _ i2: Float) -> Float { return (value - i1) / (i2 - i1) }

    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize(value: Float, _ i1: Float, _ i2: Float) -> Float { return value * (i2 - i1) + i1 }

    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate(value: Float, _ i1: Float, _ i2: Float) -> Float { return value * (i2 - i1) + i1 }

    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map(value: Float, _ a1: Float, _ a2: Float, _ b1: Float, _ b2: Float) -> Float { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

    // The value clamped into the given interval (default 0...1)
    public class func clamp(value: Float, _ i: ClosedInterval<Float> = 0...1) -> Float { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }
    
    // The interval clamped into another interval
    public class func clamp(value: ClosedInterval<Float>, intervalToClamp: ClosedInterval<Float>) -> ClosedInterval<Float> {
        return value.clamp(intervalToClamp)
    }

    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign(value: Float) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

    // returns fractional part
    public class func fract(value: Float) -> Float { return value - floorf(value) }

    public class func circularInterpolate(value: Float, _ i1: Float, _ i2: Float) -> Float
    {
        let c = Float.abs(i2 - i1)
        if c <= 0.5 {
            return denormalize(value, i1, i2)
        } else {
            var s: Float
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

// Double
extension Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize(value: Double, _ i1: Double, _ i2: Double) -> Double { return (value - i1) / (i2 - i1) }
    
    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize(value: Double, _ i1: Double, _ i2: Double) -> Double { return value * (i2 - i1) + i1 }
    
    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate(value: Double, _ i1: Double, _ i2: Double) -> Double { return value * (i2 - i1) + i1 }
    
    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map(value: Double, _ a1: Double, _ a2: Double, _ b1: Double, _ b2: Double) -> Double { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }
    
    // The value clamped into the given interval (default 0...1)
    public class func clamp(value: Double, _ i: ClosedInterval<Double> = 0...1) -> Double { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }
    
    // The interval clamped into another interval
    public class func clamp(value: ClosedInterval<Double>, intervalToClamp: ClosedInterval<Double>) -> ClosedInterval<Double> {
        return value.clamp(intervalToClamp)
    }
    
    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign(value: Double) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }
    
    // returns fractional part
    public class func fract(value: Double) -> Double { return value - floor(value) }
    
    public class func circularInterpolate(value: Double, _ i1: Double, _ i2: Double) -> Double
    {
        let c = Double.abs(i2 - i1)
        if c <= 0.5 {
            return denormalize(value, i1, i2)
        } else {
            var s: Double
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

// CGFloat
extension Math {
    // The value normalized from the interval i1...i2 into the interval 0...1. (i1 may be greater than i2)
    public class func normalize(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat { return (value - i1) / (i2 - i1) }
    
    // The value denormalized from the interval 0...1 to the interval i1...i2. (i1 may be greater than i2)
    public class func denormalize(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat { return value * (i2 - i1) + i1 }
    
    // The value interpolated from the interval 0...1 to the interval i1...i2. (i1 my be greater than i2)
    public class func interpolate(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat { return value * (i2 - i1) + i1 }
    
    // The value mapped from the interval a1...a2 to the interval b1...b2. (the a's may be greater than the b's)
    public class func map(value: CGFloat, _ a1: CGFloat, _ a2: CGFloat, _ b1: CGFloat, _ b2: CGFloat) -> CGFloat { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }
    
    // The value clamped into the given interval (default 0...1)
    public class func clamp(value: CGFloat, _ i: ClosedInterval<CGFloat> = 0...1) -> CGFloat { if value < i.start { return i.start }; if value > i.end { return i.end }; return value }
    
    // The interval clamped into another interval
    public class func clamp(value: ClosedInterval<CGFloat>, intervalToClamp: ClosedInterval<CGFloat>) -> ClosedInterval<CGFloat> {
        return value.clamp(intervalToClamp)
    }
    
    // return -1 for negative, 1 for positive, and 0 for zero values
    public class func sign(value: CGFloat) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }
    
    // returns fractional part
    public class func fract(value: CGFloat) -> CGFloat { return value - floor(value) }
    
    public class func circularInterpolate(value: CGFloat, _ i1: CGFloat, _ i2: CGFloat) -> CGFloat
    {
        let c = CGFloat.abs(i2 - i1)
        if c <= 0.5 {
            return denormalize(value, i1, i2)
        } else {
            var s: CGFloat
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
