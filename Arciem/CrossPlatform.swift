//
//  CrossPlatform.swift
//  Arciem
//
//  Created by Robert McNally on 3/14/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import QuartzCore
import CoreGraphics

#if os(iOS)
    import UIKit
    public typealias OSView = UIView
    public typealias OSLayoutPriority = UILayoutPriority
    public typealias OSImageView = UIImageView
    public typealias OSColor = UIColor
    public typealias OSBezierPath = UIBezierPath
    public typealias OSImage = UIImage
    public typealias OSFont = UIFont
    #elseif os(OSX)
    import Cocoa
    public typealias OSView = NSView
    public typealias OSLayoutPriority = NSLayoutPriority
    public typealias OSImageView = NSImageView
    public typealias OSColor = NSColor
    public typealias OSBezierPath = NSBezierPath
    public typealias OSImage = NSImage
    public typealias OSFont = NSFont
#endif

extension OSView {
    public var osTranslatesAutoresizingMaskIntoConstraints: Bool {
        get {
            #if os(iOS)
                return translatesAutoresizingMaskIntoConstraints
            #elseif os(OSX)
                return translatesAutoresizingMaskIntoConstraints
            #endif
        }
    }
    public var osHasAmbiguousLayout: Bool {
        get {
            #if os(iOS)
                return hasAmbiguousLayout()
            #elseif os(OSX)
                return hasAmbiguousLayout
            #endif
        }
    }
    public var osConstraints: [AnyObject] {
        get {
            #if os(iOS)
                return constraints
            #elseif os(OSX)
                return constraints
            #endif
        }
    }
    public var osAlpha: CGFloat {
        get {
            #if os(iOS)
                return alpha
            #elseif os(OSX)
                return alphaValue
            #endif
        }
        set {
            #if os(iOS)
                alpha = newValue
            #elseif os(OSX)
                alphaValue = newValue
            #endif
        }
    }
}

public func OSGraphicsGetCurrentContext() -> CGContextRef {
    #if os(iOS)
        return UIGraphicsGetCurrentContext()
    #elseif os(OSX)
        return NSGraphicsContext.currentContext()!.CGContext
    #endif
}

#if os(OSX)
    extension NSColor {
        public class func osColorWithCGColor(cgColor: CGColorRef) -> NSColor {
            return NSColor(CGColor: cgColor)!
        }
    }
#elseif os(iOS)
    extension UIColor {
        public class func osColorWithCGColor(cgColor: CGColorRef) -> UIColor {
            return UIColor(CGColor: cgColor)
        }
    }
#endif

#if os(OSX)
    extension NSView {
        public var center: CGPoint {
            get {
                return frame.mid
            }
        }
    }
#endif

#if os(OSX)
    public let OSBlendModeNormal = CGBlendMode.Normal
    public let OSBlendModeMultiply = CGBlendMode.Multiply
    public let OSBlendModeScreen = CGBlendMode.Screen
    public let OSBlendModeOverlay = CGBlendMode.Overlay
    public let OSBlendModeDarken = CGBlendMode.Darken
    public let OSBlendModeLighten = CGBlendMode.Lighten
    public let OSBlendModeColorDodge = CGBlendMode.ColorDodge
    public let OSBlendModeColorBurn = CGBlendMode.ColorBurn
    public let OSBlendModeSoftLight = CGBlendMode.SoftLight
    public let OSBlendModeHardLight = CGBlendMode.HardLight
    public let OSBlendModeDifference = CGBlendMode.Difference
    public let OSBlendModeExclusion = CGBlendMode.Exclusion
    public let OSBlendModeHue = CGBlendMode.Hue
    public let OSBlendModeSaturation = CGBlendMode.Saturation
    public let OSBlendModeColor = CGBlendMode.Color
    public let OSBlendModeLuminosity = CGBlendMode.Luminosity
    public let OSBlendModeClear = CGBlendMode.Clear
    public let OSBlendModeCopy = CGBlendMode.Copy
    public let OSBlendModeSourceIn = CGBlendMode.SourceIn
    public let OSBlendModeSourceOut = CGBlendMode.SourceOut
    public let OSBlendModeSourceAtop = CGBlendMode.SourceAtop
    public let OSBlendModeDestinationOver = CGBlendMode.DestinationOver
    public let OSBlendModeDestinationIn = CGBlendMode.DestinationIn
    public let OSBlendModeDestinationOut = CGBlendMode.DestinationOut
    public let OSBlendModeDestinationAtop = CGBlendMode.DestinationAtop
    public let OSBlendModeXOR = CGBlendMode.XOR
    public let OSBlendModePlusDarker = CGBlendMode.PlusDarker
    public let OSBlendModePlusLighter = CGBlendMode.PlusLighter
#elseif os(iOS)
    public let OSBlendModeNormal = kCGBlendModeNormal
    public let OSBlendModeMultiply = kCGBlendModeMultiply
    public let OSBlendModeScreen = kCGBlendModeScreen
    public let OSBlendModeOverlay = kCGBlendModeOverlay
    public let OSBlendModeDarken = kCGBlendModeDarken
    public let OSBlendModeLighten = kCGBlendModeLighten
    public let OSBlendModeColorDodge = kCGBlendModeColorDodge
    public let OSBlendModeColorBurn = kCGBlendModeColorBurn
    public let OSBlendModeSoftLight = kCGBlendModeSoftLight
    public let OSBlendModeHardLight = kCGBlendModeHardLight
    public let OSBlendModeDifference = kCGBlendModeDifference
    public let OSBlendModeExclusion = kCGBlendModeExclusion
    public let OSBlendModeHue = kCGBlendModeHue
    public let OSBlendModeSaturation = kCGBlendModeSaturation
    public let OSBlendModeColor = kCGBlendModeColor
    public let OSBlendModeLuminosity = kCGBlendModeLuminosity
    public let OSBlendModeClear = kCGBlendModeClear
    public let OSBlendModeCopy = kCGBlendModeCopy
    public let OSBlendModeSourceIn = kCGBlendModeSourceIn
    public let OSBlendModeSourceOut = kCGBlendModeSourceOut
    public let OSBlendModeSourceAtop = kCGBlendModeSourceAtop
    public let OSBlendModeDestinationOver = kCGBlendModeDestinationOver
    public let OSBlendModeDestinationIn = kCGBlendModeDestinationIn
    public let OSBlendModeDestinationOut = kCGBlendModeDestinationOut
    public let OSBlendModeDestinationAtop = kCGBlendModeDestinationAtop
    public let OSBlendModeXOR = kCGBlendModeXOR
    public let OSBlendModePlusDarker = kCGBlendModePlusDarker
    public let OSBlendModePlusLighter = kCGBlendModePlusLighter
#endif

#if os(OSX)
    extension NSBezierPath {
        public convenience init (arcCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
            self.init()
            appendBezierPathWithArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }
        
        public var CGPath: CGPathRef {
            get {
                let path = CGPathCreateMutable()

                let numElements = elementCount
                if numElements > 0 {
                    var points = [NSPoint](count:3, repeatedValue:NSPoint.zeroPoint)
                    var didClosePath = true
                    
                    for var i: Int = 0; i < numElements; i++ {
                        switch elementAtIndex(i, associatedPoints:&points) {
                        case NSBezierPathElement.MoveToBezierPathElement:
                            CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
                            
                        case NSBezierPathElement.LineToBezierPathElement:
                            CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
                            didClosePath = false;
                            
                        case NSBezierPathElement.CurveToBezierPathElement:
                            CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y,
                                points[1].x, points[1].y,
                                points[2].x, points[2].y)
                            didClosePath = false
                            
                        case NSBezierPathElement.ClosePathBezierPathElement:
                            CGPathCloseSubpath(path)
                            didClosePath = true
                        }
                    }
                    
                    // Be sure the path is closed or Quartz may not do valid hit detection.
                    if !didClosePath {
                        CGPathCloseSubpath(path)
                    }
                }
                return CGPathCreateCopy(path)!
            }
        }
    }
#endif
