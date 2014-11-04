//
//  Runtime.swift
//  Arciem
//
//  Created by Robert McNally on 6/11/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public func setAssociatedObject(#object: NSObject, #key: NSString, #value: NSObject?) {
    setAssociatedObject_glue(object, key, value)
}

public func getAssociatedObject(#object: NSObject, #key: NSString) -> NSObject? {
    return getAssociatedObject_glue(object, key)
}

public func toUnsafePointer<T>(inout t: T) -> UnsafePointer<T> {
    return withUnsafePointer(&t) {
        return $0
    }
}

public func toUnsafeMutablePointer<T>(inout t: T) -> UnsafeMutablePointer<T> {
    return withUnsafeMutablePointer(&t) {
        return $0
    }
}

public func typeNameOf(value: Any) -> String {
    let typeLongName = _stdlib_getDemangledTypeName(value)
    return typeLongName
}

public func typeNameOf(value: AnyObject) -> String {
    let typeLongName = _stdlib_getDemangledTypeName(value)
    return typeLongName
}

public func pointerStringOf(obj: AnyObject) -> String {
    let ptr: COpaquePointer =
    Unmanaged<AnyObject>.passUnretained(obj).toOpaque()
    return "\(ptr)"
}

public func identifierOfType(value: Any) -> String {
    var s = "\(typeNameOf(value))"
    return s
}

public func identifierOfObject(obj: AnyObject) -> String {
    var s = "\(typeNameOf(obj)) <\(pointerStringOf(obj))>"
    return s
}

public func identifierOfValue(value: Debuggable) -> String {
    var s = "\(typeNameOf(value))"
    if let debugName = value.debugName? {
        s += " <\(debugName)>"
    }
    return s
}
