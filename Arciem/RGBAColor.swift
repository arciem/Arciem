//
//  RGBAColor.swift
//  Arciem
//
//  Created by Robert McNally on 11/14/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct RGBAColor {
    let red: Float
    let green: Float
    let blue: Float
    let alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(color: RGBAColor, alpha: Float) {
        self.red = color.red
        self.green = color.green
        self.blue = color.blue
        self.alpha = alpha
    }
    
    public init(var hue h: Float, var saturation s: Float, var brightness v: Float, alpha a: Float = 1.0) {
        v = Math.clamp(v, 0.0...1.0)
        s = Math.clamp(s, 0.0...1.0)
        red = v
        green = v
        blue = v
        alpha = a
        if(s > 0.0) {
            h %= 1.0
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floorf(h))
            let f = h - Float(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch(i) {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: assert(false, "unknown hue sector")
            }
        }
    }
    
    public static func randomColor(random: Random = Random.sharedInstance, alpha: Float = 1.0) -> RGBAColor {
        return RGBAColor(
            red: random.randomFloat(),
            green: random.randomFloat(),
            blue: random.randomFloat(),
            alpha: alpha
        )
    }
    
    public static let Black = RGBAColor(red: 0, green: 0, blue: 0)
    public static let DarkGray = RGBAColor(red: 1 / 3.0, green: 1 / 3.0, blue: 1 / 3.0)
    public static let LightGray = RGBAColor(red: 2 / 3.0, green: 2 / 3.0, blue: 2 / 3.0)
    public static let White = RGBAColor(red: 1, green: 1, blue: 1)
    public static let Gray = RGBAColor(red: 0.5, green: 0.5, blue: 0.5)
    public static let Red = RGBAColor(red: 1, green: 0, blue: 0)
    public static let Green = RGBAColor(red: 0, green: 1, blue: 0)
    public static let Blue = RGBAColor(red: 0, green: 0, blue: 1)
    public static let Cyan = RGBAColor(red: 0, green: 1, blue: 1)
    public static let Yellow = RGBAColor(red: 1, green: 1, blue: 0)
    public static let Magenta = RGBAColor(red: 1, green: 0, blue: 1)
    public static let Orange = RGBAColor(red: 1, green: 0.5, blue: 0)
    public static let Purple = RGBAColor(red: 0.5, green: 0, blue: 0.5)
    public static let Brown = RGBAColor(red: 0.6, green: 0.4, blue: 0.2)
    public static let Clear = RGBAColor(red: 0, green: 0, blue: 0, alpha: 0)
}

extension RGBAColor : Printable {
    public var description: String {
        get {
            return "RGBAColor(red:\(red) green:\(green) blue:\(blue) alpha:\(alpha))"
        }
    }
}