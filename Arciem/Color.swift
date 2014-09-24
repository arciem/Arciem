//
//  Color.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

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
let _colorParsingRegex = ~/"^\\s*(?:(r|h)(?:ed|ue)?:\\s*)?(\\d*(?:\\.\\d*)?)\\s+(?:(?:g|s)(?:reen|aturation)?:\\s*)?(\\d*(?:\\.\\d*)?)\\s+(?:(?:b)(?:lue|rightness)?:\\s*)?(\\d*(?:\\.\\d*)?)(?:\\s+(?:a(?:lpha)?:\\s*)?(\\d*(?:\\.\\d*)?))?\\s*$"

public extension UIColor {
    public func colorByDarkening(#fraction: CGFloat) -> UIColor {
        return UIColor(CGColor: CGColorCreateByDarkening(color: self.CGColor, fraction: fraction))
    }

    public func colorByLightening(#fraction: CGFloat) -> UIColor {
        return UIColor(CGColor: CGColorCreateByLightening(color: self.CGColor, fraction: fraction))
    }
    
    public func colorByDodging(#fraction: CGFloat) -> UIColor {
        return UIColor(CGColor: CGColorCreateByDodging(color: self.CGColor, fraction: fraction))
    }
    
    public func colorByBurning(#fraction: CGFloat) -> UIColor {
        return UIColor(CGColor: CGColorCreateByBurning(color: self.CGColor, fraction: fraction))
    }
    
    public func colorByInterpolating(color color2: UIColor, fraction: CGFloat) -> UIColor {
        let cgColor = CGColorCreateByInterpolating(color1: self.CGColor, color2: color2.CGColor, fraction: fraction)
        return UIColor(CGColor: cgColor)
    }
    
    public func randomColor() -> UIColor {
        return UIColor(CGColor: CGColorCreateRandom())
    }
    
    public func convertToRGB() -> UIColor {
        return UIColor(CGColor: CGColorConvertToRGB(self.CGColor))
    }
}

public func colorFromString(s: NSString) -> UIColor {
    var components = [CGFloat]()
    var type = "r"
    
    var textCheckingResult: NSTextCheckingResult? = _colorParsingRegex.firstMatchInString(s, options: nil, range: NSRange(0..<s.length))
    if let tcr = textCheckingResult {
        for var i = 1; i < tcr.numberOfRanges; ++i {
            let range = tcr.rangeAtIndex(i)
            if range.location != Int(Foundation.NSNotFound) {
                let matchText: NSString = s.substringWithRange(range)
                if matchText.length > 0 {
                    if i == 1 {
                        type = matchText
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
    
    var color: UIColor!
    switch type {
    case "r":
        color = UIColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        break
    default:
        color = UIColor(hue: components[0], saturation: components[1], brightness: components[2], alpha: components[3])
        break
    }
    
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