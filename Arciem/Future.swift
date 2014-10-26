//
//  Future.swift
//  Arciem
//
//  Created by Robert McNally on 10/24/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public protocol PromiseP {
    func performWithInputValue(inputValue: Any)
    var next: PromiseP? { set get }
    var future: Future! { set get }
}

public class Promise<I, O> : PromiseP {
    typealias InputType = I
    typealias OutputType = O
    typealias TaskType = (InputType) -> Void
    public var task: TaskType?
    public var next: PromiseP?
    public var future: Future!
    
    public init() {
        
    }
    
    public func performWithInputValue(inputValue: Any) {
        if let input = inputValue as? InputType {
            task?(input)
        } else {
            failure(NSError("Promise input type did not match previous promise output type."))
        }
    }
    
    public func success(outputValue: OutputType) {
        if next != nil {
            next!.performWithInputValue(outputValue)
        } else {
            future.finally?()
        }
    }
    
    public func failure(error: NSError) {
        future.failure?(error: error)
        future.finally?()
    }
}

public class Future {
    var promises = [PromiseP]()
    var failure: ErrorBlock?
    var finally: DispatchBlock?
    public private(set) var taskQueue: DispatchQueue
    public private(set) var callbackQueue: DispatchQueue
    
    init(taskQueue: DispatchQueue = backgroundQueue, callbackQueue: DispatchQueue = mainQueue) {
        self.taskQueue = taskQueue
        self.callbackQueue = callbackQueue
    }
    
    func then(var promise: PromiseP) -> Future {
        if var lastTask = promises.last? {
            lastTask.next = promise
        }
        promises.append(promise)
        promise.future = self
        return self
    }
    
    func go() -> Future {
        if let firstTask = promises.first? {
            firstTask.performWithInputValue(())
        }
        promises.removeAll()
        return self
    }
}

infix operator → { associativity left precedence 80 }
infix operator † { associativity left precedence 80 }
infix operator ‡ { associativity left precedence 80 }

public func → <A, B, C>(lhs: Promise<A, B>, rhs: Promise<B, C>) -> Future {
    return Future().then(lhs).then(rhs)
}

public func → (lhs: Future, rhs: PromiseP) -> Future {
    return lhs.then(rhs)
}

public func → <T>(lhs: Future, rhs: (T) -> Void) -> Future {
    let d = Promise<T, T>()
    d.task = { (val: T) in
        rhs(val)
        d.success(val)
    }
    return lhs.then(d)
}

public func → <T, R>(lhs: Future, rhs: (T) -> R) -> Future {
    let d = Promise<T, R>()
    d.task = { (val: T) in
        d.success(rhs(val))
    }
    return lhs.then(d)
}

public func → <T>(lhs: PromiseP, rhs: (T) -> Void) -> Future {
    return Future().then(lhs) → rhs
}

public func → <T, R>(lhs: PromiseP, rhs: (T) -> R) -> Future {
    return Future().then(lhs) → rhs
}

public func † (lhs: Future, rhs: ErrorBlock) -> Future {
    lhs.failure = rhs
    return lhs
}

public func ‡ (lhs: Future, rhs: DispatchBlock) -> Future {
    lhs.finally = rhs
    return lhs.go()
}

public func testFuture() {
    let f = task1()
        → task2()
        → { (val: Int) in println("val: \(val)") }
        → task3()
        → { (val: String) in println("val: \"\(val)\"") }
        † { (err: NSError) in println("err: \(err)") }
        ‡ { println("finally") }
}

func task1() -> Promise<(), String> {
    let d = Promise<(), String>()
    d.task = { () in
        dispatchOn(queue: d.future.taskQueue) {
            println("Task 1")
            let s = "42"
            dispatchOn(queue: d.future.callbackQueue) {
                println("Task 1 output: \"\(s)\"")
                d.success(s)
            }
        }
    }
    return d
}

func task2() -> Promise<String, Int> {
    let d = Promise<String, Int>()
    d.task = { (str) in
        dispatchOn(queue: d.future.taskQueue) {
            println("Task 2 input: \"\(str)\"")
            let iOpt = str.toInt()
            dispatchOn(queue: d.future.callbackQueue) {
                if let i = iOpt? {
                    println("Task 2 output: \(i)")
                    d.success(i)
                } else {
                    d.failure(NSError("Could not convert \(str) to an int."))
                }
            }
        }
    }
    return d
}

func task3() -> Promise<Int, String> {
    let d = Promise<Int, String>()
    d.task = { (i) in
        dispatchOn(queue: d.future.taskQueue) {
            println("Task 3 input: \(i)")
            let s = "\(i)"
            dispatchOn(queue: d.future.callbackQueue) {
                println("Task 3 output: \"\(s)\"")
                d.success(s)
            }
        }
    }
    return d
}
