//
//  Box.swift
//  Arciem
//
//  Created by Robert McNally on 1/29/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

// Used to work around some Swift compiler issues.
public final class Box<T> {
    public let unbox: T
    public init(_ value: T) { unbox = value }
}

extension Box : Printable {
    public var description: String {
        get {
            return "Box(\(unbox))"
        }
    }
}
