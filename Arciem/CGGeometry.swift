//
//  CGGeometry.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

public typealias CGAngle = CGFloat    // Radians
public typealias CGDegrees = CGFloat  // Degrees

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
    get { return Arciem.distanceSquared(x: x, y: y) }
    }
    
    public var distance: CGFloat {
    get { return Arciem.distance(x: x, y: y) }
    }
    
    public var angle: CGAngle {
    get { return Arciem.angle(x: x, y: y) }
    }
    
    public func interpolate(p: CGPoint, t: CGFloat) -> CGPoint {
        let tu = Arciem.interpolate(x1: x, y1: y, x2: p.x, y2: p.y, t: t)
        return CGPoint(x: tu.x, y:tu.y)
    }
    
    public func clampInside(r: CGRect) -> CGPoint {
        return CGPoint(
            x: clamp(x, r.minX...r.maxX),
            y: clamp(y, r.minY...r.maxY)
        )
    }
    
    public func distance(p: CGPoint) -> CGFloat {
        return Arciem.distance(x1: x, y1: y, x2: p.x, y2: p.y)
    }
    
    public func distanceSquared(p: CGPoint) -> CGFloat {
        return Arciem.distanceSquared(x1: x, y1: y, x2: p.x, y2: p.y)
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
    
    public func rotateRelativeToPoint(p: CGPoint, angle: CGAngle) -> CGPoint {
        let ox = p.x
        let oy = p.y
        
        let v1 = sin(angle)
        let v2 = cos(angle)
        let v3 = -oy + y
        let v4 = -ox + x
        return CGPoint(x: ox - v1*v3 + v2*v4, y: oy + v2*v3 + v1*v4)
    }
    
    public func scale(#sx: CGFloat, sy: CGFloat) -> CGPoint {
        let t = Arciem.scale(x: x, y: y, sx: sx, sy: sy)
        return CGPoint(x: t.x, y: t.y)
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
    get { return Arciem.distanceSquared(x: dx, y: dy) }
    }
    
    public var distance: CGFloat {
    get { return Arciem.distance(x: dx, y: dy) }
    }
    
    public var angle: CGAngle {
    get { return Arciem.angle(x: dx, y: dy) }
    }
    
    public var area: CGFloat {
    get { return Arciem.area(x: dx, y: dy) }
    }
    
    public var normalize: CGVector {
    get { let t = Arciem.normalize(x: dx, y: dy)
        return CGVector(dx: t.x, dy: t.y) }
    }
    
    public func dot(d: CGVector) -> CGFloat {
        return Arciem.dot(x1: dx, y1: dy, x2: d.dx, y2: d.dy)
    }

    public func addQuarterRotation() -> CGVector { return CGVector(dx: -dy, dy: dx) }
    public func subtractQuarterRotation() -> CGVector { return CGVector(dx: dy, dy: -dx) }
    public func halfRotation() -> CGVector { return CGVector(dx: -dx, dy: -dy) }
    
    public func rotate(#angle: CGAngle) -> CGVector {
        let t = Arciem.rotate(x: dx, y: dy, angle: angle);
        return CGVector(dx: t.x, dy: t.y)
    }
    
    public func fromPolar(#radius: CGFloat, angle: CGFloat) -> CGVector {
        let t = Arciem.fromPolar(radius: radius, angle: angle)
        return CGVector(dx: t.x, dy: t.y)
    }
    
    public func scale(#sx: CGFloat, sy: CGFloat) -> CGVector {
        let t = Arciem.scale(x: dx, y: dy, sx: sx, sy: sy)
        return CGVector(dx: t.x, dy: t.y)
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
    public func scaleForAspectFitWithin(#size:CGSize) -> CGFloat {
        return scaleForAspectFit(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
    }

    public func scaleForAspectFillWithin(#size:CGSize) -> CGFloat {
        return scaleForAspectFill(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
    }
    
    public func aspectFitWithin(#size:CGSize) -> CGSize {
        let t = aspectFit(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
        return CGSize(width: t.x, height: t.y)
    }
    
    public func aspectFillWithin(#size:CGSize) -> CGSize {
        let t = aspectFill(dxContent: width, dyContent: height, dxArea: size.width, dyArea: size.height)
        return CGSize(width: t.x, height: t.y)
    }
    
    public func scale(#sx: CGFloat, sy: CGFloat) -> CGSize {
        let t = Arciem.scale(x: width, y: height, sx: sx, sy: sy);
        return CGSize(width: t.x, height: t.y)
    }
}

protocol CGRectLike {
    //
    // These are properties and methods defined by standard CGRect
    //

    var isNull: Bool { get }
    var isEmpty: Bool { get }
    var isInfinite: Bool { get }

    var standardizedRect: CGRect { get }
    mutating func standardize()
    
    var integerRect: CGRect { get }
    mutating func integerize()
    
    func rectByInsetting(#dx: CGFloat, dy: CGFloat) -> CGRect
    mutating func inset(#dx: CGFloat, dy: CGFloat)
    
    func rectByOffsetting(#dx: CGFloat, dy: CGFloat) -> CGRect
    mutating func offset(#dx: CGFloat, dy: CGFloat)
    
    func rectByUnion(withRect: CGRect) -> CGRect
    mutating func union(withRect: CGRect)
    
    func rectByIntersecting(withRect: CGRect) -> CGRect
    mutating func intersect(withRect: CGRect)
    
    func rectsByDividing(atDistance: CGFloat, fromEdge: CGRectEdge) -> (slice: CGRect, remainder: CGRect)
    
    func contains(rect: CGRect) -> Bool
    func contains(point: CGPoint) -> Bool
    
    func intersects(rect: CGRect) -> Bool
    
    //
    // The setters on these attributes will never change the rectangle's size
    //
    
    var minX     : CGFloat { get set }
    var left     : CGFloat { get set }
    var leading  : CGFloat { get set }
    var midX     : CGFloat { get set }
    var maxX     : CGFloat { get set }
    var right    : CGFloat { get set }
    var trailing : CGFloat { get set }
    var minY     : CGFloat { get set }
    var top      : CGFloat { get set }
    var midY     : CGFloat { get set }
    var maxY     : CGFloat { get set }
    var bottom   : CGFloat { get set }
    
    var minXminY : CGPoint { get set }
    var midXminY : CGPoint { get set }
    var maxXminY : CGPoint { get set }
    var minXmidY : CGPoint { get set }
    var midXmidY : CGPoint { get set }
    var mid      : CGPoint { get set }
    var maxXmidY : CGPoint { get set }
    var minXmaxY : CGPoint { get set }
    var midXmaxY : CGPoint { get set }
    var maxXmaxY : CGPoint { get set }
    
    //
    // The setters on these attributes will generally change the rectangle's size
    //
    
    var width  : CGFloat { get set }
    var height : CGFloat { get set }
    
    //
    // These functions return a rectangle that can be a different size than the original
    //
    
    func insetMinX(dx: CGFloat) -> CGRect
    func insetLeft(dx: CGFloat) -> CGRect
    func insetLeading(dx: CGFloat) -> CGRect
    
    func insetMaxX(dx: CGFloat) -> CGRect
    func insetRight(dx: CGFloat) -> CGRect
    func insetTrailing(dx: CGFloat) -> CGRect
    
    func insetMinY(dx: CGFloat) -> CGRect
    func insetTop(dx: CGFloat) -> CGRect
    
    func insetMaxY(dx: CGFloat) -> CGRect
    func insetBottom(dx: CGFloat) -> CGRect
    
    func setMinX(dx: CGFloat) -> CGRect
    func setLeft(dx: CGFloat) -> CGRect
    func setLeading(dx: CGFloat) -> CGRect

    func setMaxX(dx: CGFloat) -> CGRect
    func setRight(dx: CGFloat) -> CGRect
    func setTrailing(dx: CGFloat) -> CGRect
    
    func setMinY(dx: CGFloat) -> CGRect
    func setTop(dx: CGFloat) -> CGRect
    
    func setMaxY(dx: CGFloat) -> CGRect
    func setBottom(dx: CGFloat) -> CGRect
    
    func scaleRelativeToPoint(p: CGPoint, sx: CGFloat, sy: CGFloat) -> CGRect
}

extension CGRect : CGRectLike {
    //
    // The setters on these attributes will never change the rectangle's size
    //

    public var minX : CGFloat {
    get { return origin.x }
    set { origin.x = newValue }
    }
    
    public var left : CGFloat {
    get { return origin.x }
    set { origin.x = newValue }
    }
    
    public var leading : CGFloat {
    get { return origin.x }
    set { origin.x = newValue }
    }
    
    public var midX : CGFloat {
    get { return denormalize(0.5, minX, maxX) }
    set { origin.x = newValue - size.width / 2 }
    }
    
    public var maxX : CGFloat {
    get { return origin.x + size.width }
    set { origin.x = newValue - size.width }
    }
    
    public var right : CGFloat {
    get { return origin.x + size.width }
    set { origin.x = newValue - size.width }
    }
    
    public var trailing : CGFloat {
    get { return origin.x + size.width }
    set { origin.x = newValue - size.width }
    }
    
    public var minY : CGFloat {
    get { return origin.y }
    set { origin.y = newValue }
    }
    
    public var top : CGFloat {
    get { return origin.y }
    set { origin.y = newValue }
    }
    
    public var midY : CGFloat {
    get { return denormalize(0.5, minY, maxY) }
    set { origin.y = newValue - size.height / 2 }
    }
    
    public var maxY : CGFloat {
    get { return origin.y + size.height }
    set { origin.y = newValue - size.height }
    }
    
    public var bottom : CGFloat {
    get { return maxY }
    set { size.height = size.height - newValue; standardize() }
    }
    
    public var minXminY : CGPoint {
    get { return CGPoint(x: minX, y: minY) }
    set { minX = newValue.x; minY = newValue.y }
    }

    public var midXminY : CGPoint {
    get { return CGPoint(x: midX, y: minY) }
    set { midX = newValue.x; minY = newValue.y }
    }
    
    public var maxXminY : CGPoint {
    get { return CGPoint(x: maxX, y: minY) }
    set { maxX = newValue.x; minY = newValue.y }
    }
    
    public var minXmidY : CGPoint {
    get { return CGPoint(x: minX, y: midY) }
    set { minX = newValue.x; midY = newValue.y }
    }
    
    public var midXmidY : CGPoint {
    get { return CGPoint(x: midX, y: midY) }
    set { midX = newValue.x; midY = newValue.y }
    }
    
    public var mid : CGPoint {
    get { return CGPoint(x: midX, y: midY) }
    set { midX = newValue.x; midY = newValue.y }
    }
    
    public var maxXmidY : CGPoint {
    get { return CGPoint(x: maxX, y: midY) }
    set { maxX = newValue.x; midY = newValue.y }
    }
    
    public var minXmaxY : CGPoint {
    get { return CGPoint(x: minX, y: maxY) }
    set { minX = newValue.x; maxY = newValue.y }
    }
    
    public var midXmaxY : CGPoint {
    get { return CGPoint(x: midX, y: maxY) }
    set { midX = newValue.x; maxY = newValue.y }
    }
    
    public var maxXmaxY : CGPoint {
    get { return CGPoint(x: maxX, y: maxY) }
    set { maxX = newValue.x; maxY = newValue.y }
    }
    
    //
    // The setters on these attributes will generally change the rectangle's size
    //
    
    public var width : CGFloat {
    get { return size.width }
    set { size.width = newValue }
    }
    
    public var height : CGFloat {
    get { return size.height }
    set { size.height = newValue }
    }
    
    //
    // These functions return a rectangle that can be a different size than the original
    //
    
    public func insetMinX(dx: CGFloat) -> CGRect { return CGRect(x: origin.x + dx, y: origin.y, width: size.width - dx, height: size.height).standardizedRect }
    
    public func insetLeft(dx: CGFloat) -> CGRect { return insetMinX(dx) }
    
    public func insetLeading(dx: CGFloat) -> CGRect { return insetMinX(dx) }
    
    public func insetMaxX(dx: CGFloat) -> CGRect { return CGRect(x: origin.x, y: origin.y, width: size.width - dx, height: size.height).standardizedRect }
    
    public func insetRight(dx: CGFloat) -> CGRect { return insetMaxX(dx) }
    
    public func insetTrailing(dx: CGFloat) -> CGRect { return insetMaxX(dx) }
    
    public func insetMinY(dy: CGFloat) -> CGRect { return CGRect(x: origin.x, y: origin.y + dy, width: size.width, height: size.height - dy).standardizedRect }
    
    public func insetTop(dy: CGFloat) -> CGRect { return insetMinY(dy) }
    
    public func insetMaxY(dy: CGFloat) -> CGRect { return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height - dy).standardizedRect }
    
    public func insetBottom(dy: CGFloat) -> CGRect { return insetMaxY(dy) }
    
    public func setMinX(x: CGFloat) -> CGRect { let dx = x - origin.x; return CGRect(x: x, y: origin.y, width: size.width - dx, height: size.height).standardizedRect }
    
    public func setLeft(x: CGFloat) -> CGRect { return setMinX(x) }
    
    public func setLeading(x: CGFloat) -> CGRect { return setMinX(x) }
    
    public func setMaxX(x: CGFloat) -> CGRect { let dx = x - maxX; return CGRect(x: origin.x, y: origin.y, width: size.width + dx, height: size.height).standardizedRect }
    
    public func setRight(x: CGFloat) -> CGRect { return setMaxX(x) }
    
    public func setTrailing(x: CGFloat) -> CGRect { return setMaxX(x) }
    
    public func setMinY(y: CGFloat) -> CGRect { let dy = y - origin.y; return CGRect(x: origin.x, y: y, width: size.width, height: size.height - dy).standardizedRect }
    
    public func setTop(x: CGFloat) -> CGRect { return setMinY(x) }
    
    public func setMaxY(y: CGFloat) -> CGRect {
        let dy = y - maxY; return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height + dy).standardizedRect }
    
    public func setBottom(x: CGFloat) -> CGRect { return setMaxY(x) }
    
    public func scaleRelativeToPoint(p: CGPoint, sx: CGFloat, sy: CGFloat) -> CGRect {
        return CGRect(
            origin: origin.scaleRelativeToPoint(p, sx: sx, sy: sy),
            size: size.scale(sx: sx, sy: sy)
        )
    }
}
