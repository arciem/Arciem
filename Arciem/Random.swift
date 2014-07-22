//
//  Random.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public var random = Random()

/*
**  longrand() -- generate 2**31-2 random numbers
**
**  public domain by Ray Gardner
**
**  based on "Random Number Generators: Good Ones Are Hard to Find",
**  S.K. Park and K.W. Miller, Communications of the ACM 31:10 (Oct 1988),
**  and "Two Fast Implementations of the 'Minimal Standard' Random
**  Number Generator", David G. Carta, Comm. ACM 33, 1 (Jan 1990), p. 87-88
**
**  linear congruential generator f(z) = 16807 z mod (2 ** 31 - 1)
*/

public class Random {
    private var seed:Int32 = 1
    private let a:UInt64 = 16807
    private let m:UInt64 = UInt64(UInt32.max >> 1)
    
    public init(seed:Int32) {
        self.seed = seed
    }
    
    public init() {
        reseed()
    }
    
    public func reseed() {
        let s:NSNumber = time(nil)
        self.seed = s.intValue
        // Throw away the first value, which may be similar from run to run
        random()
    }
    
    // returns a random Int32 in the half-open range 0..m
    public func random() -> Int32 {
        seed = Int32((a &* UInt64(seed)) &% m)
        return seed
    }
    
    // returns a floating point value in the half-open range 0..1
    public func randomFlat() -> Double {
        return Double(random()) / Double(m)
    }
    
    // returns a floating point value in the half-open range min..max
    public func randomRange(#min:Double, max:Double) -> Double {
        return denormalize(randomFlat(), min, max)
    }
    
    // returns an integer in the half-open range min..max
    public func randomInt(#min:Int, max:Int) -> Int {
        return Int(randomRange(min: Double(min), max: Double(max)))
    }
    
    // "Generating Gaussian Random Numbers"
    // http://www.taygeta.com/random/gaussian.html
    public func randomGaussian() -> Double {
        return sqrt( -2.0 * log(randomFlat()) ) * cos( 2.0 * M_PI * randomFlat() )
    }
}
