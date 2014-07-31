//
//  Math.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

// Double-based versions of these are not needed, as they are provided by the standard library
public func fmin(n1: Float, n2: Float) -> Float { return fminf(n1, n2) }
public func fmax(n1: Float, n2: Float) -> Float { return fmaxf(n1, n2) }
public func floor(n: Float) -> Float { return floorf(n) }
public func fabs(n: Float) -> Float { return fabsf(n) }
public func sin(n: Float) -> Float { return sinf(n) }
public func cos(n: Float) -> Float { return cosf(n) }
public func sqrt(n: Float) -> Float { return sqrtf(n) }
public func hypot(dx: Float, dy: Float) -> Float { return hypotf(dx, dy) }
public func atan2(dx: Float, dy: Float) -> Float { return atan2f(dx, dy) }

//
//MARK: Float
//

// The value normalized from the given range into the range 0...1
public func normalize(value: Float, a: Float, b: Float) -> Float { return (value - a) / (b - a) }
public func normalize(value: Double, a: Double, b: Double) -> Double { return (value - a) / (b - a) }
public func normalize(value: CGFloat, a: CGFloat, b: CGFloat) -> CGFloat { return (value - a) / (b - a) }

// The value denormalized from the range 0...1 to the given range
public func denormalize(value: Float, a: Float, b: Float) -> Float { return value * (b - a) + a }
public func denormalize(value: Double, a: Double, b: Double) -> Double { return value * (b - a) + a }
public func denormalize(value: CGFloat, a: CGFloat, b: CGFloat) -> CGFloat { return value * (b - a) + a }

// The value denormalized from the range 0...1 to the given range
public func interpolate(value: Float, a: Float, b: Float) -> Float { return value * (b - a) + a }
public func interpolate(value: Double, a: Double, b: Double) -> Double { return value * (b - a) + a }
public func interpolate(value: CGFloat, a: CGFloat, b: CGFloat) -> CGFloat { return value * (b - a) + a }

// The value mapped from the first given range to the second given range
public func map(value: Float, a1: Float, a2: Float, b1: Float, b2: Float) -> Float { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }
public func map(value: Double, a1: Double, a2: Double, b1: Double, b2: Double) -> Double { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }
public func map(value: CGFloat, a1: CGFloat, a2: CGFloat, b1: CGFloat, b2: CGFloat) -> CGFloat { return b1 + ((b2 - b1) * (value - a1)) / (a2 - a1) }

// The value clamped into the given range (default 0...1)
public func clamp(value: Float, min: Float = 0.0, max: Float = 1.0) -> Float { if value < min { return min }; if value > max { return max }; return value }
public func clamp(value: Double, min: Double = 0.0, max: Double = 1.0) -> Double { if value < min { return min }; if value > max { return max }; return value }
public func clamp(value: CGFloat, min: CGFloat = 0.0, max: CGFloat = 1.0) -> CGFloat { if value < min { return min }; if value > max { return max }; return value }

// return -1 for negative, 1 for positive, and 0 for zero values
public func sign(value: Float) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }
public func sign(value: Double) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }
public func sign(value: CGFloat) -> Int { if value < 0 { return -1 }; if value > 0 { return 1 }; return 0 }

// returns fractional part
public func fract(value: Float) -> Float { return value - floor(value) }
public func fract(value: Double) -> Double { return value - floor(value) }
public func fract(value: CGFloat) -> CGFloat { return value - floor(value) }

public func circularInterpolate(value: Float, a: Float, b: Float) -> Float
{
    let c = fabs(b - a)
    if c <= 0.5 {
        return denormalize(value, a, b)
    } else {
        var s: Float
        if a <= b {
            s = denormalize(value, a, b - 1.0)
            if s < 0.0 { s += 1.0 }
        } else {
            s = denormalize(value, a, b + 1.0)
            if s >= 1.0 { s -= 1.0 }
        }
        return s
    }
}

public func circularInterpolate(value: Double, a: Double, b: Double) -> Double
{
    let c = fabs(b - a)
    if c <= 0.5 {
        return denormalize(value, a, b)
    } else {
        var s: Double
        if a <= b {
            s = denormalize(value, a, b - 1.0)
            if s < 0.0 { s += 1.0 }
        } else {
            s = denormalize(value, a, b + 1.0)
            if s >= 1.0 { s -= 1.0 }
        }
        return s
    }
}

public func circularInterpolate(value: CGFloat, a: CGFloat, b: CGFloat) -> CGFloat
{
    let c = fabs(b - a)
    if c <= 0.5 {
        return denormalize(value, a, b)
    } else {
        var s: CGFloat
        if a <= b {
            s = denormalize(value, a, b - 1.0)
            if s < 0.0 { s += 1.0 }
        } else {
            s = denormalize(value, a, b + 1.0)
            if s >= 1.0 { s -= 1.0 }
        }
        return s
    }
}
