//
//  ColorFunc.swift
//  Arciem
//
//  Created by Robert McNally on 11/15/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public typealias ColorFunc = (frac: Float) -> Color

public func blend(color1: Color, color2: Color, #frac: Float) -> Color {
    let f = Math.clamp(frac)
    return color1 * (1 - f) + color2 * f
}

public func blend(color1: Color, color2: Color)(frac: Float) -> Color {
    return blend(color1, color2, frac: frac)
}

public func blend(#colors: [Color])(frac: Float) -> Color {
    let colorsCount = colors.count
    switch colorsCount {
    case 0:
        return .Black
    case 1:
        return colors[0]
    case 2:
        return blend(colors[0], colors[1])(frac: frac)
    default:
        if frac >= 1.0 {
            return colors.last!
        } else if frac <= 0.0 {
            return colors.first!
        } else {
            let segments = colorsCount - 1
            let s = frac * Float(segments)
            let segment = Int(s)
            let segmentFrac = s % 1.0
            let c1 = colors[segment]
            let c2 = colors[segment + 1]
            return blend(c1, c2)(frac: segmentFrac)
        }
    }
}

public func blend(#colorFracs: [ColorFrac])(frac: Float) -> Color {
    let count = colorFracs.count
    switch count {
    case 0:
        return .Black
    case 1:
        return colorFracs[0].color
    case 2:
        let (color1, frac1) = colorFracs[0]
        let (color2, frac2) = colorFracs[1]
        let f = Math.normalize(frac, frac1, frac2)
        return blend(color1, color2)(frac: f)
    default:
        if frac >= colorFracs.last!.frac {
            return colorFracs.last!.color
        } else if frac <= colorFracs.first!.frac {
            return colorFracs.first!.color
        } else {
            let segments = count - 1
            for var segment = 0; segment < segments; ++segment {
                let (color1, frac1) = colorFracs[segment]
                let (color2, frac2) = colorFracs[segment + 1]
                if frac >= frac1 && frac < frac2 {
                    let f = Math.normalize(frac, frac1, frac2)
                    return blend(color1, color2)(frac: f)
                }
            }
            
            return .Black
        }
    }
}

public func blend(#colorFracHandles: [ColorFracHandle])(frac: Float) -> Color {
    var colorFracs = [ColorFrac]()
    let count = colorFracHandles.count
    switch count {
    case 0:
        break
    case 1:
        let (color, frac, handle) = colorFracHandles[0]
        let colorFrac = (color: color, frac: frac)
        colorFracs.append(colorFrac)
    default:
        for index in 0..<(count - 1) {
            let colorFracHandle1 = colorFracHandles[index]
            let colorFracHandle2 = colorFracHandles[index + 1]
            let (color1, frac1, handle) = colorFracHandle1
            let (color2, frac2, _) = colorFracHandle2
            let colorFrac1 = (color: color1, frac: frac1)
            colorFracs.append(colorFrac1)
            if abs(handle - 0.5) > 0.001 {
                let color12 = blend(color1, color2, frac: 0.5)
                let frac12 = Math.denormalize(handle, frac1, frac2)
                let colorFrac12 = (color: color12, frac: frac12)
                colorFracs.append(colorFrac12)
            }
        }
        break
    }
    return blend(colorFracs:colorFracs)(frac: frac)
}

public func reverse(f: ColorFunc) -> ColorFunc {
    return { (frac: Float) in
        return f(frac: 1 - frac)
    }
}

public func tints(#hue: Float)(frac: Float) -> Color {
    return Color(hue: hue, saturation: 1.0 - frac, brightness: 1)
}

public func shades(#hue: Float)(frac: Float) -> Color {
    return Color(hue: hue, saturation: 1.0, brightness: 1.0 - frac)
}

public func tones(#hue: Float)(frac: Float) -> Color {
    return Color(hue: hue, saturation: 1.0 - frac, brightness: Math.denormalize(frac, 1.0, 0.5))
}

public func twoColor(color1: Color, color2: Color)(frac: Float) -> Color {
    return blend(color1, color2)(frac: frac)
}

public func threeColor(color1: Color, color2: Color, color3: Color)(frac: Float) -> Color {
    return blend(colors: [color1, color2, color3])(frac: frac)
}
