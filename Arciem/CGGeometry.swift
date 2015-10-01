//
//  CGGeometry.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

public extension NSString {
//    var cgFloatValue: CGFloat {
//    get {
//        return CGFloat(self.doubleValue)
//    }
//    }
    //TODO: KLUDGE: Due to compiler crash, this is temporarily implemented as a function instead of a read-only property (above)
    func cgFloatValue() -> CGFloat {
        return CGFloat(self.doubleValue)
    }
}

public extension CGPoint {
    public var distanceSquared: CGFloat {
    get { return Geometry.distanceSquared(x: x, y: y) }
    }
    
    public var distance: CGFloat {
    get { return Geometry.distance(x: x, y: y) }
    }
    
    public var radians: CGRadians {
    get { return Geometry.radians(x: x, y: y) }
    }
    
    public func interpolate(p: CGPoint, t: CGFloat) -> CGPoint {
        let tu = Geometry.interpolate(x1: x, y1: y, x2: p.x, y2: p.y, t: t)
        return CGPoint(x: tu.x, y:tu.y)
    }
    
    public func clampInside(r: CGRect) -> CGPoint {
        return CGPoint(
            x: Math.clamp(x, r.minX...r.maxX),
            y: Math.clamp(y, r.minY...r.maxY)
        )
    }
    
    public func distance(p: CGPoint) -> CGFloat {
        return Geometry.distance(x1: x, y1: y, x2: p.x, y2: p.y)
    }
    
    public func distanceSquared(p: CGPoint) -> CGFloat {
        return Geometry.distanceSquared(x1: x, y1: y, x2: p.x, y2: p.y)
    }
    
    public func distance(r: CGRect) -> CGFloat {
        return distance(clampInside(r))
    }
    
    public func distanceSquared(r: CGRect) -> CGFloat {
        return distanceSquared(clampInside(r))
    }
    
    public func flipRelativeToRect(r: CGRect) -> CGPoint {
        return CGPoint(x: x, y: r.height - y + 2 * r.minY)
    }
    
    public func rotateRelativeToPoint(p: CGPoint, radians: CGRadians) -> CGPoint {
        let ox = p.x
        let oy = p.y
        
        let v1 = radians.sin
        let v2 = radians.cos
        let v3 = -oy + y
        let v4 = -ox + x
        return CGPoint(x: ox - v1*v3 + v2*v4, y: oy + v2*v3 + v1*v4)
    }
    
    public func scale(sx sx: CGFloat, sy: CGFloat) -> CGPoint {
        let t = Geometry.scale(dx: x, dy: y, sx: sx, sy: sy)
        return CGPoint(x: t.dx, y: t.dy)
    }
    
    public func scaleRelativeToPoint(p: CGPoint, sx: CGFloat, sy: CGFloat) -> CGPoint {
        return CGPoint(
            x: (x - p.x) * sx + p.x,
            y: (y - p.y) * sy + p.y
        )
    }
}

extension CGVector {
    public var distanceSquared: CGFloat {
    get { return Geometry.distanceSquared(x: dx, y: dy) }
    }
    
    public var distance: CGFloat {
    get { return Geometry.distance(x: dx, y: dy) }
    }
    
    public var radians: CGRadians {
    get { return Geometry.radians(x: dx, y: dy) }
    }
    
    public var area: CGFloat {
    get { return Geometry.area(x: dx, y: dy) }
    }
    
    public var normalize: CGVector {
    get { let t = Geometry.normalize(x: dx, y: dy)
        return CGVector(dx: t.x, dy: t.y) }
    }
    
    public func dot(d: CGVector) -> CGFloat {
        return Geometry.dot(x1: dx, y1: dy, x2: d.dx, y2: d.dy)
    }

    public func addQuarterRotation() -> CGVector { return CGVector(dx: -dy, dy: dx) }
    public func subtractQuarterRotation() -> CGVector { return CGVector(dx: dy, dy: -dx) }
    public func halfRotation() -> CGVector { return CGVector(dx: -dx, dy: -dy) }
    
    public func rotate(radians radians: CGRadians) -> CGVector {
        let t = Geometry.rotate(x: dx, y: dy, angle: radians);
        return CGVector(dx: t.x, dy: t.y)
    }
    
    public func fromPolar(radius radius: CGFloat, radians: CGRadians) -> CGVector {
        let t = Geometry.fromPolar(radius: radius, angle: radians)
        return CGVector(dx: t.x, dy: t.y)
    }
    
    public func scale(sx sx: CGFloat, sy: CGFloat) -> CGVector {
        let t = Geometry.scale(dx: dx, dy: dy, sx: sx, sy: sy)
        return CGVector(dx: t.dx, dy: t.dy)
    }
}

// Point + Vector -> Point
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

// Point - Vector -> Point
public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}


// Point - Point -> Vector
public func - (left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(dx: left.x - right.x, dy: left.y - right.y)
}


// Point + Float -> Point
public func + (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x + right, y: left.y + right)
}

// Point - Float -> Point
public func - (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x - right, y: left.y - right)
}

// Point * Float -> Point
public func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

// Point / Float -> Point
public func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

// -Point -> Point
prefix public func - (p: CGPoint) -> CGPoint {
    return CGPoint(x: -p.x, y: -p.y)
}


// Point += Vector
public func += (inout left: CGPoint, right: CGVector) {
    left.x += right.dx
    left.y += right.dy
}

// Point -= Vector
public func -= (inout left: CGPoint, right: CGVector) {
    left.x -= right.dx
    left.y -= right.dy
}


// Point += Float
public func += (inout left: CGPoint, right: CGFloat) {
    left.x += right
    left.y += right
}

// Point -= Float
public func -= (inout left: CGPoint, right: CGFloat) {
    left.x -= right
    left.y -= right
}

// Point *= Float
public func *= (inout left: CGPoint, right: CGFloat) {
    left.x *= right
    left.y *= right
}

// Point /= Float
public func /= (inout left: CGPoint, right: CGFloat) {
    left.x /= right
    left.y /= right
}


// Vector + Vector -> Vector
public func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

// Vector - Vector -> Vector
public func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

// Vector . Vector -> Float
infix operator .. {}
public func .. (left: CGVector, right: CGVector) -> CGFloat {
    return left.dot(right);
}


// Vector + Float -> Vector
public func + (left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx + right, dy: left.dy + right)
}

// Vector - Float -> Vector
public func - (left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx - right, dy: left.dy - right)
}

// Vector * Float -> Vector
public func * (left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx * right, dy: left.dy * right)
}

// Vector / Float -> Vector
public func / (left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx / right, dy: left.dy / right)
}


// -Vector -> Vector
prefix public func - (v: CGVector) -> CGVector {
    return CGVector(dx: -v.dx, dy: -v.dy)
}


// Vector += Vector
public func += (inout left: CGVector, right: CGVector) {
    left.dx += right.dx
    left.dy += right.dy
}

// Vector -= Vector
public func -= (inout left: CGVector, right: CGVector) {
    left.dx -= right.dx
    left.dy -= right.dy
}


// Vector += Float
public func += (inout left: CGVector, right: CGFloat) {
    left.dx += right
    left.dy += right
}

// Vector -= Float
public func -= (inout left: CGVector, right: CGFloat) {
    left.dx -= right
    left.dy -= right
}

// Vector *= Float
public func *= (inout left: CGVector, right: CGFloat) {
    left.dx *= right
    left.dy *= right
}

// Vector /= Float
public func /= (inout left: CGVector, right: CGFloat) {
    left.dx /= right
    left.dy /= right
}

extension CGSize {
    public func scaleForAspectFitWithin(size size:CGSize) -> CGFloat {
        return Geometry.scaleForAspectFit(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
    }

    public func scaleForAspectFillWithin(size size:CGSize) -> CGFloat {
        return Geometry.scaleForAspectFill(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
    }
    
    public func aspectFitWithin(size size:CGSize) -> CGSize {
        let t = Geometry.aspectFit(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
        return CGSize(width: t.dx, height: t.dy)
    }
    
    public func aspectFillWithin(size size:CGSize) -> CGSize {
        let t = Geometry.aspectFill(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
        return CGSize(width: t.dx, height: t.dy)
    }
    
    public func scale(sx sx: CGFloat, sy: CGFloat) -> CGSize {
        let t = Geometry.scale(dx: width, dy: height, sx: sx, sy: sy);
        return CGSize(width: t.dx, height: t.dy)
    }
}

protocol CGRectLike {
    
    //
    // These are properties and methods defined by standard CGRect
    //
    
    var width  : CGFloat { get }
    var height : CGFloat { get }
    
    var minX     : CGFloat { get }
    var midX     : CGFloat { get }
    var maxX     : CGFloat { get }
    
    var minY     : CGFloat { get }
    var midY     : CGFloat { get }
    var maxY     : CGFloat { get }

    var isNull: Bool { get }
    var isEmpty: Bool { get }
    var isInfinite: Bool { get }

    var standardizedRect: CGRect { get }
    mutating func standardize()
    
    var integerRect: CGRect { get }
    mutating func integerize()
    
    func rectByInsetting(dx dx: CGFloat, dy: CGFloat) -> CGRect
    mutating func inset(dx dx: CGFloat, dy: CGFloat)
    
    func rectByOffsetting(dx dx: CGFloat, dy: CGFloat) -> CGRect
    mutating func offset(dx dx: CGFloat, dy: CGFloat)
    
    func rectByUnion(withRect: CGRect) -> CGRect
    mutating func union(withRect: CGRect)
    
    func rectByIntersecting(withRect: CGRect) -> CGRect
    mutating func intersect(withRect: CGRect)
    
    func rectsByDividing(atDistance: CGFloat, fromEdge: CGRectEdge) -> (slice: CGRect, remainder: CGRect)
    
    func contains(rect: CGRect) -> Bool
    func contains(point: CGPoint) -> Bool
    
    func intersects(rect: CGRect) -> Bool

    var left     : CGFloat { get }
    var leading  : CGFloat { get }
    var right    : CGFloat { get }
    var trailing : CGFloat { get }
    var top      : CGFloat { get }
    var bottom   : CGFloat { get }
    
    var minXminY : CGPoint { get }
    var midXminY : CGPoint { get }
    var maxXminY : CGPoint { get }
    var minXmidY : CGPoint { get }
    var midXmidY : CGPoint { get }
    var mid      : CGPoint { get }
    var maxXmidY : CGPoint { get }
    var minXmaxY : CGPoint { get }
    var midXmaxY : CGPoint { get }
    var maxXmaxY : CGPoint { get }
    
    //
    // The functions below will never change the rectangle's size
    //
    
    mutating func setMinX(newValue: CGFloat)
    mutating func setLeft(newValue: CGFloat)
    mutating func setLeading(newValue: CGFloat)
    mutating func setMidX(newValue: CGFloat)
    mutating func setMaxX(newValue: CGFloat)
    mutating func setRight(newValue: CGFloat)
    mutating func setTrailing(newValue: CGFloat)
    mutating func setMinY(newValue: CGFloat)
    mutating func setTop(newValue: CGFloat)
    mutating func setMidY(newValue: CGFloat)
    mutating func setMaxY(newValue: CGFloat)
    mutating func setBottom(newValue: CGFloat)
    
    func rectBySettingMinX(newValue: CGFloat) -> CGRect
    func rectBySettingLeft(newValue: CGFloat) -> CGRect
    func rectBySettingLeading(newValue: CGFloat) -> CGRect
    func rectBySettingMidX(newValue: CGFloat) -> CGRect
    func rectBySettingMaxX(newValue: CGFloat) -> CGRect
    func rectBySettingRight(newValue: CGFloat) -> CGRect
    func rectBySettingTrailing(newValue: CGFloat) -> CGRect
    func rectBySettingMinY(newValue: CGFloat) -> CGRect
    func rectBySettingTop(newValue: CGFloat) -> CGRect
    func rectBySettingMidY(newValue: CGFloat) -> CGRect
    func rectBySettingMaxY(newValue: CGFloat) -> CGRect
    func rectBySettingBottom(newValue: CGFloat) -> CGRect
    
    mutating func setMinXminY(newValue: CGPoint)
    mutating func setMidXminY(newValue: CGPoint)
    mutating func setMaxXminY(newValue: CGPoint)
    mutating func setMinXmidY(newValue: CGPoint)
    mutating func setMidXmidY(newValue: CGPoint)
    mutating func setMid     (newValue: CGPoint)
    mutating func setMaxXmidY(newValue: CGPoint)
    mutating func setMinXmaxY(newValue: CGPoint)
    mutating func setMidXmaxY(newValue: CGPoint)
    mutating func setMaxXmaxY(newValue: CGPoint)
    
    func rectBySettingMinXminY(newValue: CGPoint) -> CGRect
    func rectBySettingMidXminY(newValue: CGPoint) -> CGRect
    func rectBySettingMaxXminY(newValue: CGPoint) -> CGRect
    func rectBySettingMinXmidY(newValue: CGPoint) -> CGRect
    func rectBySettingMidXmidY(newValue: CGPoint) -> CGRect
    func rectBySettingMid     (newValue: CGPoint) -> CGRect
    func rectBySettingMaxXmidY(newValue: CGPoint) -> CGRect
    func rectBySettingMinXmaxY(newValue: CGPoint) -> CGRect
    func rectBySettingMidXmaxY(newValue: CGPoint) -> CGRect
    func rectBySettingMaxXmaxY(newValue: CGPoint) -> CGRect
    
    //
    // The functions below generally change the rectangle's size
    //
    
    mutating func setWidth(newValue: CGFloat)
    mutating func setHeight(newValue: CGFloat)
    
    func rectBySettingWidth(newValue: CGFloat) -> CGRect
    func rectBySettingHeight(newValue: CGFloat) -> CGRect
    
    func rectByInsettingMinX(dx: CGFloat) -> CGRect
    func rectByInsettingLeft(dx: CGFloat) -> CGRect
    func rectByInsettingLeading(dx: CGFloat) -> CGRect
    func rectByInsettingMaxX(dx: CGFloat) -> CGRect
    func rectByInsettingRight(dx: CGFloat) -> CGRect
    func rectByInsettingTrailing(dx: CGFloat) -> CGRect
    func rectByInsettingMinY(dy: CGFloat) -> CGRect
    func rectByInsettingTop(dy: CGFloat) -> CGRect
    func rectByInsettingMaxY(dy: CGFloat) -> CGRect
    func rectByInsettingBottom(dy: CGFloat) -> CGRect
    
    mutating func insetMinX(dx: CGFloat)
    mutating func insetLeft(dx: CGFloat)
    mutating func insetLeading(dx: CGFloat)
    mutating func insetMaxX(dx: CGFloat)
    mutating func insetRight(dx: CGFloat)
    mutating func insetTrailing(dx: CGFloat)
    mutating func insetMinY(dy: CGFloat)
    mutating func insetTop(dy: CGFloat)
    mutating func insetMaxY(dy: CGFloat)
    mutating func insetBottom(dy: CGFloat)
    
    func rectBySettingMinXIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingLeftIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingLeadingIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingMaxXIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingRightIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingTrailingIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingMinYIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingTopIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingMaxYIndependent(newValue: CGFloat) -> CGRect
    func rectBySettingBottomIndependent(newValue: CGFloat) -> CGRect
    
    mutating func setMinXIndependent(newValue: CGFloat)
    mutating func setLeftIndependent(newValue: CGFloat)
    mutating func setLeadingIndependent(newValue: CGFloat)
    mutating func setMaxXIndependent(newValue: CGFloat)
    mutating func setRightIndependent(newValue: CGFloat)
    mutating func setTrailingIndependent(newValue: CGFloat)
    mutating func setMinYIndependent(newValue: CGFloat)
    mutating func setTopIndependent(newValue: CGFloat)
    mutating func setMaxYIndependent(newValue: CGFloat)
    mutating func setBottomIndependent(newValue: CGFloat)
    
    func rectByScalingRelativeToPoint(p: CGPoint, scaling s: CGVector) -> CGRect
    mutating func scaleRelativeToPoint(p: CGPoint, scaling s: CGVector)
}

extension CGRect : CGRectLike {
    public var left: CGFloat { get { return minX } }
    public var leading: CGFloat { get { return minX } }
    public var right: CGFloat { get { return maxX } }
    public var trailing: CGFloat { get { return maxX } }
    public var top: CGFloat { get { return minY } }
    public var bottom: CGFloat { get { return maxY } }

    public var minXminY : CGPoint { get { return CGPoint(x: minX, y: minY) } }
    public var midXminY : CGPoint { get { return CGPoint(x: midX, y: minY) } }
    public var maxXminY : CGPoint { get { return CGPoint(x: maxX, y: minY) } }
    public var minXmidY : CGPoint { get { return CGPoint(x: minX, y: midY) } }
    public var midXmidY : CGPoint { get { return CGPoint(x: midX, y: midY) } }
    public var mid      : CGPoint { get { return CGPoint(x: midX, y: midY) } }
    public var maxXmidY : CGPoint { get { return CGPoint(x: maxX, y: midY) } }
    public var minXmaxY : CGPoint { get { return CGPoint(x: minX, y: maxY) } }
    public var midXmaxY : CGPoint { get { return CGPoint(x: midX, y: maxY) } }
    public var maxXmaxY : CGPoint { get { return CGPoint(x: maxX, y: maxY) } }

    //
    // The functions below will never change the rectangle's size
    //

    public mutating func setMinX(newValue: CGFloat) { origin.x = newValue }
    public mutating func setLeft(newValue: CGFloat) { origin.x = newValue }
    public mutating func setLeading(newValue: CGFloat) { origin.x = newValue }
    public mutating func setMidX(newValue: CGFloat) { origin.x = newValue - size.width / 2 }
    public mutating func setMaxX(newValue: CGFloat) { origin.x = newValue - size.width }
    public mutating func setRight(newValue: CGFloat) { origin.x = newValue - size.width }
    public mutating func setTrailing(newValue: CGFloat) { origin.x = newValue - size.width }
    public mutating func setMinY(newValue: CGFloat) { origin.y = newValue }
    public mutating func setTop(newValue: CGFloat) { origin.y = newValue }
    public mutating func setMidY(newValue: CGFloat) { origin.y = newValue - size.height / 2 }
    public mutating func setMaxY(newValue: CGFloat) { origin.y = newValue - size.height }
    public mutating func setBottom(newValue: CGFloat) { origin.y = newValue - size.height }

    public func rectBySettingMinX(newValue: CGFloat) -> CGRect { var r = self; r.setMinX(newValue); return r }
    public func rectBySettingLeft(newValue: CGFloat) -> CGRect { var r = self; r.setLeft(newValue); return r }
    public func rectBySettingLeading(newValue: CGFloat) -> CGRect { var r = self; r.setLeading(newValue); return r }
    public func rectBySettingMidX(newValue: CGFloat) -> CGRect { var r = self; r.setMidX(newValue); return r }
    public func rectBySettingMaxX(newValue: CGFloat) -> CGRect { var r = self; r.setMaxX(newValue); return r }
    public func rectBySettingRight(newValue: CGFloat) -> CGRect { var r = self; r.setRight(newValue); return r }
    public func rectBySettingTrailing(newValue: CGFloat) -> CGRect { var r = self; r.setTrailing(newValue); return r }
    public func rectBySettingMinY(newValue: CGFloat) -> CGRect { var r = self; r.setMinY(newValue); return r }
    public func rectBySettingTop(newValue: CGFloat) -> CGRect { var r = self; r.setTop(newValue); return r }
    public func rectBySettingMidY(newValue: CGFloat) -> CGRect { var r = self; r.setMidY(newValue); return r }
    public func rectBySettingMaxY(newValue: CGFloat) -> CGRect { var r = self; r.setMaxY(newValue); return r }
    public func rectBySettingBottom(newValue: CGFloat) -> CGRect { var r = self; r.setBottom(newValue); return r }

    public mutating func setMinXminY(newValue: CGPoint) { self.setMinX(newValue.x); self.setMinY(newValue.y) }
    public mutating func setMidXminY(newValue: CGPoint) { self.setMidX(newValue.x); self.setMinY(newValue.y) }
    public mutating func setMaxXminY(newValue: CGPoint) { self.setMaxX(newValue.x); self.setMinY(newValue.y) }
    public mutating func setMinXmidY(newValue: CGPoint) { self.setMinX(newValue.x); self.setMidY(newValue.y) }
    public mutating func setMidXmidY(newValue: CGPoint) { self.setMidX(newValue.x); self.setMidY(newValue.y) }
    public mutating func setMid     (newValue: CGPoint) { self.setMidX(newValue.x); self.setMidY(newValue.y) }
    public mutating func setMaxXmidY(newValue: CGPoint) { self.setMaxX(newValue.x); self.setMidY(newValue.y) }
    public mutating func setMinXmaxY(newValue: CGPoint) { self.setMinX(newValue.x); self.setMaxY(newValue.y) }
    public mutating func setMidXmaxY(newValue: CGPoint) { self.setMidX(newValue.x); self.setMaxY(newValue.y) }
    public mutating func setMaxXmaxY(newValue: CGPoint) { self.setMaxX(newValue.x); self.setMaxY(newValue.y) }

    public func rectBySettingMinXminY(newValue: CGPoint) -> CGRect { var r = self; r.setMinXminY(newValue); return r }
    public func rectBySettingMidXminY(newValue: CGPoint) -> CGRect { var r = self; r.setMidXminY(newValue); return r }
    public func rectBySettingMaxXminY(newValue: CGPoint) -> CGRect { var r = self; r.setMaxXminY(newValue); return r }
    public func rectBySettingMinXmidY(newValue: CGPoint) -> CGRect { var r = self; r.setMinXmidY(newValue); return r }
    public func rectBySettingMidXmidY(newValue: CGPoint) -> CGRect { var r = self; r.setMidXmidY(newValue); return r }
    public func rectBySettingMid     (newValue: CGPoint) -> CGRect { var r = self; r.setMidXmidY(newValue); return r }
    public func rectBySettingMaxXmidY(newValue: CGPoint) -> CGRect { var r = self; r.setMaxXmidY(newValue); return r }
    public func rectBySettingMinXmaxY(newValue: CGPoint) -> CGRect { var r = self; r.setMinXmaxY(newValue); return r }
    public func rectBySettingMidXmaxY(newValue: CGPoint) -> CGRect { var r = self; r.setMidXmaxY(newValue); return r }
    public func rectBySettingMaxXmaxY(newValue: CGPoint) -> CGRect { var r = self; r.setMaxXmaxY(newValue); return r }
    
    //
    // The functions below generally change the rectangle's size
    //
    
    public mutating func setWidth(newValue: CGFloat) { size.width = newValue }
    public mutating func setHeight(newValue: CGFloat) { size.height = newValue }
    
    public func rectBySettingWidth(newValue: CGFloat) -> CGRect { var r = self; r.setWidth(newValue); return r }
    public func rectBySettingHeight(newValue: CGFloat) -> CGRect { var r = self; r.setHeight(newValue); return r }
    
    public func rectByInsettingMinX(dx: CGFloat) -> CGRect { return CGRect(x: origin.x + dx, y: origin.y, width: size.width - dx, height: size.height).standardized }
    public func rectByInsettingLeft(dx: CGFloat) -> CGRect { return rectByInsettingMinX(dx) }
    public func rectByInsettingLeading(dx: CGFloat) -> CGRect { return rectByInsettingMinX(dx) }
    public func rectByInsettingMaxX(dx: CGFloat) -> CGRect { return CGRect(x: origin.x, y: origin.y, width: size.width - dx, height: size.height).standardized }
    public func rectByInsettingRight(dx: CGFloat) -> CGRect { return rectByInsettingMaxX(dx) }
    public func rectByInsettingTrailing(dx: CGFloat) -> CGRect { return rectByInsettingMaxX(dx) }
    public func rectByInsettingMinY(dy: CGFloat) -> CGRect { return CGRect(x: origin.x, y: origin.y + dy, width: size.width, height: size.height - dy).standardized }
    public func rectByInsettingTop(dy: CGFloat) -> CGRect { return rectByInsettingMinY(dy) }
    public func rectByInsettingMaxY(dy: CGFloat) -> CGRect { return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height - dy).standardized }
    public func rectByInsettingBottom(dy: CGFloat) -> CGRect { return rectByInsettingMaxY(dy) }

    public mutating func insetMinX(dx: CGFloat) { self = rectByInsettingMinX(dx) }
    public mutating func insetLeft(dx: CGFloat) { self = rectByInsettingLeft(dx) }
    public mutating func insetLeading(dx: CGFloat) { self = rectByInsettingLeading(dx) }
    public mutating func insetMaxX(dx: CGFloat) { self = rectByInsettingMaxX(dx) }
    public mutating func insetRight(dx: CGFloat) { self = rectByInsettingRight(dx) }
    public mutating func insetTrailing(dx: CGFloat) { self = rectByInsettingTrailing(dx) }
    public mutating func insetMinY(dy: CGFloat) { self = rectByInsettingMinY(dy) }
    public mutating func insetTop(dy: CGFloat) { self = rectByInsettingTop(dy) }
    public mutating func insetMaxY(dy: CGFloat) { self = rectByInsettingMaxY(dy) }
    public mutating func insetBottom(dy: CGFloat) { self = rectByInsettingBottom(dy) }

    public func rectBySettingMinXIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingMinX(newValue - self.minX) }
    public func rectBySettingLeftIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingLeft(newValue - self.left) }
    public func rectBySettingLeadingIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingLeading(newValue - self.leading) }
    public func rectBySettingMaxXIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingRight(newValue - self.maxX) }
    public func rectBySettingRightIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingRight(newValue - self.right) }
    public func rectBySettingTrailingIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingTrailing(newValue - self.trailing) }
    public func rectBySettingMinYIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingMinY(newValue - self.minY) }
    public func rectBySettingTopIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingTop(newValue - self.top) }
    public func rectBySettingMaxYIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingMaxY(newValue - self.maxY) }
    public func rectBySettingBottomIndependent(newValue: CGFloat) -> CGRect { return rectByInsettingBottom(newValue - self.bottom) }

    public mutating func setMinXIndependent(newValue: CGFloat) { self = rectBySettingMinXIndependent(newValue) }
    public mutating func setLeftIndependent(newValue: CGFloat) { self = rectBySettingLeftIndependent(newValue) }
    public mutating func setLeadingIndependent(newValue: CGFloat) { self = rectBySettingLeadingIndependent(newValue) }
    public mutating func setMaxXIndependent(newValue: CGFloat) { self = rectBySettingMaxXIndependent(newValue) }
    public mutating func setRightIndependent(newValue: CGFloat) { self = rectBySettingRightIndependent(newValue) }
    public mutating func setTrailingIndependent(newValue: CGFloat) { self = rectBySettingTrailingIndependent(newValue) }
    public mutating func setMinYIndependent(newValue: CGFloat) { self = rectBySettingMinYIndependent(newValue) }
    public mutating func setTopIndependent(newValue: CGFloat) { self = rectBySettingTopIndependent(newValue) }
    public mutating func setMaxYIndependent(newValue: CGFloat) { self = rectBySettingMaxYIndependent(newValue) }
    public mutating func setBottomIndependent(newValue: CGFloat) { self = rectBySettingBottomIndependent(newValue) }
    
    public func rectByScalingRelativeToPoint(p: CGPoint, scaling s: CGVector) -> CGRect {
        return CGRect(
            origin: origin.scaleRelativeToPoint(p, sx: s.dx, sy: s.dy),
            size: size.scale(sx: s.dx, sy: s.dy)
        )
    }
    
    public mutating func scaleRelativeToPoint(p: CGPoint, scaling s: CGVector) {
        self = rectByScalingRelativeToPoint(p, scaling: s)
    }
}
