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

public class Geometry {
    public class func distanceSquared<T: Floatable>(#x: T, y: T) -> T { return x * x + y * y }
    public class func distanceSquared<T: Floatable>(#x1: T, y1: T, x2: T, y2: T) -> T { return distanceSquared(x: x2 - x1, y: y2 - y1) }
    
    public class func distance<T: Floatable>(#x: T, y: T) -> T { return T.hypot(x, y) }
    public class func distance<T: Floatable>(#x1: T, y1: T, x2: T, y2: T) -> T { return distance(x: x2 - x1, y: y2 - y1) }
    
    public class func distanceSquared<T: Floatable>(#x: T, y: T, z: T) -> T { return x * x + y * y + z * z }
    public class func distanceSquared<T: Floatable>(#x1: T, y1: T, z1: T, x2: T, y2: T, z2: T) -> T { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }
    
    public class func distance<T: Floatable>(#x: T, y: T, z: T) -> T { return T.sqrt(distanceSquared(x: x, y: y, z: z)) }
    
    public class func distance<T: Floatable>(#x1: T, y1: T, z1: T, x2: T, y2: T, z2: T) -> T { return T.sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }
    
    public class func radians<T: Floatable>(#x: T, y: T) -> Radians<T> { return Radians(radians:T.atan2(y, x)) }
    public class func radians<T: Floatable>(#x1: T, y1: T, x2: T, y2: T) -> Radians<T> { return radians(x: x2 - x1, y: y2 - y1) }
    
    public class func degrees<T: Floatable>(#x: T, y: T) -> Degrees<T> { return Degrees(radians:T.atan2(y, x)) }
    public class func degrees<T: Floatable>(#x1: T, y1: T, x2: T, y2: T) -> Degrees<T> { return degrees(x: x2 - x1, y: y2 - y1) }
    
    public class func area<T: Floatable>(#x: T, y: T) -> T { return x * y; }
    public class func volume<T: Floatable>(#x: T, y: T, z: T) -> T { return x * y * z; }
    
    public class func dot<T: Floatable>(#x1: T, y1: T, x2: T, y2: T) -> T { return x1 * x2 + y1 * y2; }
    public class func dot<T: Floatable>(#x1: T, y1: T, z1: T, x2: T, y2: T, z2: T) -> T { return x1 * x2 + y1 * y2 + z1 * z2; }
    
    public class func cross<T: Floatable>(#x1: T, y1: T, z1: T, x2: T, y2: T, z2: T) -> (x:T, y:T, z:T) {
        return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
    }
    
    public class func scale<T: Floatable>(#dx: T, dy: T, s: T) -> (dx: T, dy: T) { return (dx: dx * s, dy: dy * s) }
    public class func scale<T: Floatable>(#dx: T, dy: T, dz: T, s: T) -> (dx: T, dy: T, dz: T) { return (dx: dx * s, dy: dy * s, dz: dz * s) }
    public class func scale<T: Floatable>(#dx: T, dy: T, sx: T, sy: T) -> (dx: T, dy: T) { return (dx: dx * sx, dy: dy * sy) }
    public class func scale<T: Floatable>(#dx: T, dy: T, dz: T, sx: T, sy: T, sz: T) -> (dx: T, dy: T, dz: T) { return (dx: dx * sx, dy: dy * sy, dz: dz * sz) }
    
    public class func normalize<T: Floatable>(#x: T, y: T) -> (x: T, y: T) {
        let d = distance(x: x, y: y); return (x: x / d, y: y / d)
    }
    public class func normalize<T: Floatable>(#x: T, y: T, z: T) -> (x: T, y: T, z: T) {
        let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
    }
    
    public class func normalize<T>(var #radians: Radians<T>) -> Radians<T> {
        let p2 = Radians<T>(radians:T(twoPi))
        
        if radians > p2 {
            radians -= p2
            if radians > p2 {
                radians = radians % p2
            }
        } else if radians < 0.0 {
            radians += p2
            if radians < 0.0 {
                radians = radians % p2
            }
        }
        
        return radians
    }
    
    public class func normalize<T>(var #degrees: Degrees<T>) -> Degrees<T> {
        return Degrees(normalize(radians:Radians(degrees)))
    }
    
    public class func rotate<A, T where A: Angle, T == A.NativeType, T: Floatable>(#x: T, y: T, angle: A) -> (x: T, y: T) {
        let ca = angle.cos
        let sa = angle.sin
        return (x: x * ca - y * sa, y: y * ca + x * sa)
    }
    
    public class func fromPolar<A, T where A: Angle, T == A.NativeType, T: Floatable>(#radius: T, angle: A) -> (x: T, y: T) {
        return (x: radius * angle.cos, y: radius * angle.sin)
    }
    
    public class func interpolate<T: Floatable>(#x1: T, y1: T, x2: T, y2: T, t: T) -> (x: T, y: T) {
        return (x: Math.interpolate(t, x1, x2), y: Math.interpolate(t, y1, y2))
    }
    
    public class func scaleForAspectFit<T: Floatable>(#dxContent: T, dyContent: T, dxArea: T, dyArea: T) -> T {
        return T.fmin(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func scaleForAspectFill<T: Floatable>(#dxContent: T, dyContent: T, dxArea: T, dyArea: T) -> T {
        return T.fmax(dxArea / dxContent, dyArea / dyContent)
    }
    
    public class func aspectFit<T: Floatable>(#dxContent: T, dyContent: T, dxArea: T, dyArea: T) -> (dx: T, dy: T) {
        let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    public class func aspectFill<T: Floatable>(#dxContent: T, dyContent: T, dxArea: T, dyArea: T) -> (dx: T, dy: T) {
        let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
        return scale(dx: dxContent, dy: dyContent, s: s)
    }
    
    // These versions use parabola segments (hermite curves)
    public class func easeOutFast<T: Floatable>(t: T) -> T { let f = Math.clamp(t); return 2 * f - f * f }
    public class func easeInFast<T: Floatable>(t: T) -> T { let f = Math.clamp(t); return f * f }
    public class func easeInAndOutFast<T: Floatable>(t: T) -> T { let f = Math.clamp(t); return f * f * (3.0 - 2.0 * f) }
    
    // These versions use sine curve segments, and are more computationally intensive
    public class func easeOut<T: Floatable>(t: T) -> T { let f = Math.clamp(t); return T.sin(f * T(piOverTwo)) }
    public class func easeIn<T: Floatable>(t: T) -> T { let f = Math.clamp(t); return 1.0 - T.cos(f * T(piOverTwo)) }
    public class func easeInAndOut<T: Floatable>(t: T) -> T { let f = Math.clamp(t); return 0.5 * (1 + T.sin(T(pi) * (f - 0.5))) }
    
    public class func triangleUpThenDown<T: Floatable>(t: T) -> T { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 0.0, 1.0) : Math.map(f, 0.5, 1.0, 1.0, 0.0) }
    public class func triangleDownThenUp<T: Floatable>(t: T) -> T { let f = Math.fract(t); return f < 0.5 ? Math.map(f, 0.0, 0.5, 1.0, 0.0) : Math.map(f, 0.5, 1.0, 0.0, 1.0) }
    public class func sawtoothUp<T: Floatable>(t: T) -> T { return Math.fract(t) }
    public class func sawtoothDown<T: Floatable>(t: T) -> T { return 1.0 - Math.fract(t) }
    
    public class func sineUpThenDown<T: Floatable>(t: T) -> T { return T.sin(t * T(twoPi)) * 0.5 + 0.5 }
    public class func sineDownThenUp<T: Floatable>(t: T) -> T { return 1.0 - T.sin(t * T(twoPi)) * 0.5 + 0.5 }
    public class func cosineUpThenDown<T: Floatable>(t: T) -> T { return 1.0 - T.cos(t * T(twoPi)) * 0.5 + 0.5 }
    public class func cosineDownThenUp<T: Floatable>(t: T) -> T { return T.cos(t * T(twoPi)) * 0.5 + 0.5 }
    
    public class func miterLength<T: Floatable>(#lineWidth: T, phi: T) -> T { return lineWidth * (1.0 / T.sin(phi / 2.0)) }
    
    
    public class func binarySearch<T: Floatable>(var #min: T, var max: T, epsilon: T, test:(T) -> NSComparisonResult) {
        var value: T
        var done: Bool = false
        do {
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
            if T.abs(max - min) <= epsilon {
                done = true
            }
        } while(!done)
    }
}