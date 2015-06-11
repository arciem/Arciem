//
//  Image.swift
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
import CoreGraphics

public func drawImage(size size: CGSize, opaque: Bool, scale: CGFloat = 0.0, drawing: (CGContext) -> ()) -> OSImage! {
    #if os(iOS)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        drawing(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        #elseif os(OSX)
        
        let image = NSImage(size: size)
        image.lockFocus()
        drawing(NSGraphicsContext.currentContext()!.CGContext)
        image.unlockFocus()
    #endif
    return image
}

extension OSImage {
    public func scaledToSize(size: CGSize) -> OSImage {
        return drawImage(size: size, opaque: false, scale: 1.0) { context in
            self.drawInRect(CGRect(origin: CGPoint.zeroPoint, size: size))
        }
    }
    
    public func scaledAspectFitToSize(size: CGSize) -> OSImage {
        let inSize = self.size.aspectFitWithinSize(size)
        return scaledToSize(inSize)
    }
    
    public func scaledAspectFillToSize(size: CGSize) -> OSImage {
        let inSize = self.size.aspectFillWithinSize(size)
        print("size:\(size) inSize:\(inSize)")
        return scaledToSize(inSize)
    }
}