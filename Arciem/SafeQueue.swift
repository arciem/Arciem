//
//  SafeQueue.swift
//  Arciem
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class SafeQueue<T> {
    private lazy var serializer = Serializer()
    private lazy var queue = [T]()
    
    public func add(t: T) {
        serializer.dispatch() {
            self.queue.append(t)
        }
    }
    
    public func remove() -> T {
        var t: T!
        serializer.dispatch() {
            assert(self.queue.count > 0, "Attempt to remove item from empty queue.")
            t = self.queue.removeAtIndex(0)
        }
        return t
    }
    
    public init() { }
}
