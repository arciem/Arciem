//
//  Geometry.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

#if os(OSX)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

public let goldenRatio: Double = 1.61803398874989484820
public let pointsPerInch: Double = 72.0
public let pi = M_PI
public let piOverTwo = M_PI_2
public let twoPi = 2.0 * M_PI
public let rad2deg = 180.0 / M_PI
public let deg2rad = M_PI / 180.0

public class Geometry {
}

// Float
extension Geometry {
    public class func distanceSquared(x x: Float, y: Float) -> Float { return x * x + y * y }
    public class func distanceSquared(x1 x1: Float, y1: Float, x2: Float, y2: Float) -> Float { return distanceSquared(x: x2 - x1, y: y2 - y1) }
    
    public class func distance(x x: Float, y: Float) -> Float { return hypotf(x, y) }
    public class func distance(x1 x1: Float, y1: Float, x2: Float, y2: Float) -> Float { return distance(x: x2 - x1, y: y2 - y1) }
    
    public class func distanceSquared(x x: Float, y: Float, z: Float) -> Float { return x * x + y * y + z * z }
    public class func distanceSquared(x1 x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float) -> Float { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }
    
    public class func distance(x x: Float, y: Float, z: Float) -> Float { return sqrtf(distanceSquared(x: x, y: y, z: z)) }
    
    public class func distance(x1 x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float) -> Float { return sqrtf(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }
    
    public class func radiansFromDegrees(degrees: Float) -> Float { return degrees * Float(deg2rad) }
    public class func degreesFromRadians(radians: Float) -> Float { return radians * Float(rad2deg) }
    
    public class func radians(x x: Float, y: Float) -> Float { return atan2f(y, x) }
    public class func radians(x1 x1: Float, y1: Float, x2: Float, y2: Float) -> Float { return radians(x: x2 - x1, y: y2 - y1) }
    
    public class func degrees(x x: Float, y: Float) -> Float { return degreesFromRadians(radians(x: x, y: y)) }
    public class func degrees(x1 x1: Float, y1: Float, x2: Float, y2: Float) -> Float { return degrees(x: x2 - x1, y: y2 - y1) }
    
    public class func area(x x: Float, y: Float) -> Float { return x * y; }
    public class func volume(x x: Float, y: Float, z: Float) -> Float { return x * y * z; }
    
    public class func dot(x1 x1: Float, y1: Float, x2: Float, y2: Float) -> Float { return x1 * x2 + y1 * y2; }
    public class func dot(x1 x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float) -> Float { return x1 * x2 + y1 * y2 + z1 * z2; }
    
    public class func cross(x1 x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float) -> (x:Float, y:Float, z:Float) {
        return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
    }
    
    public class func scale(dx dx: Float, dy: Float, s: Float) -> (dx: Float, dy: Float) { return (dx: dx * s, dy: dy * s) }
    public class func scale(dx dx: Float, dy: Float, dz: Float, s: Float) -> (dx: Float, dy: Float, dz: Float) { return (dx: dx * s, dy: dy * s, dz: dz * s) }
    public class func scale(dx dx: Float, dy: Float, sx: Float, sy: Float) -> (dx: Float, dy: Float) { return (dx: dx * sx, dy: dy * sy) }
    public class func scale(dx dx: Float, dy: Float, dz: Float, sx: Float, sy: Float, sz: Float) -> (dx: Float, dy: Float, dz: Float) { return (dx: dx * sx, dy: dy * sy, dz: dz * sz) }
    
    public class func normalize(x x: Float, y: Float) -> (x: Float, y: Float) {
        let d = distance(x: x, y: y); return (x: x / d, y: y / d)
    }
    public class func normalize(x x: Float, y: Float, z: Float) -> (x: Float, y: Float, z: Float) {
        let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
    }
    
    public class func normalize(radians radians: Float) -> Float {
        let p2 = Float(twoPi)
        
        if radians > p2 {
            let r2 = radians - p2
            if r2 > p2 {
                return r2 % p2
            }
        } else if radians < 0.0 {
            let r2 = radians + p2
            if r2 < 0.0 {
                return r2 % p2
            }
        }
        
        return radians
    }
    
    public class func normalize(degrees degrees: Float) -> Float {
        return normalize(radians: radiansFromDegrees(degrees))
    }
    
    public class func rotate<A: Angle>(x x: Float, y: Float, angle: A) -> (x: Float, y: Float) {
        let ca = Float(angle.cos)
        let sa = Float(angle.sin)
        return (x: x * ca - y * sa, y: y * ca + x * sa)
    }
    
    public class func fromPolar<A: Angle>(radius radius: Float, angle: A) -> (x: Float, y: Float) {
        let r = Double(radius)
        return (x: Float(r * angle.cos), y: Float(r * angle.sin))
    }
    
    public class func interpolate(x1 x1: Float, y1: Float, x2: Float, y2: Float, t: Float) -> (x: Float, y: Float) {
        return (x: Math.interpolate(t, x1, x2), y: Math.interpolate(t, y1, y2))
    }
    
    public class func scaleForAspectFit(dxContent dxContent: Float, dyContent: Float, dxArea: Float, dyArea: Float) -> Float {
        return fminf(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func scaleForAspectFill(dxContent dxContent: Float, dyContent: Float, dxArea: Float, dyArea: Float) -> Float {
        return fminf(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func aspectFit(dxContent dxContent: Float, dyContent: Float, dxArea: Float, dyArea: Float) -> (dx: Float, dy: Float) {
        let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    public class func aspectFill(dxContent dxContent: Float, dyContent: Float, dxArea: Float, dyArea: Float) -> (dx: Float, dy: Float) {
        let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    // These versions use parabola segments (hermite curves)
    public class func easeOutFast(t: Float) -> Float { let f = Math.clamp(t); return 2 * f - f * f }
    public class func easeInFast(t: Float) -> Float { let f = Math.clamp(t); return f * f }
    public class func easeInAndOutFast(t: Float) -> Float { let f = Math.clamp(t); return f * f * (3.0 - 2.0 * f) }
    
    // These versions use sine curve segments, and are more computationally intensive
    public class func easeOut(t: Float) -> Float { let f = Math.clamp(t); return sinf(f * Float(piOverTwo)) }
    public class func easeIn(t: Float) -> Float { let f = Math.clamp(t); return 1.0 - cosf(f * Float(piOverTwo)) }
    public class func easeInAndOut(t: Float) -> Float { let f = Math.clamp(t); return 0.5 * (1 + sinf(Float(pi) * (f - 0.5))) }
    
    public class func triangleUpThenDown(t: Float) -> Float { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 0.0, 1.0) : Math.map(f, 0.5, 1.0, 1.0, 0.0) }
    public class func triangleDownThenUp(t: Float) -> Float { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 1.0, 0.0) : Math.map(f, 0.5, 1.0, 0.0, 1.0) }
    public class func sawtoothUp(t: Float) -> Float { return Math.fract(t) }
    public class func sawtoothDown(t: Float) -> Float { return 1.0 - Math.fract(t) }
    
    public class func sineUpThenDown(t: Float) -> Float { return sinf(t * Float(twoPi)) * 0.5 + 0.5 }
    public class func sineDownThenUp(t: Float) -> Float { return 1.0 - sinf(t * Float(twoPi)) * 0.5 + 0.5 }
    public class func cosineUpThenDown(t: Float) -> Float { return 1.0 - sinf(t * Float(twoPi)) * 0.5 + 0.5 }
    public class func cosineDownThenUp(t: Float) -> Float { return sinf(t * Float(twoPi)) * 0.5 + 0.5 }
    
    public class func miterLength(lineWidth lineWidth: Float, phi: Float) -> Float { return lineWidth * (1.0 / sinf(phi / 2.0)) }
    
    
    public class func binarySearch(var min min: Float, var max: Float, epsilon: Float, test:(Float) -> NSComparisonResult) {
        var value: Float
        var done: Bool = false
        repeat {
            value = Math.denormalize(0.5, min, max)
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
            if Float.abs(max - min) <= epsilon {
                done = true
            }
        } while(!done)
    }
}


// Double
extension Geometry {
    public class func distanceSquared(x x: Double, y: Double) -> Double { return x * x + y * y }
    public class func distanceSquared(x1 x1: Double, y1: Double, x2: Double, y2: Double) -> Double { return distanceSquared(x: x2 - x1, y: y2 - y1) }
    
    public class func distance(x x: Double, y: Double) -> Double { return hypot(x, y) }
    public class func distance(x1 x1: Double, y1: Double, x2: Double, y2: Double) -> Double { return distance(x: x2 - x1, y: y2 - y1) }
    
    public class func distanceSquared(x x: Double, y: Double, z: Double) -> Double { return x * x + y * y + z * z }
    public class func distanceSquared(x1 x1: Double, y1: Double, z1: Double, x2: Double, y2: Double, z2: Double) -> Double { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }
    
    public class func distance(x x: Double, y: Double, z: Double) -> Double { return sqrt(distanceSquared(x: x, y: y, z: z)) }
    
    public class func distance(x1 x1: Double, y1: Double, z1: Double, x2: Double, y2: Double, z2: Double) -> Double { return sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }
    
    public class func radiansFromDegrees(degrees: Double) -> Double { return degrees * Double(deg2rad) }
    public class func degreesFromRadians(radians: Double) -> Double { return radians * Double(rad2deg) }
    
    public class func radians(x x: Double, y: Double) -> Double { return atan2(y, x) }
    public class func radians(x1 x1: Double, y1: Double, x2: Double, y2: Double) -> Double { return radians(x: x2 - x1, y: y2 - y1) }
    
    public class func degrees(x x: Double, y: Double) -> Double { return degreesFromRadians(radians(x: x, y: y)) }
    public class func degrees(x1 x1: Double, y1: Double, x2: Double, y2: Double) -> Double { return degrees(x: x2 - x1, y: y2 - y1) }
    
    public class func area(x x: Double, y: Double) -> Double { return x * y; }
    public class func volume(x x: Double, y: Double, z: Double) -> Double { return x * y * z; }
    
    public class func dot(x1 x1: Double, y1: Double, x2: Double, y2: Double) -> Double { return x1 * x2 + y1 * y2; }
    public class func dot(x1 x1: Double, y1: Double, z1: Double, x2: Double, y2: Double, z2: Double) -> Double { return x1 * x2 + y1 * y2 + z1 * z2; }
    
    public class func cross(x1 x1: Double, y1: Double, z1: Double, x2: Double, y2: Double, z2: Double) -> (x:Double, y:Double, z:Double) {
        return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
    }
    
    public class func scale(dx dx: Double, dy: Double, s: Double) -> (dx: Double, dy: Double) { return (dx: dx * s, dy: dy * s) }
    public class func scale(dx dx: Double, dy: Double, dz: Double, s: Double) -> (dx: Double, dy: Double, dz: Double) { return (dx: dx * s, dy: dy * s, dz: dz * s) }
    public class func scale(dx dx: Double, dy: Double, sx: Double, sy: Double) -> (dx: Double, dy: Double) { return (dx: dx * sx, dy: dy * sy) }
    public class func scale(dx dx: Double, dy: Double, dz: Double, sx: Double, sy: Double, sz: Double) -> (dx: Double, dy: Double, dz: Double) { return (dx: dx * sx, dy: dy * sy, dz: dz * sz) }
    
    public class func normalize(x x: Double, y: Double) -> (x: Double, y: Double) {
        let d = distance(x: x, y: y); return (x: x / d, y: y / d)
    }
    public class func normalize(x x: Double, y: Double, z: Double) -> (x: Double, y: Double, z: Double) {
        let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
    }
    
    public class func normalize(radians radians: Double) -> Double {
        let p2 = Double(twoPi)
        
        if radians > p2 {
            let r2 = radians - p2
            if r2 > p2 {
                return r2 % p2
            }
        } else if radians < 0.0 {
            let r2 = radians + p2
            if r2 < 0.0 {
                return r2 % p2
            }
        }
        
        return radians
    }
    
    public class func normalize(degrees degrees: Double) -> Double {
        return normalize(radians: radiansFromDegrees(degrees))
    }
    
    public class func rotate<A: Angle>(x x: Double, y: Double, angle: A) -> (x: Double, y: Double) {
        let ca = angle.cos
        let sa = angle.sin
        return (x: x * ca - y * sa, y: y * ca + x * sa)
    }
    
    public class func fromPolar<A: Angle>(radius radius: Double, angle: A) -> (x: Double, y: Double) {
        let r = Double(radius)
        return (x: r * angle.cos, y: r * angle.sin)
    }
    
    public class func interpolate(x1 x1: Double, y1: Double, x2: Double, y2: Double, t: Double) -> (x: Double, y: Double) {
        return (x: Math.interpolate(t, x1, x2), y: Math.interpolate(t, y1, y2))
    }
    
    public class func scaleForAspectFit(dxContent dxContent: Double, dyContent: Double, dxArea: Double, dyArea: Double) -> Double {
        return fmin(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func scaleForAspectFill(dxContent dxContent: Double, dyContent: Double, dxArea: Double, dyArea: Double) -> Double {
        return fmin(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func aspectFit(dxContent dxContent: Double, dyContent: Double, dxArea: Double, dyArea: Double) -> (dx: Double, dy: Double) {
        let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    public class func aspectFill(dxContent dxContent: Double, dyContent: Double, dxArea: Double, dyArea: Double) -> (dx: Double, dy: Double) {
        let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    // These versions use parabola segments (hermite curves)
    public class func easeOutFast(t: Double) -> Double { let f = Math.clamp(t); return 2 * f - f * f }
    public class func easeInFast(t: Double) -> Double { let f = Math.clamp(t); return f * f }
    public class func easeInAndOutFast(t: Double) -> Double { let f = Math.clamp(t); return f * f * (3.0 - 2.0 * f) }
    
    // These versions use sine curve segments, and are more computationally intensive
    public class func easeOut(t: Double) -> Double { let f = Math.clamp(t); return sin(f * Double(piOverTwo)) }
    public class func easeIn(t: Double) -> Double { let f = Math.clamp(t); return 1.0 - cos(f * Double(piOverTwo)) }
    public class func easeInAndOut(t: Double) -> Double { let f = Math.clamp(t); return 0.5 * (1 + sin(Double(pi) * (f - 0.5))) }
    
    public class func triangleUpThenDown(t: Double) -> Double { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 0.0, 1.0) : Math.map(f, 0.5, 1.0, 1.0, 0.0) }
    public class func triangleDownThenUp(t: Double) -> Double { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 1.0, 0.0) : Math.map(f, 0.5, 1.0, 0.0, 1.0) }
    public class func sawtoothUp(t: Double) -> Double { return Math.fract(t) }
    public class func sawtoothDown(t: Double) -> Double { return 1.0 - Math.fract(t) }
    
    public class func sineUpThenDown(t: Double) -> Double { return sin(t * Double(twoPi)) * 0.5 + 0.5 }
    public class func sineDownThenUp(t: Double) -> Double { return 1.0 - sin(t * Double(twoPi)) * 0.5 + 0.5 }
    public class func cosineUpThenDown(t: Double) -> Double { return 1.0 - sin(t * Double(twoPi)) * 0.5 + 0.5 }
    public class func cosineDownThenUp(t: Double) -> Double { return sin(t * Double(twoPi)) * 0.5 + 0.5 }
    
    public class func miterLength(lineWidth lineWidth: Double, phi: Double) -> Double { return lineWidth * (1.0 / sin(phi / 2.0)) }
    
    
    public class func binarySearch(var min min: Double, var max: Double, epsilon: Double, test:(Double) -> NSComparisonResult) {
        var value: Double
        var done: Bool = false
        repeat {
            value = Math.denormalize(0.5, min, max)
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
            if Double.abs(max - min) <= epsilon {
                done = true
            }
        } while(!done)
    }
}



// CGFloat
extension Geometry {
    public class func distanceSquared(x x: CGFloat, y: CGFloat) -> CGFloat { return x * x + y * y }
    public class func distanceSquared(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat { return distanceSquared(x: x2 - x1, y: y2 - y1) }
    
    public class func distance(x x: CGFloat, y: CGFloat) -> CGFloat { return hypot(x, y) }
    public class func distance(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat { return distance(x: x2 - x1, y: y2 - y1) }
    
    public class func distanceSquared(x x: CGFloat, y: CGFloat, z: CGFloat) -> CGFloat { return x * x + y * y + z * z }
    public class func distanceSquared(x1 x1: CGFloat, y1: CGFloat, z1: CGFloat, x2: CGFloat, y2: CGFloat, z2: CGFloat) -> CGFloat { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }
    
    public class func distance(x x: CGFloat, y: CGFloat, z: CGFloat) -> CGFloat { return sqrt(distanceSquared(x: x, y: y, z: z)) }
    
    public class func distance(x1 x1: CGFloat, y1: CGFloat, z1: CGFloat, x2: CGFloat, y2: CGFloat, z2: CGFloat) -> CGFloat { return sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }
    
    public class func radiansFromDegrees(degrees: CGFloat) -> CGFloat { return degrees * CGFloat(deg2rad) }
    public class func degreesFromRadians(radians: CGFloat) -> CGFloat { return radians * CGFloat(rad2deg) }
    
    public class func radians(x x: CGFloat, y: CGFloat) -> CGFloat { return atan2(y, x) }
    public class func radians(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat { return radians(x: x2 - x1, y: y2 - y1) }
    
    public class func degrees(x x: CGFloat, y: CGFloat) -> CGFloat { return degreesFromRadians(radians(x: x, y: y)) }
    public class func degrees(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat { return degrees(x: x2 - x1, y: y2 - y1) }
    
    public class func area(x x: CGFloat, y: CGFloat) -> CGFloat { return x * y; }
    public class func volume(x x: CGFloat, y: CGFloat, z: CGFloat) -> CGFloat { return x * y * z; }
    
    public class func dot(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat { return x1 * x2 + y1 * y2; }
    public class func dot(x1 x1: CGFloat, y1: CGFloat, z1: CGFloat, x2: CGFloat, y2: CGFloat, z2: CGFloat) -> CGFloat { return x1 * x2 + y1 * y2 + z1 * z2; }
    
    public class func cross(x1 x1: CGFloat, y1: CGFloat, z1: CGFloat, x2: CGFloat, y2: CGFloat, z2: CGFloat) -> (x:CGFloat, y:CGFloat, z:CGFloat) {
        return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
    }
    
    public class func scale(dx dx: CGFloat, dy: CGFloat, s: CGFloat) -> (dx: CGFloat, dy: CGFloat) { return (dx: dx * s, dy: dy * s) }
    public class func scale(dx dx: CGFloat, dy: CGFloat, dz: CGFloat, s: CGFloat) -> (dx: CGFloat, dy: CGFloat, dz: CGFloat) { return (dx: dx * s, dy: dy * s, dz: dz * s) }
    public class func scale(dx dx: CGFloat, dy: CGFloat, sx: CGFloat, sy: CGFloat) -> (dx: CGFloat, dy: CGFloat) { return (dx: dx * sx, dy: dy * sy) }
    public class func scale(dx dx: CGFloat, dy: CGFloat, dz: CGFloat, sx: CGFloat, sy: CGFloat, sz: CGFloat) -> (dx: CGFloat, dy: CGFloat, dz: CGFloat) { return (dx: dx * sx, dy: dy * sy, dz: dz * sz) }
    
    public class func normalize(x x: CGFloat, y: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let d = distance(x: x, y: y); return (x: x / d, y: y / d)
    }
    public class func normalize(x x: CGFloat, y: CGFloat, z: CGFloat) -> (x: CGFloat, y: CGFloat, z: CGFloat) {
        let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
    }
    
    public class func normalize(radians radians: CGFloat) -> CGFloat {
        let p2 = CGFloat(twoPi)
        
        if radians > p2 {
            let r2 = radians - p2
            if r2 > p2 {
                return r2 % p2
            }
        } else if radians < 0.0 {
            let r2 = radians + p2
            if r2 < 0.0 {
                return r2 % p2
            }
        }
        
        return radians
    }
    
    public class func normalize(degrees degrees: CGFloat) -> CGFloat {
        return normalize(radians: radiansFromDegrees(degrees))
    }
    
    public class func rotate<A: Angle>(x x: CGFloat, y: CGFloat, angle: A) -> (x: CGFloat, y: CGFloat) {
        let ca = CGFloat(angle.cos)
        let sa = CGFloat(angle.sin)
        return (x: x * ca - y * sa, y: y * ca + x * sa)
    }
    
    public class func fromPolar<A: Angle>(radius radius: CGFloat, angle: A) -> (x: CGFloat, y: CGFloat) {
        let r = Double(radius)
        return (x: CGFloat(r * angle.cos), y: CGFloat(r * angle.sin))
    }
    
    public class func interpolate(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, t: CGFloat) -> (x: CGFloat, y: CGFloat) {
        return (x: Math.interpolate(t, x1, x2), y: Math.interpolate(t, y1, y2))
    }
    
    public class func scaleForAspectFit(dxContent dxContent: CGFloat, dyContent: CGFloat, dxArea: CGFloat, dyArea: CGFloat) -> CGFloat {
        return fmin(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func scaleForAspectFill(dxContent dxContent: CGFloat, dyContent: CGFloat, dxArea: CGFloat, dyArea: CGFloat) -> CGFloat {
        return fmax(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func aspectFit(dxContent dxContent: CGFloat, dyContent: CGFloat, dxArea: CGFloat, dyArea: CGFloat) -> (dx: CGFloat, dy: CGFloat) {
        let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    public class func aspectFill(dxContent dxContent: CGFloat, dyContent: CGFloat, dxArea: CGFloat, dyArea: CGFloat) -> (dx: CGFloat, dy: CGFloat) {
        let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    // These versions use parabola segments (hermite curves)
    public class func easeOutFast(t: CGFloat) -> CGFloat { let f = Math.clamp(t); return 2 * f - f * f }
    public class func easeInFast(t: CGFloat) -> CGFloat { let f = Math.clamp(t); return f * f }
    public class func easeInAndOutFast(t: CGFloat) -> CGFloat { let f = Math.clamp(t); return f * f * (3.0 - 2.0 * f) }
    
    // These versions use sine curve segments, and are more computationally intensive
    public class func easeOut(t: CGFloat) -> CGFloat { let f = Math.clamp(t); return sin(f * CGFloat(piOverTwo)) }
    public class func easeIn(t: CGFloat) -> CGFloat { let f = Math.clamp(t); return 1.0 - cos(f * CGFloat(piOverTwo)) }
    public class func easeInAndOut(t: CGFloat) -> CGFloat { let f = Math.clamp(t); return 0.5 * (1 + sin(CGFloat(pi) * (f - 0.5))) }
    
    public class func triangleUpThenDown(t: CGFloat) -> CGFloat { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 0.0, 1.0) : Math.map(f, 0.5, 1.0, 1.0, 0.0) }
    public class func triangleDownThenUp(t: CGFloat) -> CGFloat { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 1.0, 0.0) : Math.map(f, 0.5, 1.0, 0.0, 1.0) }
    public class func sawtoothUp(t: CGFloat) -> CGFloat { return Math.fract(t) }
    public class func sawtoothDown(t: CGFloat) -> CGFloat { return 1.0 - Math.fract(t) }
    
    public class func sineUpThenDown(t: CGFloat) -> CGFloat { return sin(t * CGFloat(twoPi)) * 0.5 + 0.5 }
    public class func sineDownThenUp(t: CGFloat) -> CGFloat { return 1.0 - sin(t * CGFloat(twoPi)) * 0.5 + 0.5 }
    public class func cosineUpThenDown(t: CGFloat) -> CGFloat { return 1.0 - sin(t * CGFloat(twoPi)) * 0.5 + 0.5 }
    public class func cosineDownThenUp(t: CGFloat) -> CGFloat { return sin(t * CGFloat(twoPi)) * 0.5 + 0.5 }
    
    public class func miterLength(lineWidth lineWidth: CGFloat, phi: CGFloat) -> CGFloat { return lineWidth * (1.0 / sin(phi / 2.0)) }
    
    
    public class func binarySearch(var min min: CGFloat, var max: CGFloat, epsilon: CGFloat, test:(CGFloat) -> NSComparisonResult) {
        var value: CGFloat
        var done: Bool = false
        repeat {
            value = Math.denormalize(0.5, min, max)
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
            if CGFloat.abs(max - min) <= epsilon {
                done = true
            }
        } while(!done)
    }
}