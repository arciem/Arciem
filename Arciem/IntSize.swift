//
//  IntSize.swift
//  Arciem
//
//  Created by Robert McNally on 11/14/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

public struct IntSize {
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public func randomX(_ random: Random = Random.sharedInstance) -> Int {
        return random.randomInt(0..<width)
    }
    
    public func randomY(_ random: Random = Random.sharedInstance) -> Int {
        return random.randomInt(0..<height)
    }
    
    public func randomPoint(_ random: Random = Random.sharedInstance) -> IntPoint {
        return IntPoint(x: randomX(random), y: randomY(random))
    }
}

extension IntSize : Printable {
    public var description: String {
        get {
            return "IntSize(width:\(width) height:\(height))"
        }
    }
}