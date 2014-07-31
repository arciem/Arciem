//
//  Geometry.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

public let goldenRatio: Double = 1.61803398874989484820
public let pointsPerInch: Double = 72.0
public let pi: Double = M_PI
public let piOverTwo: Double = M_PI_2
public let twoPi: Double = 2.0 * pi
public let rad2deg: Double = 180.0 / pi
public let deg2rad: Double = pi / 180.0

// Radians
public typealias FloatAngle = Float
public typealias DoubleAngle = Double
public typealias CGFloatAngle = CGFloat

// Degrees
public typealias FloatDegrees = Float
public typealias DoubleDegrees = Double
public typealias CGFloatDegrees = CGFloat

public func radiansFromDegrees(#deg: FloatDegrees) -> FloatAngle { return deg * Float(deg2rad) }
public func radiansFromDegrees(#deg: DoubleDegrees) -> DoubleAngle { return deg * deg2rad }
public func radiansFromDegrees(#deg: CGFloat) -> CGFloat { return deg * CGFloat(deg2rad) }

public func degreesFromRadians(#ang: FloatAngle) -> FloatDegrees { return ang * Float(rad2deg) }
public func degreesFromRadians(#ang: DoubleAngle) -> DoubleDegrees { return ang * rad2deg }
public func degreesFromRadians(#ang: CGFloat) -> CGFloat { return ang * CGFloat(rad2deg) }

public func distanceSquared(#x: Float, #y: Float) -> Float { return x * x + y * y }
public func distanceSquared(#x: Double, #y: Double) -> Double { return x * x + y * y }
public func distanceSquared(#x: CGFloat, #y: CGFloat) -> CGFloat { return x * x + y * y }

public func distanceSquared(#x1: Float, #y1: Float, #x2: Float, #y2: Float) -> Float { return distanceSquared(x: x2 - x1, y: y2 - y1) }
public func distanceSquared(#x1: Double, #y1: Double, #x2: Double, #y2: Double) -> Double { return distanceSquared(x: x2 - x1, y: y2 - y1) }
public func distanceSquared(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat) -> CGFloat { return distanceSquared(x: x2 - x1, y: y2 - y1) }

public func distance(#x: Float, #y: Float) -> Float { return hypot(x, y) }
public func distance(#x: Double, #y: Double) -> Double { return hypot(x, y) }
public func distance(#x: CGFloat, #y: CGFloat) -> CGFloat { return hypot(x, y) }

public func distance(#x1: Float, #y1: Float, #x2: Float, #y2: Float) -> Float { return distance(x: x2 - x1, y: y2 - y1) }
public func distance(#x1: Double, #y1: Double, #x2: Double, #y2: Double) -> Double { return distance(x: x2 - x1, y: y2 - y1) }
public func distance(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat) -> CGFloat { return distance(x: x2 - x1, y: y2 - y1) }

public func distanceSquared(#x: Float, #y: Float, #z: Float) -> Float { return x * x + y * y + z * z }
public func distanceSquared(#x: Double, #y: Double, #z: Double) -> Double { return x * x + y * y + z * z }
public func distanceSquared(#x: CGFloat, #y: CGFloat, #z: CGFloat) -> CGFloat { return x * x + y * y + z * z }

public func distanceSquared(#x1: Float, #y1: Float, #z1: Float, #x2: Float, #y2: Float, #z2: Float) -> Float { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }
public func distanceSquared(#x1: Double, #y1: Double, #z1: Double, #x2: Double, #y2: Double, #z2: Double) -> Double { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }
public func distanceSquared(#x1: CGFloat, #y1: CGFloat, #z1: CGFloat, #x2: CGFloat, #y2: CGFloat, #z2: CGFloat) -> CGFloat { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }

public func distance(#x: Float, #y: Float, #z: Float) -> Float { return sqrt(distanceSquared(x: x, y: y, z: z)) }
public func distance(#x: Double, #y: Double, #z: Double) -> Double { return sqrt(distanceSquared(x: x, y: y, z: z)) }
public func distance(#x: CGFloat, #y: CGFloat, #z: CGFloat) -> CGFloat { return sqrt(distanceSquared(x: x, y: y, z: z)) }

public func distance(#x1: Float, #y1: Float, #z1: Float, #x2: Float, #y2: Float, #z2: Float) -> Float { return sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }
public func distance(#x1: Double, #y1: Double, #z1: Double, #x2: Double, #y2: Double, #z2: Double) -> Double { return sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }
public func distance(#x1: CGFloat, #y1: CGFloat, #z1: CGFloat, #x2: CGFloat, #y2: CGFloat, #z2: CGFloat) -> CGFloat { return sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }

public func angle(#x: Float, #y: Float) -> FloatAngle { return atan2(y, x) }
public func angle(#x: Double, #y: Double) -> DoubleAngle { return atan2(y, x) }
public func angle(#x: CGFloat, #y: CGFloat) -> CGFloatAngle { return atan2(y, x) }

public func angle(#x1: Float, #y1: Float, #x2: Float, #y2: Float) -> FloatAngle { return angle(x: x2 - x1, y: y2 - y1) }
public func angle(#x1: Double, #y1: Double, #x2: Double, #y2: Double) -> DoubleAngle { return angle(x: x2 - x1, y: y2 - y1) }
public func angle(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat) -> CGFloatAngle { return angle(x: x2 - x1, y: y2 - y1) }

public func area(#x: Float, #y: Float) -> Float { return x * y; }
public func area(#x: Double, #y: Double) -> Double { return x * y; }
public func area(#x: CGFloat, #y: CGFloat) -> CGFloat { return x * y; }

public func volume(#x: Float, #y: Float, #z: Float) -> Float { return x * y * z; }
public func volume(#x: Double, #y: Double, #z: Double) -> Double { return x * y * z; }
public func volume(#x: CGFloat, #y: CGFloat, #z: CGFloat) -> CGFloat { return x * y * z; }

public func dot(#x1: Float, #y1: Float, #x2: Float, #y2: Float) -> Float { return x1 * x2 + y1 * y2; }
public func dot(#x1: Double, #y1: Double, #x2: Double, #y2: Double) -> Double { return x1 * x2 + y1 * y2; }
public func dot(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat) -> CGFloat { return x1 * x2 + y1 * y2; }

public func dot(#x1: Float, #y1: Float, #z1: Float, #x2: Float, #y2: Float, #z2: Float) -> Float { return x1 * x2 + y1 * y2 + z1 * z2; }
public func dot(#x1: Double, #y1: Double, #z1: Double, #x2: Double, #y2: Double, #z2: Double) -> Double { return x1 * x2 + y1 * y2 + z1 * z2; }
public func dot(#x1: CGFloat, #y1: CGFloat, #z1: CGFloat, #x2: CGFloat, #y2: CGFloat, #z2: CGFloat) -> CGFloat { return x1 * x2 + y1 * y2 + z1 * z2; }

public func cross(#x1: Float, #y1: Float, #z1: Float, #x2: Float, #y2: Float, #z2: Float) -> (x:Float, y:Float, z:Float) {
    return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
}
public func cross(#x1: Double, #y1: Double, #z1: Double, #x2: Double, #y2: Double, #z2: Double) -> (x:Double, y:Double, z:Double) {
    return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
}
public func cross(#x1: CGFloat, #y1: CGFloat, #z1: CGFloat, #x2: CGFloat, #y2: CGFloat, #z2: CGFloat) -> (x:CGFloat, y:CGFloat, z:CGFloat) {
    return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
}

public func scale(#x: Float, #y: Float, #s: Float) -> (x: Float, y: Float) { return (x: x * s, y: y * s) }
public func scale(#x: Double, #y: Double, #s: Double) -> (x: Double, y: Double) { return (x: x * s, y: y * s) }
public func scale(#x: CGFloat, #y: CGFloat, #s: CGFloat) -> (x: CGFloat, y: CGFloat) { return (x: x * s, y: y * s) }

public func scale(#x: Float, #y: Float, #z: Float, #s: Float) -> (x: Float, y: Float, z: Float) { return (x: x * s, y: y * s, z: z * s) }
public func scale(#x: Double, #y: Double, #z: Double, #s: Double) -> (x: Double, y: Double, z: Double) { return (x: x * s, y: y * s, z: z * s) }
public func scale(#x: CGFloat, #y: CGFloat, #z: CGFloat, #s: CGFloat) -> (x: CGFloat, y: CGFloat, z: CGFloat) { return (x: x * s, y: y * s, z: z * s) }

public func scale(#x: Float, #y: Float, #sx: Float, #sy: Float) -> (x: Float, y: Float) { return (x: x * sx, y: y * sy) }
public func scale(#x: Double, #y: Double, #sx: Double, #sy: Double) -> (x: Double, y: Double) { return (x: x * sx, y: y * sy) }
public func scale(#x: CGFloat, #y: CGFloat, #sx: CGFloat, #sy: CGFloat) -> (x: CGFloat, y: CGFloat) { return (x: x * sx, y: y * sy) }

public func scale(#x: Float, #y: Float, #z: Float, #sx: Float, #sy: Float, #sz: Float) -> (x: Float, y: Float, z: Float) { return (x: x * sx, y: y * sy, z: z * sz) }
public func scale(#x: Double, #y: Double, #z: Double, #sx: Double, #sy: Double, #sz: Double) -> (x: Double, y: Double, z: Double) { return (x: x * sx, y: y * sy, z: z * sz) }
public func scale(#x: CGFloat, #y: CGFloat, #z: CGFloat, #sx: CGFloat, #sy: CGFloat, #sz: CGFloat) -> (x: CGFloat, y: CGFloat, z: CGFloat) { return (x: x * sx, y: y * sy, z: z * sz) }

public func normalize(#x: Float, #y: Float) -> (x: Float, y: Float) {
    let d = distance(x: x, y: y); return (x: x / d, y: y / d)
}
public func normalize(#x: Double, #y: Double) -> (x: Double, y: Double) {
    let d = distance(x: x, y: y); return (x: x / d, y: y / d)
}
public func normalize(#x: CGFloat, #y: CGFloat) -> (x: CGFloat, y: CGFloat) {
    let d = distance(x: x, y: y); return (x: x / d, y: y / d)
}

public func normalize(#x: Float, #y: Float, #z: Float) -> (x: Float, y: Float, z: Float) {
    let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
}
public func normalize(#x: Double, #y: Double, #z: Double) -> (x: Double, y: Double, z: Double) {
    let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
}
public func normalize(#x: CGFloat, #y: CGFloat, #z: CGFloat) -> (x: CGFloat, y: CGFloat, z: CGFloat) {
    let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
}

public func normalizeAngle(var a: FloatAngle) -> FloatAngle {
    if a > Float(twoPi) {
        a -= Float(twoPi)
        if a > Float(twoPi) {
            a = a % Float(twoPi)
        }
    } else if a < 0.0 {
        a += Float(twoPi)
        if a < 0.0 {
            a = a % Float(twoPi)
        }
    }
    
    return a
}

public func normalizeAngle(var a: DoubleAngle) -> DoubleAngle {
    if a > twoPi {
        a -= twoPi
        if a > twoPi {
            a = a % twoPi
        }
    } else if a < 0.0 {
        a += twoPi
        if a < 0.0 {
            a = a % twoPi
        }
    }
    
    return a
}

public func normalizeAngle(var a: CGFloatAngle) -> CGFloatAngle {
    if a > CGFloat(twoPi) {
        a -= CGFloat(twoPi)
        if a > CGFloat(twoPi) {
            a = a % CGFloat(twoPi)
        }
    } else if a < 0.0 {
        a += CGFloat(twoPi)
        if a < 0.0 {
            a = a % CGFloat(twoPi)
        }
    }
    
    return a
}

public func rotate(#x: Float, #y: Float, #angle: Float) -> (x: Float, y: Float) {
    let ca = cos(angle)
    let sa = sin(angle)
    return (x: x * ca - y * sa, y: y * ca + x * sa)
}
public func rotate(#x: Double, #y: Double, #angle: Double) -> (x: Double, y: Double) {
    let ca = cos(angle)
    let sa = sin(angle)
    return (x: x * ca - y * sa, y: y * ca + x * sa)
}
public func rotate(#x: CGFloat, #y: CGFloat, #angle: CGFloat) -> (x: CGFloat, y: CGFloat) {
    let ca = cos(angle)
    let sa = sin(angle)
    return (x: x * ca - y * sa, y: y * ca + x * sa)
}

public func fromPolar(#radius: Float, #angle: Float) -> (x: Float, y: Float) {
    return (x: radius * cosf(angle), y: radius * sin(angle))
}
public func fromPolar(#radius: Double, #angle: Double) -> (x: Double, y: Double) {
    return (x: radius * cos(angle), y: radius * sin(angle))
}
public func fromPolar(#radius: CGFloat, #angle: CGFloat) -> (x: CGFloat, y: CGFloat) {
    return (x: radius * cos(angle), y: radius * sin(angle))
}

public func interpolate(#x1: Float, #y1: Float, #x2: Float, #y2: Float, #t: Float) -> (x: Float, y: Float) {
    return (x: interpolate(t, x1, x2), y: interpolate(t, y1, y2))
}
public func interpolate(#x1: Double, #y1: Double, #x2: Double, #y2: Double, #t: Double) -> (x: Double, y: Double) {
    return (x: interpolate(t, x1, x2), y: interpolate(t, y1, y2))
}
public func interpolate(#x1: CGFloat, #y1: CGFloat, #x2: CGFloat, #y2: CGFloat, #t: CGFloat) -> (x: CGFloat, y: CGFloat) {
    return (x: interpolate(t, x1, x2), y: interpolate(t, y1, y2))
}

public func scaleForAspectFit(#dxContent: Float, #dyContent: Float, #dxArea: Float, #dyArea: Float) -> Float {
    return fmin(dxArea / dxContent, dyArea / dyContent)
}
public func scaleForAspectFit(#dxContent: Double, #dyContent: Double, #dxArea: Double, #dyArea: Double) -> Double {
    return fmin(dxArea / dxContent, dyArea / dyContent)
}
public func scaleForAspectFit(#dxContent: CGFloat, #dyContent: CGFloat, #dxArea: CGFloat, #dyArea: CGFloat) -> CGFloat {
    return fmin(dxArea / dxContent, dyArea / dyContent)
}

public func scaleForAspectFill(#dxContent: Float, #dyContent: Float, #dxArea: Float, #dyArea: Float) -> Float {
    return fmax(dxArea / dxContent, dyArea / dyContent)
}
public func scaleForAspectFill(#dxContent: Double, #dyContent: Double, #dxArea: Double, #dyArea: Double) -> Double {
    return fmax(dxArea / dxContent, dyArea / dyContent)
}
public func scaleForAspectFill(#dxContent: CGFloat, #dyContent: CGFloat, #dxArea: CGFloat, #dyArea: CGFloat) -> CGFloat {
    return fmax(dxArea / dxContent, dyArea / dyContent)
}

public func aspectFit(#dxContent: Float, #dyContent: Float, #dxArea: Float, #dyArea: Float) -> (x: Float, y: Float) {
    let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}
public func aspectFit(#dxContent: Double, #dyContent: Double, #dxArea: Double, #dyArea: Double) -> (x: Double, y: Double) {
    let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}
public func aspectFit(#dxContent: CGFloat, #dyContent: CGFloat, #dxArea: CGFloat, #dyArea: CGFloat) -> (x: CGFloat, y: CGFloat) {
    let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}

public func aspectFill(#dxContent: Float, #dyContent: Float, #dxArea: Float, #dyArea: Float) -> (x: Float, y: Float) {
    let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}
public func aspectFill(#dxContent: Double, #dyContent: Double, #dxArea: Double, #dyArea: Double) -> (x: Double, y: Double) {
    let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}
public func aspectFill(#dxContent: CGFloat, #dyContent: CGFloat, #dxArea: CGFloat, #dyArea: CGFloat) -> (x: CGFloat, y: CGFloat) {
    let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}

// These versions use parabola segments (hermite curves)
public func easeOutFast(t: Float) -> Float { let f = clamp(t); return 2 * f - f * f }
public func easeOutFast(t: Double) -> Double { let f = clamp(t); return 2 * f - f * f }
public func easeOutFast(t: CGFloat) -> CGFloat { let f = clamp(t); return 2 * f - f * f }

public func easeInFast(t: Float) -> Float { let f = clamp(t); return f * f }
public func easeInFast(t: Double) -> Double { let f = clamp(t); return f * f }
public func easeInFast(t: CGFloat) -> CGFloat { let f = clamp(t); return f * f }

public func easeInAndOutFast(t: Float) -> Float { let f = clamp(t); return f * f * (3.0 - 2.0 * f) }
public func easeInAndOutFast(t: Double) -> Double { let f = clamp(t); return f * f * (3.0 - 2.0 * f) }
public func easeInAndOutFast(t: CGFloat) -> CGFloat { let f = clamp(t); return f * f * (3.0 - 2.0 * f) }

// These versions use sine curve segments, and are more computationally intensive
public func easeOut(t: Float) -> Float { let f = clamp(t); return sinf(f * Float(piOverTwo)) }
public func easeOut(t: Double) -> Double { let f = clamp(t); return sin(f * piOverTwo) }
public func easeOut(t: CGFloat) -> CGFloat { let f = clamp(t); return sin(f * CGFloat(piOverTwo)) }

public func easeIn(t: Float) -> Float { let f = clamp(t); return 1.0 - cosf(f * Float(piOverTwo)) }
public func easeIn(t: Double) -> Double { let f = clamp(t); return 1.0 - cos(f * piOverTwo) }
public func easeIn(t: CGFloat) -> CGFloat { let f = clamp(t); return 1.0 - cos(f * CGFloat(piOverTwo)) }

public func easeInAndOut(t: Float) -> Float { let f = clamp(t); return 0.5 * (1 + sinf(Float(pi) * (f - 0.5))) }
public func easeInAndOut(t: Double) -> Double { let f = clamp(t); return 0.5 * (1 + sin(pi * (f - 0.5))) }
public func easeInAndOut(t: CGFloat) -> CGFloat { let f = clamp(t); return 0.5 * (1 + sin(CGFloat(pi) * (f - 0.5))) }


public func triangleUpThenDown(t: Float) -> Float { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 0.0, 1.0) : map(f, 0.5, 1.0, 1.0, 0.0) }
public func triangleUpThenDown(t: Double) -> Double { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 0.0, 1.0) : map(f, 0.5, 1.0, 1.0, 0.0) }
public func triangleUpThenDown(t: CGFloat) -> CGFloat { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 0.0, 1.0) : map(f, 0.5, 1.0, 1.0, 0.0) }

public func triangleDownThenUp(t: Float) -> Float { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 1.0, 0.0) : map(f, 0.5, 1.0, 0.0, 1.0) }
public func triangleDownThenUp(t: Double) -> Double { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 1.0, 0.0) : map(f, 0.5, 1.0, 0.0, 1.0) }
public func triangleDownThenUp(t: CGFloat) -> CGFloat { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 1.0, 0.0) : map(f, 0.5, 1.0, 0.0, 1.0) }

public func sawtoothUp(t: Float) -> Float { return fract(t) }
public func sawtoothUp(t: Double) -> Double { return fract(t) }
public func sawtoothUp(t: CGFloat) -> CGFloat { return fract(t) }

public func sawtoothDown(t: Float) -> Float { return 1.0 - fract(t) }
public func sawtoothDown(t: Double) -> Double { return 1.0 - fract(t) }
public func sawtoothDown(t: CGFloat) -> CGFloat { return 1.0 - fract(t) }


public func sineUpThenDown(t: Float) -> Float { return sinf(t * Float(twoPi)) * 0.5 + 0.5 }
public func sineUpThenDown(t: Double) -> Double { return sin(t * twoPi) * 0.5 + 0.5 }
public func sineUpThenDown(t: CGFloat) -> CGFloat { return sin(t * CGFloat(twoPi)) * 0.5 + 0.5 }

public func sineDownThenUp(t: Float) -> Float { return 1.0 - sinf(t * Float(twoPi)) * 0.5 + 0.5 }
public func sineDownThenUp(t: Double) -> Double { return 1.0 - sin(t * twoPi) * 0.5 + 0.5 }
public func sineDownThenUp(t: CGFloat) -> CGFloat { return 1.0 - sin(t * CGFloat(twoPi)) * 0.5 + 0.5 }

public func cosineUpThenDown(t: Float) -> Float { return 1.0 - cosf(t * Float(twoPi)) * 0.5 + 0.5 }
public func cosineUpThenDown(t: Double) -> Double { return 1.0 - cos(t * twoPi) * 0.5 + 0.5 }
public func cosineUpThenDown(t: CGFloat) -> CGFloat { return 1.0 - cos(t * CGFloat(twoPi)) * 0.5 + 0.5 }

public func cosineDownThenUp(t: Float) -> Float { return cosf(t * Float(twoPi)) * 0.5 + 0.5 }
public func cosineDownThenUp(t: Double) -> Double { return cos(t * twoPi) * 0.5 + 0.5 }
public func cosineDownThenUp(t: CGFloat) -> CGFloat { return cos(t * CGFloat(twoPi)) * 0.5 + 0.5 }


public func miterLength(#lineWidth: Float, #phi: Float) -> Float { return lineWidth * (1.0 / sinf(phi / 2.0)) }
public func miterLength(#lineWidth: Double, #phi: Double) -> Double { return lineWidth * (1.0 / sin(phi / 2.0)) }
public func miterLength(#lineWidth: CGFloat, #phi: CGFloat) -> CGFloat { return lineWidth * (1.0 / sin(phi / 2.0)) }


public func binarySearch(var #min: Float, var #max: Float, #epsilon: Float, #test:(Float) -> NSComparisonResult) {
    var value: Float
    var done: Bool = false
    do {
        value = denormalize(0.5, min, max)
        let result: NSComparisonResult = test(value)
        switch result {
        case .OrderedAscending:
            min = value
        case .OrderedDescending:
            max = value
        case .OrderedSame:
            min = value
            max = value
        }
        if fabs(max - min) <= epsilon {
            done = true
        }
    } while(!done)
}

public func binarySearch(var #min: Double, var #max: Double, #epsilon: Double, #test:(Double) -> NSComparisonResult) {
    var value: Double
    var done: Bool = false
    do {
        value = denormalize(0.5, min, max)
        let result: NSComparisonResult = test(value)
        switch result {
        case .OrderedAscending:
            min = value
        case .OrderedDescending:
            max = value
        case .OrderedSame:
            min = value
            max = value
        }
        if fabs(max - min) <= epsilon {
            done = true
        }
    } while(!done)
}

public func binarySearch(var #min: CGFloat, var #max: CGFloat, #epsilon: CGFloat, #test:(CGFloat) -> NSComparisonResult) {
    var value: CGFloat
    var done: Bool = false
    do {
        value = denormalize(0.5, min, max)
        let result: NSComparisonResult = test(value)
        switch result {
        case .OrderedAscending:
            min = value
        case .OrderedDescending:
            max = value
        case .OrderedSame:
            min = value
            max = value
        }
        if fabs(max - min) <= epsilon {
            done = true
        }
    } while(!done)
}
