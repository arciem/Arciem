//
//  Envelope.swift
//  Arciem
//
//  Created by Robert McNally on 1/29/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

// Used to work around some Swift compiler issues.
public final class 📦<🍒> {
    public let unbox: 🍒
    public init(_ value: 🍒) { unbox = value }
}

extension 📦 : Printable {
    public var description: String {
        get {
            return "📦(\(unbox))"
        }
    }
}

public postfix func ⬇️<🍒>(🅛: 🍒) -> 📦<🍒> { return 📦(🅛) }
public postfix func ⬆️<🍒>(🅛: 📦<🍒>) -> 🍒 { return 🅛.unbox }
