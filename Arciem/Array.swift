//
//  Array.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public extension Array {
    public func randomIndex(random: Random = random) -> Int {
        return random.randomInt(min: 0, max: self.count)
    }
    
    public func shuffled(random: Random = random) -> Array {
        var result = self
        for var a = 0; a < result.count; ++a {
            let b = randomIndex(random: random)
            swap(&result[a], &result[b])
        }
        return result
    }
}