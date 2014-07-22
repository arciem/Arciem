//
//  Dispatch.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public class Canceler {
    var canceled = false
}

public typealias DispatchBlock = dispatch_block_t
public typealias CancelableBlock = (canceler: Canceler) -> Void
public typealias DispatchQueue = dispatch_queue_t

public var mainQueue: DispatchQueue {
get {
    return dispatch_get_main_queue()
}
}

public var backgroundQueue: DispatchQueue {
get {
    return dispatch_queue_create("background", DISPATCH_QUEUE_CONCURRENT)
}
}

public func dispatchTimeSinceNow(offsetInSeconds: NSTimeInterval) -> dispatch_time_t {
    return dispatch_time(DISPATCH_TIME_NOW, Int64(offsetInSeconds * Double(NSEC_PER_SEC)))
}

public func dispatchSyncOn(#queue: DispatchQueue, f: DispatchBlock) {
    dispatch_sync(queue, f)
}

public func dispatchSyncOnMain(f: DispatchBlock) {
    dispatchSyncOn(queue: mainQueue, f)
}

public func dispatchOn(#queue: DispatchQueue, f: DispatchBlock) {
    dispatch_async(queue, f)
}

public func dispatchOnMain(f: DispatchBlock) {
    dispatchOn(queue: mainQueue, f)
}

public func dispatchOnBackground(f: DispatchBlock) {
    dispatchOn(queue: backgroundQueue, f)
}

public func _dispatchOn(#queue: DispatchQueue, afterDelay delay: NSTimeInterval, c: Canceler, f: CancelableBlock) {
    dispatch_after(dispatchTimeSinceNow(delay), queue) {
        f(canceler: c)
    }
}

public func dispatchOn(#queue: DispatchQueue, afterDelay delay: NSTimeInterval, f: DispatchBlock) -> Canceler {
    let canceler = Canceler()
    let b:CancelableBlock = { canceler in
        if !canceler.canceled {
            f()
        }
    }
    _dispatchOn(queue: queue, afterDelay: delay, canceler, b)
    return canceler
}

public func dispatchOnMain(afterDelay delay: NSTimeInterval, f: DispatchBlock) -> Canceler {
    return dispatchOn(queue: mainQueue, afterDelay: delay, f)
}

public func dispatchOnBackground(afterDelay delay: NSTimeInterval, f: DispatchBlock) -> Canceler {
    return dispatchOn(queue: backgroundQueue, afterDelay: delay, f)
}

public func _dispatchRepeatedOn(#queue: DispatchQueue, atInterval interval: NSTimeInterval, canceler: Canceler, f:CancelableBlock) {
    _dispatchOn(queue: queue, afterDelay: interval, canceler) { canceler in
        if !canceler.canceled {
            f(canceler: canceler)
        }
        if !canceler.canceled {
            _dispatchRepeatedOn(queue: queue, atInterval: interval, canceler, f)
        }
    }
}

public func dispatchRepeatedOn(#queue: DispatchQueue, atInterval interval: NSTimeInterval, f:CancelableBlock) -> Canceler {
    let canceler = Canceler()
    _dispatchRepeatedOn(queue: queue, atInterval: interval, canceler, f)
    return canceler
}

public func dispatchRepeatedOnMain(atInterval interval: NSTimeInterval, f:CancelableBlock) -> Canceler {
    return dispatchRepeatedOn(queue: mainQueue, atInterval: interval, f)
}

public func dispatchRepeatedOnBackground(atInterval interval: NSTimeInterval, f:CancelableBlock) -> Canceler {
    return dispatchRepeatedOn(queue: backgroundQueue, atInterval: interval, f)
}