//
//  Random.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation
import CoreGraphics

private var _instance = Random()

public class Random {
    let m: UInt64 = 1 << 32
    
    class var sharedInstance: Random {
        get {
            return _instance
        }
    }
    
    public func cryptoRandom() -> Int32 {
        var a: UnsafeMutablePointer<Int32>! = .alloc(1)
        SecRandomCopyBytes(kSecRandomDefault, 4, UnsafeMutablePointer<UInt8>(a))
        let n = a.memory
        a.dealloc(1)
        return n
    }

    // returns a random Int32 in the half-open interval 0..<(2**32)
    public func random() -> UInt32 {
        return arc4random()
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
        return Math.denormalize(randomDouble(), i.start, i.end)
    }
    
    // returns a random Float in the half-open interval start..<end
    public func randomFloat(i: HalfOpenInterval<Float>) -> Float {
        return Math.denormalize(randomFloat(), i.start, i.end)
    }
    
    // returns a random CGFloat in the half-open interval start..<end
    public func randomCGFloat(i: HalfOpenInterval<CGFloat>) -> CGFloat {
        return Math.denormalize(randomCGFloat(), i.start, i.end)
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
