//
//  Image.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import CoreGraphics
import UIKit

public func drawImage(#size: CGSize, #opaque: Bool, scale: CGFloat = 0.0, drawing: (CGContext) -> ()) -> UIImage! {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    drawing(UIGraphicsGetCurrentContext())
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
