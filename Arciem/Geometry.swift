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

public func distanceSquared<T: Floatable>(#x: T, #y: T) -> T { return x * x + y * y }
public func distanceSquared<T: Floatable>(#x1: T, #y1: T, #x2: T, #y2: T) -> T { return distanceSquared(x: x2 - x1, y: y2 - y1) }

public func distance<T: Floatable>(#x: T, #y: T) -> T { return T.hypot(x, y) }
public func distance<T: Floatable>(#x1: T, #y1: T, #x2: T, #y2: T) -> T { return distance(x: x2 - x1, y: y2 - y1) }

public func distanceSquared<T: Floatable>(#x: T, #y: T, #z: T) -> T { return x * x + y * y + z * z }
public func distanceSquared<T: Floatable>(#x1: T, #y1: T, #z1: T, #x2: T, #y2: T, #z2: T) -> T { return distanceSquared(x: x2 - x1, y: y2 - y1, z: z2 - z1) }

public func distance<T: Floatable>(#x: T, #y: T, #z: T) -> T { return T.sqrt(distanceSquared(x: x, y: y, z: z)) }

public func distance<T: Floatable>(#x1: T, #y1: T, #z1: T, #x2: T, #y2: T, #z2: T) -> T { return T.sqrt(distance(x: x2 - x1, y: y2 - y1, z: z2 - z1)) }

public func radians<T: Floatable>(#x: T, #y: T) -> Radians<T> { return Radians(radians:T.atan2(y, x)) }
public func radians<T: Floatable>(#x1: T, #y1: T, #x2: T, #y2: T) -> Radians<T> { return radians(x: x2 - x1, y: y2 - y1) }

public func degrees<T: Floatable>(#x: T, #y: T) -> Degrees<T> { return Degrees(radians:T.atan2(y, x)) }
public func degrees<T: Floatable>(#x1: T, #y1: T, #x2: T, #y2: T) -> Degrees<T> { return degrees(x: x2 - x1, y: y2 - y1) }

public func area<T: Floatable>(#x: T, #y: T) -> T { return x * y; }
public func volume<T: Floatable>(#x: T, #y: T, #z: T) -> T { return x * y * z; }

public func dot<T: Floatable>(#x1: T, #y1: T, #x2: T, #y2: T) -> T { return x1 * x2 + y1 * y2; }
public func dot<T: Floatable>(#x1: T, #y1: T, #z1: T, #x2: T, #y2: T, #z2: T) -> T { return x1 * x2 + y1 * y2 + z1 * z2; }

public func cross<T: Floatable>(#x1: T, #y1: T, #z1: T, #x2: T, #y2: T, #z2: T) -> (x:T, y:T, z:T) {
    return (x:z2 * y1 - y2 * z1, y:x2 * z1 - z2 * x1, z:y2 * x1 - x2 * y1)
}

public func scale<T: Floatable>(#x: T, #y: T, #s: T) -> (x: T, y: T) { return (x: x * s, y: y * s) }
public func scale<T: Floatable>(#x: T, #y: T, #z: T, #s: T) -> (x: T, y: T, z: T) { return (x: x * s, y: y * s, z: z * s) }
public func scale<T: Floatable>(#x: T, #y: T, #sx: T, #sy: T) -> (x: T, y: T) { return (x: x * sx, y: y * sy) }
public func scale<T: Floatable>(#x: T, #y: T, #z: T, #sx: T, #sy: T, #sz: T) -> (x: T, y: T, z: T) { return (x: x * sx, y: y * sy, z: z * sz) }

public func normalize<T: Floatable>(#x: T, #y: T) -> (x: T, y: T) {
    let d = distance(x: x, y: y); return (x: x / d, y: y / d)
}
public func normalize<T: Floatable>(#x: T, #y: T, #z: T) -> (x: T, y: T, z: T) {
    let d = distance(x: x, y: y, z: z); return (x: x / d, y: y / d, z: z / d)
}

public func normalize<T>(var #radians: Radians<T>) -> Radians<T> {
    let twoPi = Radians<T>(radians:T(Arciem.twoPi))
    
    if radians > twoPi {
        radians -= twoPi
        if radians > twoPi {
            radians = radians % twoPi
        }
    } else if radians < 0.0 {
        radians += twoPi
        if radians < 0.0 {
            radians = radians % twoPi
        }
    }
    
    return radians
}

public func normalize<T>(var #degrees: Degrees<T>) -> Degrees<T> {
    return Degrees(normalize(radians:Radians(degrees)))
}

public func rotate<A, T where A: Angle, T == A.NativeType, T: Floatable>(#x: T, #y: T, #angle: A) -> (x: T, y: T) {
    let ca = angle.cos
    let sa = angle.sin
    return (x: x * ca - y * sa, y: y * ca + x * sa)
}

public func fromPolar<A, T where A: Angle, T == A.NativeType, T: Floatable>(#radius: T, #angle: A) -> (x: T, y: T) {
    return (x: radius * angle.cos, y: radius * angle.sin)
}

public func interpolate<T: Floatable>(#x1: T, #y1: T, #x2: T, #y2: T, #t: T) -> (x: T, y: T) {
    return (x: interpolate(t, x1, x2), y: interpolate(t, y1, y2))
}

public func scaleForAspectFit<T: Floatable>(#dxContent: T, #dyContent: T, #dxArea: T, #dyArea: T) -> T {
    return T.fmin(dxArea / dxContent, dyArea / dyContent)
}

public func scaleForAspectFill<T: Floatable>(#dxContent: T, #dyContent: T, #dxArea: T, #dyArea: T) -> T {
    return T.fmax(dxArea / dxContent, dyArea / dyContent)
}

public func aspectFit<T: Floatable>(#dxContent: T, #dyContent: T, #dxArea: T, #dyArea: T) -> (x: T, y: T) {
    let s = scaleForAspectFit(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}

public func aspectFill<T: Floatable>(#dxContent: T, #dyContent: T, #dxArea: T, #dyArea: T) -> (x: T, y: T) {
    let s = scaleForAspectFill(dxContent: dxContent, dyContent: dyContent, dxArea: dxArea, dyArea: dyArea)
    return scale(x: dxContent, y: dyContent, s: s)
}

// These versions use parabola segments (hermite curves)
public func easeOutFast<T: Floatable>(t: T) -> T { let f = clamp(t); return 2 * f - f * f }
public func easeInFast<T: Floatable>(t: T) -> T { let f = clamp(t); return f * f }
public func easeInAndOutFast<T: Floatable>(t: T) -> T { let f = clamp(t); return f * f * (3.0 - 2.0 * f) }

// These versions use sine curve segments, and are more computationally intensive
public func easeOut<T: Floatable>(t: T) -> T { let f = clamp(t); return T.sin(f * T(piOverTwo)) }
public func easeIn<T: Floatable>(t: T) -> T { let f = clamp(t); return 1.0 - T.cos(f * T(piOverTwo)) }
public func easeInAndOut<T: Floatable>(t: T) -> T { let f = clamp(t); return 0.5 * (1 + T.sin(T(pi) * (f - 0.5))) }

public func triangleUpThenDown<T: Floatable>(t: T) -> T { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 0.0, 1.0) : map(f, 0.5, 1.0, 1.0, 0.0) }
public func triangleDownThenUp<T: Floatable>(t: T) -> T { let f = fract(t); return f < 0.5 ? map(f, 0.0, 0.5, 1.0, 0.0) : map(f, 0.5, 1.0, 0.0, 1.0) }
public func sawtoothUp<T: Floatable>(t: T) -> T { return fract(t) }
public func sawtoothDown<T: Floatable>(t: T) -> T { return 1.0 - fract(t) }

public func sineUpThenDown<T: Floatable>(t: T) -> T { return T.sin(t * T(twoPi)) * 0.5 + 0.5 }
public func sineDownThenUp<T: Floatable>(t: T) -> T { return 1.0 - T.sin(t * T(twoPi)) * 0.5 + 0.5 }
public func cosineUpThenDown<T: Floatable>(t: T) -> T { return 1.0 - T.cos(t * T(twoPi)) * 0.5 + 0.5 }
public func cosineDownThenUp<T: Floatable>(t: T) -> T { return T.cos(t * T(twoPi)) * 0.5 + 0.5 }

public func miterLength<T: Floatable>(#lineWidth: T, #phi: T) -> T { return lineWidth * (1.0 / T.sin(phi / 2.0)) }


public func binarySearch<T: Floatable>(var #min: T, var #max: T, #epsilon: T, #test:(T) -> NSComparisonResult) {
    var value: T
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
        if T.abs(max - min) <= epsilon {
            done = true
        }
    } while(!done)
}
