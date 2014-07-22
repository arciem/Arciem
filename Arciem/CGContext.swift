//
//  CGContext.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import CoreGraphics

public func saveContextState(context: CGContext, drawing: () -> ()) {
    CGContextSaveGState(context)
    drawing()
    CGContextRestoreGState(context)
}
