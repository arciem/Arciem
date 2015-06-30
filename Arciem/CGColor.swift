//
//  CGColor.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

#if os(OSX)
    import Cocoa
    #elseif os(iOS)
    import UIKit
#endif

import CoreGraphics

public var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
public var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
public var sharedWhiteColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(1.0), CGFloat(1.0)])
public var sharedBlackColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(0.0), CGFloat(1.0)])
public var sharedClearColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(0.0), CGFloat(0.0)])

public func CGColorCreateByDarkening(color color: CGColor, fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)

    switch CGColorSpaceGetModel(CGColorGetColorSpace(color)) {
    case .Monochrome:
        let gray = Math.denormalize(fraction, oldc[0], 0)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case .RGB:
        let r = Math.denormalize(fraction, oldc[0], 0)
        let g = Math.denormalize(fraction, oldc[1], 0)
        let b = Math.denormalize(fraction, oldc[2], 0)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGColorCreateByLightening(color color: CGColor, fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)
    
    switch CGColorSpaceGetModel(CGColorGetColorSpace(color)) {
    case .Monochrome:
        let gray = Math.denormalize(fraction, oldc[0], 1)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case .RGB:
        let r = Math.denormalize(fraction, oldc[0], 1)
        let g = Math.denormalize(fraction, oldc[1], 1)
        let b = Math.denormalize(fraction, oldc[2], 1)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

// Identity fraction is 0.0
public func CGColorCreateByDodging(color color: CGColor, fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)

    switch CGColorSpaceGetModel(CGColorGetColorSpace(color)) {
    case .Monochrome:
        let gray = Math.denormalize(fraction, oldc[0], 1)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case .RGB:
        let f = fmax(1.0 - fraction, 1.0e-7)
        let r = fmin(oldc[0] / f, 1.0)
        let g = fmin(oldc[1] / f, 1.0)
        let b = fmin(oldc[2] / f, 1.0)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

// Identity fraction is 0.0
public func CGColorCreateByBurning(color color: CGColor, fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)
    
    switch CGColorSpaceGetModel(CGColorGetColorSpace(color)) {
    case .Monochrome:
        let gray = Math.denormalize(fraction, oldc[0], 0)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case .RGB:
        let f = fmax(1.0 - fraction, 1.0e-7)
        let r = fmin(1.0 - (1.0 - oldc[0]) / f, 1.0)
        let g = fmin(1.0 - (1.0 - oldc[1]) / f, 1.0)
        let b = fmin(1.0 - (1.0 - oldc[2]) / f, 1.0)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGColorCreateByInterpolating(color1 color1: CGColor, color2: CGColor, fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc1 = CGColorGetComponents(color1)
    let oldc2 = CGColorGetComponents(color2)
    
    let colorSpaceModel1 = CGColorSpaceGetModel(CGColorGetColorSpace(color1))
    let colorSpaceModel2 = CGColorSpaceGetModel(CGColorGetColorSpace(color2))
    
    if colorSpaceModel1 == colorSpaceModel2 {
        switch colorSpaceModel1 {
        case .Monochrome:
            let gray = Math.interpolate(fraction, oldc1[0], oldc2[0])
            let a = oldc1[1]
            result = CGColorCreate(sharedColorSpaceGray, [gray, a])
        case .RGB:
            let r = Math.interpolate(fraction, oldc1[0], oldc2[0])
            let g = Math.interpolate(fraction, oldc1[1], oldc2[1])
            let b = Math.interpolate(fraction, oldc1[2], oldc2[2])
            let a = oldc1[3]
            result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
        default:
            fatalError("unsupported color model")
        }
    } else {
        fatalError("color space mismatch")
    }
    
    return result
}

public func CGColorCreate(r r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> CGColor! {
    return CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
}

public func CGColorCreate(gray gray: CGFloat, a: CGFloat) -> CGColor! {
    return CGColorCreate(sharedColorSpaceGray, [gray, a])
}

public func CGColorCreateRandom(random: Random = Random.sharedInstance) -> CGColor! {
    var components = Array(count: 4, repeatedValue: CGFloat(0))
    for var i = 0; i < 3; ++i {
        components[i] = random.randomCGFloat()
    }
    components[3] = 1
    return CGColorCreate(sharedColorSpaceRGB, components)
}

public func CGColorConvertToRGB(color: CGColor) -> CGColor! {
    var result: CGColor! = color
    
    let oldc = CGColorGetComponents(color)
    
    switch CGColorSpaceGetModel(CGColorGetColorSpace(color)) {
    case .Monochrome:
        let gray = oldc[0]
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceRGB, [gray, gray, gray, a])
    case .RGB:
        break
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGGradientWithColors(colorFracs:[ColorFrac]) -> CGGradient {
    var cgColors = [CGColor]()
    var locations = [CGFloat]()
    for colorFrac in colorFracs {
        cgColors.append(colorFrac.color.cgColor)
        locations.append(CGFloat(colorFrac.frac))
    }
    return CGGradientCreateWithColors(sharedColorSpaceRGB, cgColors, locations)!
}