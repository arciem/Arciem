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

extension UIImage {
    public func scaledToSize(size: CGSize) -> UIImage {
        return drawImage(size: size, opaque: false, scale: 1.0) { context in
            self.drawInRect(CGRect(origin: CGPoint.zeroPoint, size: size))
        }
    }
    
    public func scaledAspectFitToSize(size: CGSize) -> UIImage {
        let inSize = self.size.aspectFitWithinSize(size)
        return scaledToSize(inSize)
    }
    
    public func scaledAspectFillToSize(size: CGSize) -> UIImage {
        let inSize = self.size.aspectFillWithinSize(size)
        println("size:\(size) inSize:\(inSize)")
        return scaledToSize(inSize)
    }
}