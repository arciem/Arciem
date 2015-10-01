//
//  Serializer.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

let serializerKey:String = "Serializer"
var nextQueueContext: Int = 1

public class Serializer {
    let queue: DispatchQueue
    let queueContext: NSNumber
    
    public init(name: NSString? = nil) {
        self.queue = dispatch_queue_create(name?.UTF8String ?? nil, DISPATCH_QUEUE_SERIAL)
        self.queueContext = NSNumber(integer: ++nextQueueContext)
        dispatch_queue_set_specific_glue(self.queue, serializerKey, self.queueContext)
    }

    var isExecutingOnMyQueue: Bool {
    get {
        let context = dispatch_get_specific_glue(serializerKey)
        return context === self.queueContext
    }
    }
    
    public func dispatch(f: DispatchBlock) {
        if(isExecutingOnMyQueue) {
            f()
        } else {
            dispatchSyncOnQueue(queue, f)
        }
    }
    
    public func dispatchWithReturn<🍒>(f: () -> 🍒) -> 🍒 {
        var result: 🍒!
        
        if(self.isExecutingOnMyQueue) {
            result = f()
        } else {
            dispatchSyncOnQueue(self.queue) {
                result = f()
            }
        }
        
        return result!
    }
    
    public func dispatchOnMain(f: DispatchBlock) {
        dispatchSyncOnMain(f)
    }
    
    public func dispatchOnMainWithReturn<🍒>(f: () -> 🍒) -> 🍒 {
        var result: 🍒!
        
        dispatchSyncOnMain() {
            result = f()
        }
        
        return result!
    }
}

public func testSerializer() {
    let ser = Serializer(name: "ser1")
    ser.dispatch() {
        print("1")
    }
    print("2")
}