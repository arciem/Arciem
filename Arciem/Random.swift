//
//  Random.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

private var _instance = Random()

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

//    public lazy var instance = Random()

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
    
    public class var sharedInstance: Random {
        get {
            return _instance
        }
    }
    
    // returns a random Int32 in the half-open interval 0..<m
    func random() -> Int32 {
        seed = Int32((a &* UInt64(seed)) &% m)
        return seed
    }
    
    // returns a random Double in the half-open interval 0..<1
    public func randomDouble() -> Double {
        return Double(random()) / Double(m)
    }
    
    // returns a random Float in the half-open interval 0..<1
    public func randomFloat() -> Float {
        return Float(random()) / Float(m)
    }
    
    // returns a random CGFloat in the half-open interval 0..<1
    public func randomCGFloat() -> CGFloat {
        return CGFloat(random()) / CGFloat(m)
    }
    
    // returns a random Double in the half-open interval start..<end
    public func randomDouble(i: HalfOpenInterval<Double>) -> Double {
        return denormalize(randomDouble(), i.start, i.end)
    }
    
    // returns a random Float in the half-open interval start..<end
    public func randomFloat(i: HalfOpenInterval<Float>) -> Float {
        return denormalize(randomFloat(), i.start, i.end)
    }
    
    // returns a random CGFloat in the half-open interval start..<end
    public func randomCGFloat(i: HalfOpenInterval<CGFloat>) -> CGFloat {
        return denormalize(randomCGFloat(), i.start, i.end)
    }
    
    // returns an integer in the half-open interval start..<end
    public func randomInt(i: HalfOpenInterval<Int>) -> Int {
        return Int(randomDouble(Double(i.start)..<Double(i.end)))
    }
    
    // returns an integer in the closed interval start...end
    public func randomInt(i: ClosedInterval<Int>) -> Int {
        return Int(randomDouble(Double(i.start)..<Double(i.end + 1)))
    }
    
    // returns a random boolean
    public func randomBoolean() -> Bool {
        return randomInt(0...1) > 0
    }
    
    // "Generating Gaussian Random Numbers"
    // http://www.taygeta.com/random/gaussian.html
    public func randomGaussian() -> Double {
        return sqrt( -2.0 * log(randomDouble()) ) * cos( 2.0 * M_PI * randomDouble() )
    }
    
    // returns a random Double in the half-open interval 0..<1
    public class func randomDouble() -> Double {
        return Random.sharedInstance.randomDouble()
    }
    
    // returns a random Float in the half-open interval 0..<1
    public class func randomFloat() -> Float {
        return Random.sharedInstance.randomFloat()
    }
    
    // returns a random CGFloat in the half-open interval 0..<1
    public class func randomCGFloat() -> CGFloat {
        return Random.sharedInstance.randomCGFloat()
    }
    
    public class func randomDouble(i: HalfOpenInterval<Double>) -> Double {
        return Random.sharedInstance.randomDouble(i)
    }
    
    // returns a random Float in the half-open interval start..<end
    public class func randomFloat(i: HalfOpenInterval<Float>) -> Float {
        return Random.sharedInstance.randomFloat(i)
    }
    
    // returns a random CGFloat in the half-open interval start..<end
    public class func randomCGFloat(i: HalfOpenInterval<CGFloat>) -> CGFloat {
        return Random.sharedInstance.randomCGFloat(i)
    }
    
    // returns an integer in the half-open interval start..<end
    public class func randomInt(i: HalfOpenInterval<Int>) -> Int {
        return Random.sharedInstance.randomInt(i)
    }
    
    // returns an integer in the closed interval start...end
    public class func randomInt(i: ClosedInterval<Int>) -> Int {
        return Random.sharedInstance.randomInt(i)
    }
    
    // returns a random boolean
    public class func randomBoolean() -> Bool {
        return Random.sharedInstance.randomBoolean()
    }
}
