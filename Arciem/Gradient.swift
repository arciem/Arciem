//
//  Gradient.swift
//  Arciem
//
//  Created by Robert McNally on 11/15/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public typealias ColorFrac = (color: Color, frac: Float)
public typealias ColorFracHandle = (color: Color, frac: Float, handle: Float)

public struct Gradient {
    
    public static let grayscale = blend(.Black, .White)

    // Color Harmonies, Analogous
    public static let goldRedOrange = threeColor(.Gold, .Red, .Orange)
    public static let bluegreenBlueGreen = threeColor(.BlueGreen, .MediumBlue, .DarkGreen)
    public static let blueMagentaRed = threeColor(.DeepBlue, .Magenta, .Red)
    public static let yellowGoldGreen = threeColor(.Yellow, .Gold, .DarkGreen)
    public static let chartreuseYellowGreen = threeColor(.Chartreuse, .Yellow, .DarkGreen)
    
    // Color Harmonies, Primary Complementary
    public static let orangeMediumblue = twoColor(.Orange, .MediumBlue)
    public static let purpleGold = twoColor(.Purple, .Gold)
    public static let redGreen = twoColor(.Red, .DarkGreen)
    
    // Color Harmonies, Secondary Complementary
    public static let chartreusePurple = twoColor(.Chartreuse, .Purple)
    public static let greenOrange = twoColor(.DarkGreen, .Orange)
    public static let deepblueOrange = twoColor(.DeepBlue, .Orange)
    
    // Color Harmonies, Split Complementary
    public static let bluePurpleOrange = threeColor(.MediumBlue, .Purple, .Orange)
    public static let yellowBluePurple = threeColor(.Yellow, .MediumBlue, .Purple)
    public static let chartreuseBlueRed = threeColor(.Chartreuse, .DeepBlue, .Red)
    public static let greenMagentaOrange = threeColor(.DarkGreen, .Magenta, .Orange)
    public static let bluegreenRedOrange = threeColor(.BlueGreen, .Red, .Orange)
    public static let orangeBlueOrange = threeColor(.Orange, .MediumBlue, .Orange)
    public static let goldPurpleOrange = threeColor(.Gold, .Purple, .Orange)
    public static let chartreuseBlueOrange = threeColor(.Chartreuse, .DeepBlue, .Orange)
    
    // Earth Tones
    public static let coffee = threeColor(
        Color(redByte: 250, greenByte: 243, blueByte: 232),
        Color(redByte: 199, greenByte: 152, blueByte: 60),
        Color(redByte: 191, greenByte: 124, blueByte: 38))
    public static let valentine = threeColor(
        Color(redByte: 240, greenByte: 222, blueByte: 215),
        Color(redByte: 178, greenByte: 85, blueByte: 56),
        Color(redByte: 189, greenByte: 49, blueByte: 26))
    public static let strata1 = blend(colorFracHandles:[
        (color: Color(redByte: 184, greenByte:  94, blueByte:  66), frac: 0.00, handle: 0.50),
        (color: Color(redByte: 232, greenByte: 186, blueByte: 128), frac: 0.25, handle: 0.82),
        (color: Color(redByte: 159, greenByte:  34, blueByte:  20), frac: 0.46, handle: 0.50),
        (color: Color(redByte: 196, greenByte: 120, blueByte: 105), frac: 0.56, handle: 0.50),
        (color: Color(redByte: 113, greenByte:  55, blueByte:  31), frac: 0.70, handle: 0.50),
        (color: Color(redByte: 244, greenByte: 187, blueByte:  58), frac: 1.00, handle: 0.50)
        ])
    public static let strata2 = blend(colorFracs:[
        (color: Color(redByte:   0, greenByte:  89, blueByte:  92), frac: 0.00),
        (color: Color(redByte: 166, greenByte: 184, blueByte: 194), frac: 0.25),
        (color: Color(redByte: 168, greenByte: 163, blueByte: 155), frac: 0.46),
        (color: Color(redByte:  46, greenByte:  52, blueByte:  24), frac: 0.56),
        (color: Color(redByte: 106, greenByte: 121, blueByte: 137), frac: 0.70),
        (color: Color(redByte: 215, greenByte: 222, blueByte: 226), frac: 1.00)
        ])
    public static let strata3 = blend(colorFracs:[
        (color: Color(redByte:  51, greenByte:  63, blueByte:  41), frac: 0.00),
        (color: Color(redByte: 192, greenByte: 152, blueByte:  18), frac: 0.26),
        (color: Color(redByte: 176, greenByte: 127, blueByte:  32), frac: 0.35),
        (color: Color(redByte: 102, greenByte: 107, blueByte:  67), frac: 0.67),
        (color: Color(redByte: 110, greenByte:  79, blueByte:  14), frac: 0.70),
        (color: Color(redByte: 135, greenByte: 119, blueByte: 116), frac: 1.00)
        ])
    
    // Seasons
    public static let spring = blend(colorFracHandles:[
        (color: Color(redByte: 172, greenByte: 202, blueByte: 234), frac: 0.00, handle: 0.50),
        (color: Color(redByte: 207, greenByte: 194, blueByte: 223), frac: 0.22, handle: 0.50),
        (color: Color(redByte: 249, greenByte: 234, blueByte: 191), frac: 0.43, handle: 0.82),
        (color: Color(redByte: 227, greenByte: 185, blueByte: 215), frac: 0.72, handle: 0.87),
        (color: Color(redByte: 172, greenByte: 202, blueByte: 234), frac: 0.74, handle: 0.50),
        (color: Color(redByte: 201, greenByte: 230, blueByte: 209), frac: 1.00, handle: 0.50)
        ])
    public static let summer = blend(colorFracHandles:[
        (color: Color(redByte: 240, greenByte: 200, blueByte:  59), frac: 0.11, handle: 0.50),
        (color: Color(redByte: 241, greenByte:  86, blueByte:  60), frac: 0.24, handle: 0.40),
        (color: Color(redByte: 195, greenByte:  75, blueByte: 155), frac: 0.39, handle: 0.50),
        (color: Color(redByte:   0, greenByte: 179, blueByte: 193), frac: 0.79, handle: 0.50),
        (color: Color(redByte:   0, greenByte: 179, blueByte: 108), frac: 0.81, handle: 0.50),
        (color: Color(redByte:   0, greenByte: 179, blueByte: 193), frac: 1.00, handle: 0.50)
        ])
    public static let autumn = blend(colorFracHandles:[
        (color: Color(redByte: 118, greenByte: 114, blueByte:  62), frac: 0.00, handle: 0.42),
        (color: Color(redByte: 220, greenByte: 115, blueByte:  84), frac: 0.24, handle: 0.40),
        (color: Color(redByte: 255, greenByte: 205, blueByte:   3), frac: 0.69, handle: 0.50),
        (color: Color(redByte: 220, greenByte: 115, blueByte:  84), frac: 0.81, handle: 0.50),
        (color: Color(redByte: 148, greenByte:  46, blueByte:  64), frac: 1.00, handle: 0.50)
        ])
    public static let winter = blend(colorFracHandles:[
        (color: Color(redByte: 177, greenByte: 199, blueByte: 215), frac: 0.00, handle: 0.50),
        (color: Color(redByte: 213, greenByte: 217, blueByte: 227), frac: 0.26, handle: 0.50),
        (color: Color(redByte: 177, greenByte: 199, blueByte: 215), frac: 0.35, handle: 0.50),
        (color: Color(redByte: 203, greenByte: 209, blueByte: 228), frac: 0.67, handle: 0.50),
        (color: Color(redByte: 207, greenByte: 223, blueByte: 223), frac: 0.70, handle: 0.50),
        (color: Color(redByte: 237, greenByte: 217, blueByte: 227), frac: 1.00, handle: 0.50)
        ])
    
    // Nature
    public static let sky1 = blend(colorFracHandles:[
        (color: Color(redByte: 108, greenByte: 181, blueByte: 228), frac: 0.00, handle: 0.60),
        (color: Color(redByte:   0, greenByte: 124, blueByte: 194), frac: 0.57, handle: 0.50),
        (color: Color(redByte:   0, greenByte:  89, blueByte: 169), frac: 1.00, handle: 0.50),
        ])
    public static let sky2 = blend(colorFracHandles:[
        (color: Color(redByte: 204, greenByte: 224, blueByte: 244), frac: 0.00, handle: 0.60),
        (color: Color(redByte:  30, greenByte: 156, blueByte: 215), frac: 0.57, handle: 0.50),
        (color: Color(redByte:   0, greenByte: 117, blueByte: 190), frac: 0.89, handle: 0.50),
        (color: Color(redByte:   0, greenByte:  90, blueByte: 151), frac: 1.00, handle: 0.50),
        ])
    public static let sky3 = blend(colorFracHandles:[
        (color: Color(redByte: 248, greenByte: 209, blueByte: 117), frac: 0.00, handle: 0.46),
        (color: Color(redByte: 239, greenByte: 145, blueByte:  80), frac: 0.36, handle: 0.52),
        (color: Color(redByte: 203, greenByte: 114, blueByte:  50), frac: 0.55, handle: 0.50),
        (color: Color(redByte: 141, greenByte:  74, blueByte:  36), frac: 1.00, handle: 0.50),
        ])
    public static let sky4 = blend(colorFracHandles:[
        (color: Color(redByte: 203, greenByte: 114, blueByte:  50), frac: 0.00, handle: 0.46),
        (color: Color(redByte: 239, greenByte: 145, blueByte:  80), frac: 0.13, handle: 0.52),
        (color: Color(redByte: 247, greenByte: 210, blueByte: 145), frac: 0.39, handle: 0.48),
        (color: Color(redByte: 221, greenByte: 188, blueByte: 166), frac: 0.55, handle: 0.50),
        (color: Color(redByte: 198, greenByte: 169, blueByte: 181), frac: 0.71, handle: 0.50),
        (color: Color(redByte: 142, greenByte:  98, blueByte: 133), frac: 1.00, handle: 0.38),
        ])
    public static let water1 = blend(colorFracs:[
        (color: Color(redByte:  33, greenByte:  44, blueByte:  41), frac: 0.00),
        (color: Color(redByte: 124, greenByte: 170, blueByte: 179), frac: 0.45),
        (color: Color(redByte: 141, greenByte: 185, blueByte: 207), frac: 0.60),
        (color: Color(redByte: 154, greenByte: 172, blueByte: 203), frac: 0.80),
        (color: Color(redByte: 122, greenByte: 127, blueByte: 159), frac: 1.00),
        ])
    public static let water2 = blend(colors:[
        Color(redByte:  45, greenByte:  20, blueByte:  79),
        Color(redByte:  81, greenByte:  46, blueByte: 145),
        Color(redByte:  74, greenByte:  86, blueByte: 166),
        Color(redByte:  82, greenByte: 125, blueByte: 191),
        Color(redByte: 124, greenByte: 187, blueByte: 230),
        Color(redByte: 199, greenByte: 234, blueByte: 251)
        ])
 
    // Spectra
    //public static let hues = { (#frac: Float) -> Color in return Color(hue: frac, saturation: 1, brightness: 1) }
    public static let redYellowBlue = threeColor(.Red, .Yellow, .Blue)
    public static let spectrum = blend(colors:[
        Color(redByte:   0, greenByte: 168, blueByte: 222),
        Color(redByte:  51, greenByte:  51, blueByte: 145),
        Color(redByte: 233, greenByte:  19, blueByte: 136),
        Color(redByte: 235, greenByte:  45, blueByte:  46),
        Color(redByte: 253, greenByte: 233, blueByte:  43),
        Color(redByte:   0, greenByte: 158, blueByte:  84)
        ])

    
    public static func hues(frac frac: Float) -> Color {
        return Color(hue: frac, saturation: 1, brightness: 1)
    }
    
    public static let gradients = [
        Gradient.grayscale,
        
        Gradient.goldRedOrange,
        Gradient.bluegreenBlueGreen,
        Gradient.blueMagentaRed,
        Gradient.yellowGoldGreen,
        Gradient.chartreuseYellowGreen,
        
        Gradient.orangeMediumblue,
        Gradient.purpleGold,
        Gradient.redGreen,
        
        Gradient.chartreusePurple,
        Gradient.greenOrange,
        Gradient.deepblueOrange,
        
        Gradient.bluePurpleOrange,
        Gradient.yellowBluePurple,
        Gradient.chartreuseBlueRed,
        Gradient.greenMagentaOrange,
        Gradient.bluegreenRedOrange,
        Gradient.orangeBlueOrange,
        Gradient.goldPurpleOrange,
        Gradient.chartreuseBlueOrange,
        
        Gradient.coffee,
        Gradient.valentine,
        Gradient.strata1,
        Gradient.strata2,
        Gradient.strata3,
        
        Gradient.spring,
        Gradient.summer,
        Gradient.autumn,
        Gradient.winter,
        
        Gradient.sky1,
        Gradient.sky2,
        Gradient.sky3,
        Gradient.sky4,
        Gradient.water1,
        Gradient.water2,

        Gradient.hues,
        Gradient.redYellowBlue,
        Gradient.spectrum,
    ]
}
