//
//  Stopwatch.swift
//  Arciem
//
//  Created by Robert McNally on 11/14/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Stopwatch {
    public var startTime: NSTimeInterval = 0
    
    public init() {
        reset()
    }

    public func reset() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    public var elapsed: NSTimeInterval { get {
            return NSDate.timeIntervalSinceReferenceDate() - startTime
    } }
}