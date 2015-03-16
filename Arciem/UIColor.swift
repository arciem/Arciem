//
//  Color.swift
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

// The regex below should match all these strings
/*
1 0 0
1.0 0.0 0.0 1.0
r: .1 g: 0.512 b: 0.9 a: 1
red: .1 green: 0.512 blue: 0.9 alpha: 1
h: .1 s: 0.512 b: 0.9 alpha: 1
hue: .1 saturation: 0.512 brightness: 0.9 alpha: 1
*/

// ^\s*(?:(r|h)(?:ed|ue)?:\s*)?(\d*(?:\.\d*)?)\s+(?:(?:g|s)(?:reen|aturation)?:\s*)?(\d*(?:\.\d*)?)\s+(?:(?:b)(?:lue|rightness)?:\s*)?(\d*(?:\.\d*)?)(?:\s+(?:a(?:lpha)?:\s*)?(\d*(?:\.\d*)?))?\s*$
let _colorParsingRegex: NSRegularExpression! = ~/"^\\s*(?:(r|h)(?:ed|ue)?:\\s*)?(\\d*(?:\\.\\d*)?)\\s+(?:(?:g|s)(?:reen|aturation)?:\\s*)?(\\d*(?:\\.\\d*)?)\\s+(?:(?:b)(?:lue|rightness)?:\\s*)?(\\d*(?:\\.\\d*)?)(?:\\s+(?:a(?:lpha)?:\\s*)?(\\d*(?:\\.\\d*)?))?\\s*$"

public extension OSColor {
    public func colorByDarkeningFraction(fraction: CGFloat) -> OSColor {
        return OSColor(CGColor: CGColorCreateByDarkening(color: self.CGColor, fraction: fraction))!
    }

    public func colorByLighteningFraction(fraction: CGFloat) -> OSColor {
        return OSColor(CGColor: CGColorCreateByLightening(color: self.CGColor, fraction: fraction))!
    }
    
    public func colorByDodgingFraction(fraction: CGFloat) -> OSColor {
        return OSColor(CGColor: CGColorCreateByDodging(color: self.CGColor, fraction: fraction))!
    }
    
    public func colorByBurningFraction(fraction: CGFloat) -> OSColor {
        return OSColor(CGColor: CGColorCreateByBurning(color: self.CGColor, fraction: fraction))!
    }
    
    public func colorByInterpolatingFraction(fraction: CGFloat, toColor: OSColor) -> OSColor {
        let cgColor = CGColorCreateByInterpolating(color1: self.CGColor, color2: toColor.CGColor, fraction: fraction)
        return OSColor(CGColor: cgColor)!
    }
    
    public func randomColor() -> OSColor {
        return OSColor(CGColor: CGColorCreateRandom())!
    }
    
    public func convertToRGB() -> OSColor {
        return OSColor(CGColor: CGColorConvertToRGB(self.CGColor))!
    }
}

// rrggbb eg. 0x3c001b
public func colorFromRGBValue(v: UInt32) -> OSColor {
    let r = CGFloat((v & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((v & 0xFF00) >> 8) / 255.0
    let b = CGFloat(v & 0xFF) / 255.0
    let a = CGFloat(1.0)
    return OSColor(red: r, green: g, blue: b, alpha: a)
}

// rrggbbaa eg. 0x3c001bff
public func colorFromRGBAValue(v: UInt32) -> OSColor {
    let r = CGFloat((v & 0xFF000000) >> 24) / 255.0
    let g = CGFloat((v & 0xFF0000) >> 16) / 255.0
    let b = CGFloat((v & 0xFF00) >> 8) / 255.0
    let a = CGFloat(v & 0xFF) / 255.0
    return OSColor(red: r, green: g, blue: b, alpha: a)
}

public func colorFromString(s: String) -> OSColor {
    var components = [CGFloat]()
    var type = "r"
    
    let ss: NSString = s
    var textCheckingResult: NSTextCheckingResult? = _colorParsingRegex.firstMatchInString(s, options: nil, range: NSRange(0..<ss.length))
    if let tcr = textCheckingResult {
        for var i = 1; i < tcr.numberOfRanges; ++i {
            let range = tcr.rangeAtIndex(i)
            if range.location != Int(Foundation.NSNotFound) {
                let matchText: NSString = ss.substringWithRange(range)
                if matchText.length > 0 {
                    if i == 1 {
                        type = matchText as! String
                    } else if i > 1 {
                        components.append(matchText.cgFloatValue())
                    }
                }
            }
        }
    }
    
    if components.count < 4 {
        components.append(1)
    }
    
    var color: OSColor!
    switch type {
    case "r":
        color = OSColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        break
    default:
        color = OSColor(hue: components[0], saturation: components[1], brightness: components[2], alpha: components[3])
        break
    }
    
    return color
}

public func colorWithPatternImageNamed(name: String) -> OSColor {
    let image = OSImage(named: name)!
    let color = OSColor(patternImage: image)
    return color
}

/*
public func testColorFromString() {
    let s = [
        "1 0 0",
        "1.0 0.0 0.0 1.0",
        "r: .1 g: 0.512 b: 0.9 a: 1",
        "red: .1 green: 0.512 blue: 0.9 alpha: 1",
        "h: .1 s: 0.512 b: 0.9 alpha: 1",
        "hue: .1 saturation: 0.512 brightness: 0.9 alpha: 1"
    ]
    for ss in s {
        let color = colorFromString(ss)
        println("\(ss) -> \(color)")
    }
}
*/