//
//  Future.swift
//  Arciem
//
//  Created by Robert McNally on 10/24/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

var FutureLogger = Logger(tag: "FUTURE")

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
        FutureLogger?.trace("performWithInputValue: \(inputValue)")
        if let input = inputValue as? InputType {
            task?(input)
        } else {
            FutureLogger?.error("inputValue of Promise did not match outputValue of last promise")
        }
    }
    
    public func 😄(outputValue: OutputType) {
        if next != nil {
            next!.performWithInputValue(outputValue)
        } else {
            future.finally?()
        }
    }
    
    public func 😡(error: NSError) {
        future.failure?(error: error)
        future.finally?()
    }
    
    func then<Z>(promise: Promise<O, Z>) -> Promise<O, Z> {
        if var lastTask = future.promises.last? {
            lastTask.next = promise
        }
        future.promises.append(promise)
        promise.future = future
        return promise
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
    
    func then<A>(var promise: Promise<Void, A>) -> Promise<Void, A> {
        if var lastTask = promises.last? {
            lastTask.next = promise
        }
        promises.append(promise)
        promise.future = self
        return promise
    }
    
    func go() -> Future {
        if let firstTask = promises.first? {
            firstTask.performWithInputValue(Void())
        }
        promises.removeAll()
        return self
    }
}

// "new"
public prefix func • <A>(lhs: Promise<Void, A>) -> Promise<Void, A> {
    FutureLogger?.trace("•Promise<Void, A> → Promise<Void, A>")
    return Future().then(lhs)
}

// "successor"
public func → <A, B>(lhs: Promise<Void, A>, rhs: Promise<A, B>) -> Promise<A, B> {
    FutureLogger?.trace("Promise<Void, A> → Promise<A, B>")
    return lhs.then(rhs)
}

// "successor"
public func → <A, B, C>(lhs: Promise<A, B>, rhs: Promise<B, C>) -> Promise<B, C> {
    FutureLogger?.trace("Promise<A, B> → Promise<B, C>")
    return lhs.then(rhs)
}

// "successor"
public func → <A, B>(lhs: Promise<A, B>, rhs: (B) -> Void) -> Promise<B, Void> {
    FutureLogger?.trace("Promise<A, B> → (B)->Void")
    let d = Promise<B, Void>()
    d.task = { val in
        rhs(val)
        d.😄(Void())
    }
    return lhs.then(d)
}

// "successor"
public func → <A, B, C>(lhs: Promise<A, B>, rhs: (B) -> C) -> Promise<B, C> {
    FutureLogger?.trace("Promise<A, B> → (B)->C")
    let d = Promise<B, C>()
    d.task = { val in
        d.😄(rhs(val))
    }
    return lhs.then(d)
}

// "failure"
public func † <A, B>(lhs: Promise<A, B>, rhs: ErrorBlock) -> Promise<A, B> {
    FutureLogger?.trace("Promise<A, B> † ErrorBlock")
    lhs.future.failure = rhs
    return lhs
}

// "finally"
public func ‡ <A, B>(lhs: Promise<A, B>, rhs: DispatchBlock) -> Future {
    FutureLogger?.trace("Promise<A, B> ‡ DispatchBlock")
    lhs.future.finally = rhs
    return lhs.future.go()
}

public func testFuture() {
    •task1()
        → task2()
        → { (val: Int) -> Int in println("val: \(val)")
            return val }
        → task3()
        → { (val: String) in println("val: \"\(val)\"") }
        † { (err: NSError) in println("err: \(err)") }
        ‡ { println("finally") }
}

func task1() -> Promise<Void, String> {
    let d = Promise<Void, String>()
    d.task = {
        let canceler = dispatchOnQueue(d.future.taskQueue) {
            println("Task 1")
            let s = "42"
            dispatchOnQueue(d.future.callbackQueue) {
                println("Task 1 output: \"\(s)\"")
                d.😄(s)
            }
        }
    }
    return d
}

func task2() -> Promise<String, Int> {
    let d = Promise<String, Int>()
    d.task = { (str) in
        let canceler = dispatchOnQueue(d.future.taskQueue) {
            println("Task 2 input: \"\(str)\"")
            let iOpt = str.toInt()
            dispatchOnQueue(d.future.callbackQueue) {
                if let i = iOpt? {
                    println("Task 2 output: \(i)")
                    d.😄(i)
                } else {
                    d.😡(NSError("Could not convert \(str) to an int."))
                }
            }
        }
    }
    return d
}

func task3() -> Promise<Int, String> {
    let d = Promise<Int, String>()
    d.task = { (i) in
        let canceler = dispatchOnQueue(d.future.taskQueue) {
            println("Task 3 input: \(i)")
            let s = "\(i)"
            dispatchOnQueue(d.future.callbackQueue) {
                println("Task 3 output: \"\(s)\"")
                d.😄(s)
            }
        }
    }
    return d
}
