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

public typealias SerializerBlock = (Void) -> Any?

public class Serializer {
    let queue: DispatchQueue
    let queueContext: NSNumber
    
    public init(name: String) {
        self.queue = dispatch_queue_create((name as NSString).UTF8String, DISPATCH_QUEUE_SERIAL)
        self.queueContext = NSNumber.numberWithInteger(++nextQueueContext)
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
            dispatchSyncOn(queue: queue, f)
        }
    }
    
    public func dispatch(f: SerializerBlock) -> Any? {
        var result: Any?
        
        if(self.isExecutingOnMyQueue) {
            result = f()
        } else {
            dispatchSyncOn(queue: self.queue) {
                result = f()
            }
        }
        
        return result
    }
    
    public func dispatchOnMain(f: DispatchBlock) {
        dispatchSyncOnMain(f)
    }
    
    public func dispatchOnMain(f: SerializerBlock) -> Any? {
        var result: Any?
        
        dispatchSyncOnMain() {
            result = f()
        }
        
        return result
    }
}

public func testSerializer() {
    let ser = Serializer(name: "ser1")
    ser.dispatch() {
        println("1")
    }
    println("2")
}