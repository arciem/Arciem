//
//  CGColor.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import CoreGraphics

public var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
public var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
public var sharedWhiteColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(1.0), CGFloat(1.0)])
public var sharedBlackColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(0.0), CGFloat(1.0)])
public var sharedClearColor = CGColorCreate(sharedColorSpaceGray, [CGFloat(0.0), CGFloat(0.0)])

public func CGColorCreateByDarkening(#color: CGColor, #fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)

    switch colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color))) {
    case colorSpaceModelValue_glue(kCGColorSpaceModelMonochrome):
        let gray = denormalize(fraction, oldc[0], 0)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case colorSpaceModelValue_glue(kCGColorSpaceModelRGB):
        let r = denormalize(fraction, oldc[0], 0)
        let g = denormalize(fraction, oldc[1], 0)
        let b = denormalize(fraction, oldc[2], 0)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGColorCreateByLightening(#color: CGColor, #fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)
    
    switch colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color))) {
    case colorSpaceModelValue_glue(kCGColorSpaceModelMonochrome):
        let gray = denormalize(fraction, oldc[0], 1)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case colorSpaceModelValue_glue(kCGColorSpaceModelRGB):
        let r = denormalize(fraction, oldc[0], 1)
        let g = denormalize(fraction, oldc[1], 1)
        let b = denormalize(fraction, oldc[2], 1)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGColorCreateByDodging(#color: CGColor, #fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)

    switch colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color))) {
    case colorSpaceModelValue_glue(kCGColorSpaceModelMonochrome):
        let gray = denormalize(fraction, oldc[0], 1)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case colorSpaceModelValue_glue(kCGColorSpaceModelRGB):
        let invertedFraction = 1 - fraction
        let r = fmin(oldc[0] / invertedFraction, 1.0)
        let g = fmin(oldc[1] / invertedFraction, 1.0)
        let b = fmin(oldc[2] / invertedFraction, 1.0)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGColorCreateByBurning(#color: CGColor, #fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc = CGColorGetComponents(color)
    
    switch colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color))) {
    case colorSpaceModelValue_glue(kCGColorSpaceModelMonochrome):
        let gray = denormalize(fraction, oldc[0], 0)
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceGray, [gray, a])
    case colorSpaceModelValue_glue(kCGColorSpaceModelRGB):
        let invertedFraction = 1 - fraction
        let r = fmin((1 - oldc[0]) / invertedFraction, 1.0)
        let g = fmin((1 - oldc[1]) / invertedFraction, 1.0)
        let b = fmin((1 - oldc[2]) / invertedFraction, 1.0)
        let a = oldc[3]
        result = CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
    default:
        fatalError("unsupported color model")
    }
    
    return result
}

public func CGColorCreateByInterpolating(#color1: CGColor, #color2: CGColor, #fraction: CGFloat) -> CGColor! {
    var result: CGColor? = nil
    
    let oldc1 = CGColorGetComponents(color1)
    let oldc2 = CGColorGetComponents(color2)
    
    let colorSpaceModelValue_glue1 = colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color1)))
    let colorSpaceModelValue_glue2 = colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color2)))
    
    if colorSpaceModelValue_glue1 == colorSpaceModelValue_glue2 {
        switch colorSpaceModelValue_glue1 {
        case colorSpaceModelValue_glue(kCGColorSpaceModelMonochrome):
            let gray = interpolate(fraction, oldc1[0], oldc2[0])
            let a = oldc1[1]
            result = CGColorCreate(sharedColorSpaceGray, [gray, a])
        case colorSpaceModelValue_glue(kCGColorSpaceModelRGB):
            let r = interpolate(fraction, oldc1[0], oldc2[0])
            let g = interpolate(fraction, oldc1[1], oldc2[1])
            let b = interpolate(fraction, oldc1[2], oldc2[2])
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

public func CGColorCreate(#r: CGFloat, #g: CGFloat, #b: CGFloat, #a: CGFloat) -> CGColor! {
    return CGColorCreate(sharedColorSpaceRGB, [r, g, b, a])
}

public func CGColorCreate(#gray: CGFloat, #a: CGFloat) -> CGColor! {
    return CGColorCreate(sharedColorSpaceGray, [gray, a])
}

public func CGColorCreateRandom() -> CGColor! {
    var components = Array(count: 4, repeatedValue: CGFloat(0))
    for var i = 0; i < 3; ++i {
        components[i] = CGFloat(random.randomFlat())
    }
    components[3] = 1
    return CGColorCreate(sharedColorSpaceRGB, components)
}

public func CGColorConvertToRGB(color: CGColor) -> CGColor! {
    var result: CGColor! = color
    
    let oldc = CGColorGetComponents(color)
    
    switch colorSpaceModelValue_glue(CGColorSpaceGetModel(CGColorGetColorSpace(color))) {
    case colorSpaceModelValue_glue(kCGColorSpaceModelMonochrome):
        let gray = oldc[0]
        let a = oldc[1]
        result = CGColorCreate(sharedColorSpaceRGB, [gray, gray, gray, a])
    case colorSpaceModelValue_glue(kCGColorSpaceModelRGB):
        break
    default:
        fatalError("unsupported color model")
    }
    
    return result
}
