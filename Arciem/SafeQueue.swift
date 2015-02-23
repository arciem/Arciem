//
//  SafeQueue.swift
//  Arciem
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class SafeQueue<🍒> {
    private lazy var serializer = Serializer()
    private lazy var queue = [🍒]()
    
    public func add(t: 🍒) {
        serializer.dispatch() {
            self.queue.append(t)
        }
    }
    
    public func remove() -> 🍒 {
        var t: 🍒!
        serializer.dispatch() {
            assert(self.queue.count > 0, "Attempt to remove item from empty queue.")
            t = self.queue.removeAtIndex(0)
        }
        return t
    }
    
    public var count: Int {
        return serializer.dispatchWithReturn { self.queue.count }
    }

    public var isEmpty: Bool { return count == 0 }
    
    public init() { }
}
