//
//  IntPoint.swift
//  Arciem
//
//  Created by Robert McNally on 11/14/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct IntPoint {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension IntPoint : Printable {
    public var description: String {
        get {
            return "IntPoint(x:\(x) y:\(y))"
        }
    }
}
