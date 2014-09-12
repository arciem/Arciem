//
//  Angles.swift
//  Arciem
//
//  Created by Robert McNally on 8/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import CoreGraphics

public let pi: Double = M_PI
public let piOverTwo: Double = M_PI_2
public let twoPi: Double = 2.0 * pi
public let rad2deg: Double = 180.0 / pi
public let deg2rad: Double = pi / 180.0

public typealias FloatDegrees = Degrees<Float>
public typealias DoubleDegrees = Degrees<Double>
public typealias CGDegrees = Degrees<CGFloat>

public typealias FloatRadians = Radians<Float>
public typealias DoubleRadians = Radians<Double>
public typealias CGRadians = Radians<CGFloat>

public protocol Angle {
    typealias NativeType
    init(degrees: NativeType)
    init(radians: NativeType)
    var degrees: NativeType { get }
    var radians: NativeType { get }
    var sin: NativeType { get }
    var cos: NativeType { get }
}

public struct Degrees<T: Floatable> : Angle {
    public typealias NativeType = T
    
    public var degrees: T
    
    public init(degrees: T) { self.degrees = degrees }
    public init(radians: T) { self.degrees = Radians.toDegrees(radians) }

    public init(_ radians: Radians<T>) { self.degrees = radians.degrees }
    
    public static func toRadians(degrees: T) -> T { return degrees * T(deg2rad) }
    
    public var radians: T {
        get {
            return self.dynamicType.toRadians(degrees)
        }
    }
    
    public var sin: T {
        get {
            return T.sin(radians)
        }
    }
    
    public var cos: T {
        get {
            return T.cos(radians)
        }
    }
}

extension Degrees : IntegerLiteralConvertible {
    public static func convertFromIntegerLiteral(value: IntegerLiteralType) -> Degrees<T> {
        return Degrees(degrees:T(value))
    }
}

extension Degrees : FloatLiteralConvertible {
    public static func convertFromFloatLiteral(value: FloatLiteralType) -> Degrees<T> {
        return Degrees(degrees:T(value))
    }
}

extension Degrees : Comparable { }

public func == <T: Comparable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Bool {
    return lhs.degrees == rhs.degrees
}

public func < <T: Comparable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Bool {
    return lhs.degrees < rhs.degrees
}

extension Degrees : Arithmeticable { }

public func + <T: Arithmeticable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(degrees:lhs.degrees + rhs.degrees)
}

public func - <T: Arithmeticable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(degrees:lhs.degrees - rhs.degrees)
}

public func * <T: Arithmeticable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(degrees:lhs.degrees * rhs.degrees)
}

public func / <T: Arithmeticable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(degrees:lhs.degrees / rhs.degrees)
}

public func % <T: Arithmeticable>(lhs: Degrees<T>, rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(degrees:lhs.degrees % rhs.degrees)
}

public func += <T: Arithmeticable>(inout lhs: Degrees<T>, rhs: Degrees<T>) {
    lhs.degrees += rhs.degrees
}

public func -= <T: Arithmeticable>(inout lhs: Degrees<T>, rhs: Degrees<T>) {
    lhs.degrees -= rhs.degrees
}

public func *= <T: Arithmeticable>(inout lhs: Degrees<T>, rhs: Degrees<T>) {
    lhs.degrees *= rhs.degrees
}

public func /= <T: Arithmeticable>(inout lhs: Degrees<T>, rhs: Degrees<T>) {
    lhs.degrees /= rhs.degrees
}

public func %= <T: Arithmeticable>(inout lhs: Degrees<T>, rhs: Degrees<T>) {
    lhs.degrees %= rhs.degrees
}


public struct Radians<T: Floatable> : Angle {
    public typealias NativeType = T
    
    public var radians: T
    
    public init(radians: T) { self.radians = radians }
    public init(degrees: T) { self.radians = Degrees.toRadians(degrees) }

    public init(_ degrees: Degrees<T>) { self.radians = degrees.radians }
    
    public static func toDegrees(radians: T) -> T { return radians * T(rad2deg) }
    
    public var degrees: T {
        get {
            return self.dynamicType.toDegrees(radians)
        }
    }
    
    public var sin: T {
        get {
            return T.sin(radians)
        }
    }
    
    public var cos: T {
        get {
            return T.cos(radians)
        }
    }
}

extension Radians : IntegerLiteralConvertible {
    public static func convertFromIntegerLiteral(value: IntegerLiteralType) -> Radians<T> {
        return Radians(radians: T(value))
    }
}

extension Radians : FloatLiteralConvertible {
    public static func convertFromFloatLiteral(value: FloatLiteralType) -> Radians<T> {
        return Radians(radians: T(value))
    }
}

extension Radians : Comparable {
}

public func == <T: Comparable>(lhs: Radians<T>, rhs: Radians<T>) -> Bool {
    return lhs.radians == rhs.radians
}

public func < <T: Comparable>(lhs: Radians<T>, rhs: Radians<T>) -> Bool {
    return lhs.radians < rhs.radians
}

extension Radians : Arithmeticable { }

public func + <T: Arithmeticable>(lhs: Radians<T>, rhs: Radians<T>) -> Radians<T> {
    return Radians(radians: lhs.radians + rhs.radians)
}

public func - <T: Arithmeticable>(lhs: Radians<T>, rhs: Radians<T>) -> Radians<T> {
    return Radians(radians: lhs.radians - rhs.radians)
}

public func * <T: Arithmeticable>(lhs: Radians<T>, rhs: Radians<T>) -> Radians<T> {
    return Radians(radians: lhs.radians * rhs.radians)
}

public func / <T: Arithmeticable>(lhs: Radians<T>, rhs: Radians<T>) -> Radians<T> {
    return Radians(radians: lhs.radians / rhs.radians)
}

public func % <T: Arithmeticable>(lhs: Radians<T>, rhs: Radians<T>) -> Radians<T> {
    return Radians(radians: lhs.radians % rhs.radians)
}

public func += <T: Arithmeticable>(inout lhs: Radians<T>, rhs: Radians<T>) {
    lhs.radians += rhs.radians
}

public func -= <T: Arithmeticable>(inout lhs: Radians<T>, rhs: Radians<T>) {
    lhs.radians -= rhs.radians
}

public func *= <T: Arithmeticable>(inout lhs: Radians<T>, rhs: Radians<T>) {
    lhs.radians *= rhs.radians
}

public func /= <T: Arithmeticable>(inout lhs: Radians<T>, rhs: Radians<T>) {
    lhs.radians /= rhs.radians
}

public func %= <T: Arithmeticable>(inout lhs: Radians<T>, rhs: Radians<T>) {
    lhs.radians %= rhs.radians
}
