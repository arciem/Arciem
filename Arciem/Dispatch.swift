//
//  Dispatch.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

// A Canceler is returned by functions in this file that either execute a block after a delay, or execute a block at intervals. If the <canceled> variable is set to true, the block will never be executed, or the calling of the block at intervals will stop.
public class Canceler {
    public var canceled = false
}

// Convenience types for symmetry with Swift naming conventions
public typealias DispatchBlock = dispatch_block_t
public typealias DispatchQueue = dispatch_queue_t

// A block that takes a Canceler. The block will not be called again if it sets the <canceled> variable of the Canceler to true.
public typealias CancelableBlock = (canceler: Canceler) -> Void

// This variable returns the GCD main queue, which is the queue associated with the main thread. All calls to CocoaTouch UI APIs should happen on this thread.
public var mainQueue: DispatchQueue {
get {
    return dispatch_get_main_queue()
}
}

// This variable returns a concurrent background queue, able to handle more than one concurrent background task.
public var backgroundQueue: DispatchQueue {
get {
    return dispatch_queue_create("background", DISPATCH_QUEUE_CONCURRENT)
}
}

// A utility function to convert a time since now as a Double (NSTimeInterval) representing a number of seconds to a dispatch_time_t used by GCD.
public func dispatchTimeSinceNow(offsetInSeconds: NSTimeInterval) -> dispatch_time_t {
    return dispatch_time(DISPATCH_TIME_NOW, Int64(offsetInSeconds * Double(NSEC_PER_SEC)))
}

// Dispatch a block synchronously on the given queue. Blocks dispatched synchronously block the current thread until they complete.
//
// Example:
//   println("1")
//   dispatchSyncOn(queue: backgroundQueue) {
//     println("2")
//   }
//   println("3")
//
// Since the dispatch is synchronous, this example is guaranteed to print:
// 1
// 2
// 3
public func dispatchSyncOn(#queue: DispatchQueue, f: DispatchBlock) {
    dispatch_sync(queue, f)
}

// Dispatch a block synchronously on the main queue. This is useful when you're already executing a block on a background queue and you want to ensure the next operation happens on the main queue before the code of your background block proceeds.
public func dispatchSyncOnMain(f: DispatchBlock) {
    dispatchSyncOn(queue: mainQueue, f)
}

// Dispatch a block asynchronously on the give queue. This method returns immediately. Blocks dispatched asynchronously will be executed at some time in the future.
public func dispatchOn(#queue: DispatchQueue, f: DispatchBlock) {
    dispatch_async(queue, f)
}

// Dispatch a block asynchronously on the main queue.
public func dispatchOnMain(f: DispatchBlock) {
    dispatchOn(queue: mainQueue, f)
}

// Dispatch a block asynchronously on the background queue.
public func dispatchOnBackground(f: DispatchBlock) {
    dispatchOn(queue: backgroundQueue, f)
}

func _dispatchOn(#queue: DispatchQueue, afterDelay delay: NSTimeInterval, c: Canceler, f: CancelableBlock) {
    dispatch_after(dispatchTimeSinceNow(delay), queue) {
        f(canceler: c)
    }
}

// After the given delay, dispatch a block asynchronously on the given queue. Returns a Canceler object that, if its <canceled> attribute is true when the dispatch time arrives, the block will not be executed.
public func dispatchOn(#queue: DispatchQueue, afterDelay delay: NSTimeInterval, f: DispatchBlock) -> Canceler {
    let canceler = Canceler()
    _dispatchOn(queue: queue, afterDelay: delay, canceler) { canceler in
        if !canceler.canceled {
            f()
        }
    }
    return canceler
}

// After the given delay, dispatch a block asynchronously on the main queue. Returns a Canceler object that, if its <canceled> attribute is true when the dispatch time arrives, the block will not be executed.
public func dispatchOnMain(afterDelay delay: NSTimeInterval, f: DispatchBlock) -> Canceler {
    return dispatchOn(queue: mainQueue, afterDelay: delay, f)
}

// After the given delay, dispatch a block asynchronously on the background queue. Returns a Canceler object that, if its <canceled> attribute is true when the dispatch time arrives, the block will not be executed.
public func dispatchOnBackground(afterDelay delay: NSTimeInterval, f: DispatchBlock) -> Canceler {
    return dispatchOn(queue: backgroundQueue, afterDelay: delay, f)
}

func _dispatchRepeatedOn(#queue: DispatchQueue, atInterval interval: NSTimeInterval, canceler: Canceler, f:CancelableBlock) {
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