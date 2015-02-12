//
//  Angles.swift
//  Arciem
//
//  Created by Robert McNally on 8/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public protocol Angle {
    var degrees: Double { get }
    var radians: Double { get }
    var sin: Double { get }
    var cos: Double { get }
}


public struct Degrees : Angle {
    public var degrees: Double
    
    public init(_ d: Double) { self.degrees = d }
    public init(_ d: Float) { self.degrees = Double(d) }
    public init(_ d: Int) { self.degrees = Double(d) }
    public init(_ r: Radians) { self.degrees = r.degrees }
    
    public var radians: Double { get { return degrees * deg2rad } }
    public var sin: Double { get { return Foundation.sin(radians) } }
    public var cos: Double { get { return Foundation.cos(radians) } }
}

extension Degrees : IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension Degrees : FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) { self.init(value) }
}

extension Degrees : Comparable { }

public func == (lhs: Degrees, rhs: Degrees) -> Bool {
    return lhs.degrees == rhs.degrees
}

public func < (lhs: Degrees, rhs: Degrees) -> Bool {
    return lhs.degrees < rhs.degrees
}

public prefix func -(rhs: Degrees) -> Degrees {
    return Degrees(-rhs.degrees)
}

public func +(lhs: Degrees, rhs: Degrees) -> Degrees {
    return Degrees(lhs.degrees + rhs.degrees)
}

public func -(lhs: Degrees, rhs: Degrees) -> Degrees {
    return Degrees(lhs.degrees - rhs.degrees)
}

public func *(lhs: Degrees, rhs: Degrees) -> Degrees {
    return Degrees(lhs.degrees * rhs.degrees)
}

public func /(lhs: Degrees, rhs: Degrees) -> Degrees {
    return Degrees(lhs.degrees / rhs.degrees)
}

public func %(lhs: Degrees, rhs: Degrees) -> Degrees {
    return Degrees(lhs.degrees % rhs.degrees)
}

public func +=(inout lhs: Degrees, rhs: Degrees) {
    lhs.degrees += rhs.degrees
}

public func -=(inout lhs: Degrees, rhs: Degrees) {
    lhs.degrees -= rhs.degrees
}

public func *=(inout lhs: Degrees, rhs: Degrees) {
    lhs.degrees *= rhs.degrees
}

public func /=(inout lhs: Degrees, rhs: Degrees) {
    lhs.degrees /= rhs.degrees
}

public func %=(inout lhs: Degrees, rhs: Degrees) {
    lhs.degrees %= rhs.degrees
}


public struct Radians : Angle {
    public var radians: Double
    
    public init(_ r: Double) { self.radians = r }
    public init(_ r: Float) { self.radians = Double(r) }
    public init(_ r: Int) { self.radians = Double(r) }
    public init(_ d: Degrees) { self.radians = d.radians }
    
    public var degrees: Double { get { return radians * rad2deg } }
    public var sin: Double { get { return Foundation.sin(radians) } }
    public var cos: Double { get { return Foundation.cos(radians) } }
}

extension Radians : IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension Radians : FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) { self.init(value) }
}

extension Radians : Comparable { }

public func == (lhs: Radians, rhs: Radians) -> Bool {
    return lhs.radians == rhs.radians
}

public func < (lhs: Radians, rhs: Radians) -> Bool {
    return lhs.radians < rhs.radians
}

public prefix func -(rhs: Radians) -> Radians {
    return Radians(-rhs.radians)
}

public func +(lhs: Radians, rhs: Radians) -> Radians {
    return Radians(lhs.radians + rhs.radians)
}

public func -(lhs: Radians, rhs: Radians) -> Radians {
    return Radians(lhs.radians - rhs.radians)
}

public func *(lhs: Radians, rhs: Radians) -> Radians {
    return Radians(lhs.radians * rhs.radians)
}

public func /(lhs: Radians, rhs: Radians) -> Radians {
    return Radians(lhs.radians / rhs.radians)
}

public func %(lhs: Radians, rhs: Radians) -> Radians {
    return Radians(lhs.radians % rhs.radians)
}

public func +=(inout lhs: Radians, rhs: Radians) {
    lhs.radians += rhs.radians
}

public func -=(inout lhs: Radians, rhs: Radians) {
    lhs.radians -= rhs.radians
}

public func *=(inout lhs: Radians, rhs: Radians) {
    lhs.radians *= rhs.radians
}

public func /=(inout lhs: Radians, rhs: Radians) {
    lhs.radians /= rhs.radians
}

public func %=(inout lhs: Radians, rhs: Radians) {
    lhs.radians %= rhs.radians
}
