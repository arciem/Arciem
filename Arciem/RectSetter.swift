//
//  File.swift
//  Arciem
//
//  Created by Robert McNally on 6/10/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

operator infix <- {}

public func <- ( v: UIView, f: (inout frame: CGRect) -> () ) {
    var r = v.frame
    f(frame: &r)
    v.frame = r
}

public class RectSetter : CGRectLike {
    var r: CGRect
    let finish: (CGRect) -> ()
    
    public init(rect r: CGRect, finish: (CGRect) -> ()) {
        self.r = r
        self.finish = finish
    }
    
    deinit {
        finish(r)
    }
    
    //
    // These are proxies for properties and methods directly on CGRect
    //
    
    public var isNull: Bool { get { return r.isNull } }
    public var isEmpty: Bool { get { return r.isEmpty } }
    public var isInfinite: Bool { get { return r.isInfinite } }
    public var standardizedRect: CGRect { get { return r.standardizedRect } }
    public func standardize() { return r.standardize() }
    public var integerRect: CGRect { get { return r.integerRect } }
    public func integerize() { r.integerize() }
    public func rectByInsetting(#dx: CGFloat, dy: CGFloat) -> CGRect { return r.rectByInsetting(dx: dx, dy: dy) }
    public func inset(#dx: CGFloat, dy: CGFloat) { r.inset(dx: dx, dy: dy) }
    public func rectByOffsetting(#dx: CGFloat, dy: CGFloat) -> CGRect { return r.rectByOffsetting(dx: dx, dy: dy) }
    public func offset(#dx: CGFloat, dy: CGFloat) { r.offset(dx: dx, dy: dy) }
    public func rectByUnion(withRect: CGRect) -> CGRect { return r.rectByUnion(withRect) }
    public func union(withRect: CGRect) { r.union(withRect) }
    public func rectByIntersecting(withRect: CGRect) -> CGRect { return r.rectByIntersecting(withRect) }
    public func intersect(withRect: CGRect) { r.intersect(withRect) }
    public func rectsByDividing(atDistance: CGFloat, fromEdge: CGRectEdge) -> (slice: CGRect, remainder: CGRect) { return r.rectsByDividing(atDistance, fromEdge: fromEdge) }
    public func contains(rect: CGRect) -> Bool { return r.contains(rect) }
    public func contains(point: CGPoint) -> Bool { return r.contains(point) }
    public func intersects(rect: CGRect) -> Bool { return r.intersects(rect) }
    
    //
    // The setters on these attributes will never change the rectangle's size
    //
    
    public var minX : CGFloat { get { return r.minX } set { r.minX = newValue } }
    public var left : CGFloat { get { return r.left } set { r.left = newValue } }
    public var leading : CGFloat { get { return r.leading } set { r.leading = newValue } }
    public var midX : CGFloat { get { return r.midX } set { r.midX = newValue } }
    public var maxX : CGFloat { get { return r.maxX } set { r.maxX = newValue } }
    public var right : CGFloat { get { return r.right } set { r.right = newValue } }
    public var trailing : CGFloat { get { return r.trailing } set { r.trailing = newValue } }
    public var minY : CGFloat { get { return r.minY } set { r.minY = newValue } }
    public var top : CGFloat { get { return r.top } set { r.top = newValue } }
    public var midY : CGFloat { get { return r.midY } set { r.midY = newValue } }
    public var maxY : CGFloat { get { return r.maxY } set { r.maxY = newValue } }
    public var bottom : CGFloat { get { return r.bottom } set { r.bottom = newValue } }
    
    public var minXminY : CGPoint { get { return r.minXminY } set { r.minXminY = newValue } }
    public var midXminY : CGPoint { get { return r.midXminY } set { r.midXminY = newValue } }
    public var maxXminY : CGPoint { get { return r.maxXminY } set { r.maxXminY = newValue } }
    public var minXmidY : CGPoint { get { return r.minXmidY } set { r.minXmidY = newValue } }
    public var midXmidY : CGPoint { get { return r.midXmidY } set { r.midXmidY = newValue } }
    public var mid : CGPoint { get { return r.mid } set { r.mid = newValue } }
    public var maxXmidY : CGPoint { get { return r.maxXmidY } set { r.maxXmidY = newValue } }
    public var minXmaxY : CGPoint { get { return r.minXmaxY } set { r.minXmaxY = newValue } }
    public var midXmaxY : CGPoint { get { return r.midXmaxY } set { r.midXmaxY = newValue } }
    public var maxXmaxY : CGPoint { get { return r.maxXmaxY } set { r.maxXmaxY = newValue } }
    
    //
    // The setters on these attributes will generally change the rectangle's size
    //
    
    public var width : CGFloat { get { return r.width } set { r.width = newValue } }
    public var height : CGFloat { get { return r.height } set { r.height = newValue } }
    
    //
    // These functions return a rectangle that can be a different size than the original
    //
    
    public func insetMinX(dx: CGFloat) -> CGRect { return r.insetMinX(dx); }
    public func insetLeft(dx: CGFloat) -> CGRect { return r.insetLeft(dx); }
    public func insetLeading(dx: CGFloat) -> CGRect { return r.insetLeading(dx); }
    public func insetMaxX(dx: CGFloat) -> CGRect { return r.insetMaxX(dx); }
    public func insetRight(dx: CGFloat) -> CGRect { return r.insetRight(dx); }
    public func insetTrailing(dx: CGFloat) -> CGRect { return r.insetTrailing(dx); }
    
    public func insetMinY(dx: CGFloat) -> CGRect { return r.insetMinY(dx); }
    public func insetTop(dx: CGFloat) -> CGRect { return r.insetTop(dx); }
    public func insetMaxY(dx: CGFloat) -> CGRect { return r.insetMaxY(dx); }
    public func insetBottom(dx: CGFloat) -> CGRect { return r.insetBottom(dx); }
    public func setMinX(dx: CGFloat) -> CGRect { return r.setMinX(dx); }
    public func setLeft(dx: CGFloat) -> CGRect { return r.setLeft(dx); }
    public func setLeading(dx: CGFloat) -> CGRect { return r.setLeading(dx); }
    public func setMaxX(dx: CGFloat) -> CGRect { return r.setMaxX(dx); }
    public func setRight(dx: CGFloat) -> CGRect { return r.setRight(dx); }
    public func setTrailing(dx: CGFloat) -> CGRect { return r.setTrailing(dx); }
    public func setMinY(dx: CGFloat) -> CGRect { return r.setMinY(dx); }
    public func setTop(dx: CGFloat) -> CGRect { return r.setTop(dx); }
    public func setMaxY(dx: CGFloat) -> CGRect { return r.setMaxY(dx); }
    public func setBottom(dx: CGFloat) -> CGRect { return r.setBottom(dx); }
    
    public func scaleRelativeToPoint(p: CGPoint, sx: CGFloat, sy: CGFloat) -> CGRect { return r.scaleRelativeToPoint(p, sx: sx, sy: sy) }
}