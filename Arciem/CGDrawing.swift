//
//  CGDrawing.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import CoreGraphics

public func drawCrossedBoxInContext(context: CGContext, rect: CGRect, color: CGColor, lineWidth: CGFloat = 1, originIndicators: Bool = false) {
    
    let minX = rect.minX
    let minY = rect.minY
    let maxX = rect.maxX
    let maxY = rect.maxY
    
    let path = CGPathCreateMutable()
    
    CGPathMoveToPoint(path, nil, minX, minY)
    CGPathAddLineToPoint(path, nil, maxX, minY)
    CGPathAddLineToPoint(path, nil, maxX, maxY)
    CGPathAddLineToPoint(path, nil, minX, maxY)
    CGPathCloseSubpath(path)
    
    CGPathMoveToPoint(path, nil, minX, minY)
    CGPathAddLineToPoint(path, nil, maxX, maxY)
    
    CGPathMoveToPoint(path, nil, maxX, minY)
    CGPathAddLineToPoint(path, nil, minX, maxY)
    
    if originIndicators {
        let midX = rect.midX
        let midY = rect.midY
        
        CGPathMoveToPoint(path, nil, midX, minY)
        CGPathAddLineToPoint(path, nil, midX, midY)
        
        CGPathMoveToPoint(path, nil, minX, midY)
        CGPathAddLineToPoint(path, nil, midX, midY)
    }
    
    drawRestoringStateForContext(context) {
        CGContextSetStrokeColorWithColor(context, color)
        CGContextSetLineWidth(context, lineWidth)
        CGContextAddPath(context, path)
        CGContextStrokePath(context)
    }
}