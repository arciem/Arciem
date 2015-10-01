//
//  File.swift
//  Arciem
//
//  Created by Robert McNally on 6/10/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

infix operator <- {}

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
    // These are properties and methods defined by standard CGRect
    //
    
    public var width : CGFloat { get { return r.width } }
    public var height : CGFloat { get { return r.height } }
    
    public var minX : CGFloat { get { return r.minX } }
    public var midX : CGFloat { get { return r.midX } }
    public var maxX : CGFloat { get { return r.maxX } }

    public var minY : CGFloat { get { return r.minY } }
    public var midY : CGFloat { get { return r.midY } }
    public var maxY : CGFloat { get { return r.maxY } }
    
    public var isNull: Bool { get { return r.isNull } }
    public var isEmpty: Bool { get { return r.isEmpty } }
    public var isInfinite: Bool { get { return r.isInfinite } }
    
    public var standardizedRect: CGRect { get { return r.standardized } }
    public func standardize() { return r.standardize() }
    
    public var integerRect: CGRect { get { return r.integral } }
    public func integerize() { r.makeIntegralInPlace() }
    
    public func rectByInsetting(dx dx: CGFloat, dy: CGFloat) -> CGRect { return r.insetBy(dx: dx, dy: dy) }
    public func inset(dx dx: CGFloat, dy: CGFloat) { r.insetInPlace(dx: dx, dy: dy) }
    
    public func rectByOffsetting(dx dx: CGFloat, dy: CGFloat) -> CGRect { return r.offsetBy(dx: dx, dy: dy) }
    public func offset(dx dx: CGFloat, dy: CGFloat) { r.offsetInPlace(dx: dx, dy: dy) }
    
    public func rectByUnion(withRect: CGRect) -> CGRect { return r.union(withRect) }
    public func union(withRect: CGRect) { r.union(withRect) }
    
    public func rectByIntersecting(withRect: CGRect) -> CGRect { return r.intersect(withRect) }
    public func intersect(withRect: CGRect) { r.intersect(withRect) }
    
    public func rectsByDividing(atDistance: CGFloat, fromEdge: CGRectEdge) -> (slice: CGRect, remainder: CGRect) { return r.divide(atDistance, fromEdge: fromEdge) }
    
    public func contains(rect: CGRect) -> Bool { return r.contains(rect) }
    public func contains(point: CGPoint) -> Bool { return r.contains(point) }
    
    public func intersects(rect: CGRect) -> Bool { return r.intersects(rect) }
    
    //
    // Convenience getters
    //

    public var left : CGFloat { get { return r.left } }
    public var leading : CGFloat { get { return r.leading } }
    public var right : CGFloat { get { return r.right } }
    public var trailing : CGFloat { get { return r.trailing } }
    public var top : CGFloat { get { return r.top } }
    public var bottom : CGFloat { get { return r.bottom } }
    
    public var minXminY : CGPoint { get { return r.minXminY } }
    public var midXminY : CGPoint { get { return r.midXminY } }
    public var maxXminY : CGPoint { get { return r.maxXminY } }
    public var minXmidY : CGPoint { get { return r.minXmidY } }
    public var midXmidY : CGPoint { get { return r.midXmidY } }
    public var mid      : CGPoint { get { return r.mid } }
    public var maxXmidY : CGPoint { get { return r.maxXmidY } }
    public var minXmaxY : CGPoint { get { return r.minXmaxY } }
    public var midXmaxY : CGPoint { get { return r.midXmaxY } }
    public var maxXmaxY : CGPoint { get { return r.maxXmaxY } }
    
    //
    // The functions below will never change the rectangle's size
    //

    public func setMinX(newValue: CGFloat) { r.setMinX(newValue) }
    public func setLeft(newValue: CGFloat) { r.setLeft(newValue) }
    public func setLeading(newValue: CGFloat) { r.setLeading(newValue) }
    public func setMidX(newValue: CGFloat) { r.setMidX(newValue) }
    public func setMaxX(newValue: CGFloat) { r.setMaxX(newValue) }
    public func setRight(newValue: CGFloat) { r.setRight(newValue) }
    public func setTrailing(newValue: CGFloat) { r.setTrailing(newValue) }
    public func setMinY(newValue: CGFloat) { r.setMinY(newValue) }
    public func setTop(newValue: CGFloat) { r.setTop(newValue) }
    public func setMidY(newValue: CGFloat) { r.setMidY(newValue) }
    public func setMaxY(newValue: CGFloat) { r.setMaxY(newValue) }
    public func setBottom(newValue: CGFloat) { r.setBottom(newValue) }
    
    public func rectBySettingMinX(newValue: CGFloat) -> CGRect { return r.rectBySettingMinX(newValue) }
    public func rectBySettingLeft(newValue: CGFloat) -> CGRect { return r.rectBySettingLeft(newValue) }
    public func rectBySettingLeading(newValue: CGFloat) -> CGRect { return r.rectBySettingLeading(newValue) }
    public func rectBySettingMidX(newValue: CGFloat) -> CGRect { return r.rectBySettingMidX(newValue) }
    public func rectBySettingMaxX(newValue: CGFloat) -> CGRect { return r.rectBySettingMaxX(newValue) }
    public func rectBySettingRight(newValue: CGFloat) -> CGRect { return r.rectBySettingRight(newValue) }
    public func rectBySettingTrailing(newValue: CGFloat) -> CGRect { return r.rectBySettingTrailing(newValue) }
    public func rectBySettingMinY(newValue: CGFloat) -> CGRect { return r.rectBySettingMinY(newValue) }
    public func rectBySettingTop(newValue: CGFloat) -> CGRect { return r.rectBySettingTop(newValue) }
    public func rectBySettingMidY(newValue: CGFloat) -> CGRect { return r.rectBySettingMidY(newValue) }
    public func rectBySettingMaxY(newValue: CGFloat) -> CGRect { return r.rectBySettingMaxY(newValue) }
    public func rectBySettingBottom(newValue: CGFloat) -> CGRect { return r.rectBySettingBottom(newValue) }
    
    public func setMinXminY(newValue: CGPoint) { r.setMinXminY(newValue) }
    public func setMidXminY(newValue: CGPoint) { r.setMidXminY(newValue) }
    public func setMaxXminY(newValue: CGPoint) { r.setMaxXminY(newValue) }
    public func setMinXmidY(newValue: CGPoint) { r.setMinXmidY(newValue) }
    public func setMidXmidY(newValue: CGPoint) { r.setMidXmidY(newValue) }
    public func setMid     (newValue: CGPoint) { r.setMid(newValue) }
    public func setMaxXmidY(newValue: CGPoint) { r.setMaxXmidY(newValue) }
    public func setMinXmaxY(newValue: CGPoint) { r.setMinXmaxY(newValue) }
    public func setMidXmaxY(newValue: CGPoint) { r.setMidXmaxY(newValue) }
    public func setMaxXmaxY(newValue: CGPoint) { r.setMaxXmaxY(newValue) }
    
    public func rectBySettingMinXminY(newValue: CGPoint) -> CGRect { return r.rectBySettingMinXminY(newValue) }
    public func rectBySettingMidXminY(newValue: CGPoint) -> CGRect { return r.rectBySettingMidXminY(newValue) }
    public func rectBySettingMaxXminY(newValue: CGPoint) -> CGRect { return r.rectBySettingMaxXminY(newValue) }
    public func rectBySettingMinXmidY(newValue: CGPoint) -> CGRect { return r.rectBySettingMinXmidY(newValue) }
    public func rectBySettingMidXmidY(newValue: CGPoint) -> CGRect { return r.rectBySettingMidXmidY(newValue) }
    public func rectBySettingMid     (newValue: CGPoint) -> CGRect { return r.rectBySettingMid(newValue) }
    public func rectBySettingMaxXmidY(newValue: CGPoint) -> CGRect { return r.rectBySettingMaxXmidY(newValue) }
    public func rectBySettingMinXmaxY(newValue: CGPoint) -> CGRect { return r.rectBySettingMinXmaxY(newValue) }
    public func rectBySettingMidXmaxY(newValue: CGPoint) -> CGRect { return r.rectBySettingMidXmaxY(newValue) }
    public func rectBySettingMaxXmaxY(newValue: CGPoint) -> CGRect { return r.rectBySettingMaxXmaxY(newValue) }
    
    //
    // The public functions below generally change the rectangle's size
    //
    
    public func setWidth(newValue: CGFloat) { r.setWidth(newValue) }
    public func setHeight(newValue: CGFloat) { r.setHeight(newValue) }
    
    public func rectBySettingWidth(newValue: CGFloat) -> CGRect { return r.rectBySettingWidth(newValue) }
    public func rectBySettingHeight(newValue: CGFloat) -> CGRect { return r.rectBySettingHeight(newValue) }
    
    public func rectByInsettingMinX(dx: CGFloat) -> CGRect { return r.rectByInsettingMinX(dx) }
    public func rectByInsettingLeft(dx: CGFloat) -> CGRect { return r.rectByInsettingLeft(dx) }
    public func rectByInsettingLeading(dx: CGFloat) -> CGRect { return r.rectByInsettingLeading(dx) }
    public func rectByInsettingMaxX(dx: CGFloat) -> CGRect { return r.rectByInsettingMaxX(dx) }
    public func rectByInsettingRight(dx: CGFloat) -> CGRect { return r.rectByInsettingRight(dx) }
    public func rectByInsettingTrailing(dx: CGFloat) -> CGRect { return r.rectByInsettingTrailing(dx) }
    public func rectByInsettingMinY(dy: CGFloat) -> CGRect { return r.rectByInsettingMinY(dy) }
    public func rectByInsettingTop(dy: CGFloat) -> CGRect { return r.rectByInsettingTop(dy) }
    public func rectByInsettingMaxY(dy: CGFloat) -> CGRect { return r.rectByInsettingMaxY(dy) }
    public func rectByInsettingBottom(dy: CGFloat) -> CGRect { return r.rectByInsettingBottom(dy) }
    
    public func insetMinX(dx: CGFloat) { r.insetMinX(dx) }
    public func insetLeft(dx: CGFloat) { r.insetLeft(dx) }
    public func insetLeading(dx: CGFloat) { r.insetLeading(dx) }
    public func insetMaxX(dx: CGFloat) { r.insetMaxX(dx) }
    public func insetRight(dx: CGFloat) { r.insetRight(dx) }
    public func insetTrailing(dx: CGFloat) { r.insetTrailing(dx) }
    public func insetMinY(dy: CGFloat) { r.insetMinY(dy) }
    public func insetTop(dy: CGFloat) { r.insetTop(dy) }
    public func insetMaxY(dy: CGFloat) { r.insetMaxY(dy) }
    public func insetBottom(dy: CGFloat) { r.insetBottom(dy) }
    
    public func rectBySettingMinXIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingMinXIndependent(newValue) }
    public func rectBySettingLeftIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingLeftIndependent(newValue) }
    public func rectBySettingLeadingIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingLeadingIndependent(newValue) }
    public func rectBySettingMaxXIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingMaxXIndependent(newValue) }
    public func rectBySettingRightIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingRightIndependent(newValue) }
    public func rectBySettingTrailingIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingTrailingIndependent(newValue) }
    public func rectBySettingMinYIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingMinYIndependent(newValue) }
    public func rectBySettingTopIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingTopIndependent(newValue) }
    public func rectBySettingMaxYIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingMaxYIndependent(newValue) }
    public func rectBySettingBottomIndependent(newValue: CGFloat) -> CGRect { return r.rectBySettingBottomIndependent(newValue) }
    
    public func setMinXIndependent(newValue: CGFloat) { r.setMinXIndependent(newValue) }
    public func setLeftIndependent(newValue: CGFloat) { r.setLeftIndependent(newValue) }
    public func setLeadingIndependent(newValue: CGFloat) { r.setLeadingIndependent(newValue) }
    public func setMaxXIndependent(newValue: CGFloat) { r.setMaxXIndependent(newValue) }
    public func setRightIndependent(newValue: CGFloat) { r.setRightIndependent(newValue) }
    public func setTrailingIndependent(newValue: CGFloat) { r.setTrailingIndependent(newValue) }
    public func setMinYIndependent(newValue: CGFloat) { r.setMinYIndependent(newValue) }
    public func setTopIndependent(newValue: CGFloat) { r.setTopIndependent(newValue) }
    public func setMaxYIndependent(newValue: CGFloat) { r.setMaxYIndependent(newValue) }
    public func setBottomIndependent(newValue: CGFloat) { r.setBottomIndependent(newValue) }
    
    public func rectByScalingRelativeToPoint(p: CGPoint, scaling s: CGVector) -> CGRect { return r.rectByScalingRelativeToPoint(p, scaling: s) }
    public func scaleRelativeToPoint(p: CGPoint, scaling s: CGVector) { r.scaleRelativeToPoint(p, scaling: s) }
}