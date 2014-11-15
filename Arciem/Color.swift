//
//  Color.swift
//  Arciem
//
//  Created by Robert McNally on 11/14/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct Color {
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
    
    public init(redByte: Byte, greenByte: Byte, blueByte: Byte, alphaByte: Byte = 255) {
        self.init(red: Float(redByte) / 255.0,
            green: Float(greenByte) / 255.0,
            blue: Float(blueByte) / 255.0,
            alpha: Float(alphaByte) / 255.0
        )
    }
    
    public init(bytes: [Byte]) {
        let redByte = bytes[0]
        let greenByte = bytes[1]
        let blueByte = bytes[2]
        var alphaByte: Byte = 255
        if bytes.count >= 4 {
            alphaByte = bytes[3]
        }
        self.init(redByte: redByte, greenByte: greenByte, blueByte: blueByte, alphaByte: alphaByte)
    }
    
    public init(color: Color, alpha: Float) {
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
    
    public static func randomColor(random: Random = Random.sharedInstance, alpha: Float = 1.0) -> Color {
        return Color(
            red: random.randomFloat(),
            green: random.randomFloat(),
            blue: random.randomFloat(),
            alpha: alpha
        )
    }
    
    public func multipliedBy(rhs: Float) -> Color {
        return Color(red: red * rhs, green: green * rhs, blue: blue * rhs, alpha: alpha * rhs)
    }
    
    public func addedTo(rhs: Color) -> Color {
        return Color(red: red + rhs.red, green: green + rhs.green, blue: blue + rhs.blue, alpha: alpha + rhs.alpha)
    }
    
    public func lightened(frac: Float) -> Color {
        return Color(
            red: Math.denormalize(frac, red, Float(1)),
            green: Math.denormalize(frac, green, Float(1)),
            blue: Math.denormalize(frac, blue, Float(1)),
            alpha: alpha)
    }
    
    public func darkened(frac: Float) -> Color {
        return Color(
            red: Math.denormalize(frac, red, Float(0)),
            green: Math.denormalize(frac, green, Float(0)),
            blue: Math.denormalize(frac, blue, Float(0)),
            alpha: alpha)
    }
    
    public static let Black = Color(red: 0, green: 0, blue: 0)
    public static let DarkGray = Color(red: 1 / 3.0, green: 1 / 3.0, blue: 1 / 3.0)
    public static let LightGray = Color(red: 2 / 3.0, green: 2 / 3.0, blue: 2 / 3.0)
    public static let White = Color(red: 1, green: 1, blue: 1)
    public static let Gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    public static let Red = Color(red: 1, green: 0, blue: 0)
    public static let Green = Color(red: 0, green: 1, blue: 0)
    public static let DarkGreen = Color(red: 0, green: 0.5, blue: 0)
    public static let Blue = Color(red: 0, green: 0, blue: 1)
    public static let Cyan = Color(red: 0, green: 1, blue: 1)
    public static let Yellow = Color(red: 1, green: 1, blue: 0)
    public static let Magenta = Color(red: 1, green: 0, blue: 1)
    public static let Orange = Color(red: 1, green: 0.5, blue: 0)
    public static let Purple = Color(red: 0.5, green: 0, blue: 0.5)
    public static let Brown = Color(red: 0.6, green: 0.4, blue: 0.2)
    public static let Clear = Color(red: 0, green: 0, blue: 0, alpha: 0)
    
    public static let Chartreuse = blend(.Yellow, .Green, frac: 0.5)
    public static let Gold = Color(redByte: 251, greenByte: 212, blueByte: 55)
    public static let BlueGreen = Color(redByte: 0, greenByte: 169, blueByte: 149)
    public static let MediumBlue = Color(redByte: 0, greenByte: 110, blueByte: 185)
    public static let DeepBlue = Color(redByte: 60, greenByte: 55, blueByte: 149)
}

extension Color : Printable {
    public var description: String {
        get {
            return "Color(red:\(red) green:\(green) blue:\(blue) alpha:\(alpha))"
        }
    }
}

public func *(lhs: Color, rhs: Float) -> Color {
    return lhs.multipliedBy(rhs)
}

public func +(lhs: Color, rhs: Color) -> Color {
    return lhs.addedTo(rhs)
}
