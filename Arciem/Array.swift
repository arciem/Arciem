//
//  Array.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public func randomIndex<T>(array: Array<T>, random: Random = Random.sharedInstance) -> Int {
    return random.randomInt(0..<array.count)
}

public func shuffled<T>(array: Array<T>, random: Random = Random.sharedInstance) -> Array<T> {
    var result = array
    for var a = 0; a < result.count; ++a {
        let b = randomIndex(array, random: random)
        swap(&result[a], &result[b])
    }
    return result
}

public extension Array {
//    public func randomIndex(random: Random = Random.sharedInstance) -> Int {
//        return random.randomInt(0..<self.count)
//    }
//
//    public func shuffled(random: Random = Random.sharedInstance) -> Array {
//        var result = self
//        for var a = 0; a < result.count; ++a {
//            let b = randomIndex(random: random)
//            swap(&result[a], &result[b])
//        }
//        return result
//    }
}