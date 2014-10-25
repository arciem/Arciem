//
//  Future.swift
//  Arciem
//
//  Created by Robert McNally on 10/24/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

protocol DeferredProtocol {
    func performWithInputValue(inputValue: Any)
    var next: DeferredProtocol? { set get }
}

class Deferred<I, O> : DeferredProtocol {
    typealias InputType = I
    typealias OutputType = O
    typealias TaskType = (InputType) -> Void
    typealias SuccessType = (OutputType) -> Void
    typealias FailureType = (NSError) -> Void
    var task: TaskType?
    var inputValue: InputType?
    var outputValue: OutputType?
    var error: NSError?
    var next: DeferredProtocol?
    
    func performWithInputValue(inputValue: Any) {
        task?(inputValue as InputType)
    }
    
    func success(outputValue: OutputType) {
        next?.performWithInputValue(outputValue)
    }
    
    func failure(error: NSError) {
        self.error = error
    }
}

class Future {
    var tasks = [DeferredProtocol]()
    
    func then(task: DeferredProtocol) -> Future {
        if var lastTask = tasks.last? {
            lastTask.next = task
        }
        tasks.append(task)
        return self
    }
    
    func go() -> Future {
        tasks[0].performWithInputValue(())
        return self
    }
}

public func testFuture() {
    let f = Future().then(task1()).then(task2()).go()
}

func task1() -> Deferred<(), String> {
    let d = Deferred<(), String>()
    d.task = { () in
        dispatchOnBackground() {
            println("Task 1")
            let s = "55"
            dispatchOnMain() {
                println("Task 1 output: \(s)")
                d.success(s)
            }
        }
    }
    return d
}

func task2() -> Deferred<String, Int> {
    let d = Deferred<String, Int>()
    d.task = { (str) in
        dispatchOnBackground() {
            println("Task 2 input: \(str)")
            let iOpt = str.toInt()
            dispatchOnMain() {
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

func task3() -> Deferred<Int, String> {
    let d = Deferred<Int, String>()
    d.task = { (i) in
        dispatchOnBackground() {
            let s = "\(i)"
            dispatchOnMain() {
                d.success(s)
            }
        }
    }
    return d
}

//class Promise {
//    var tasks: [DispatchBlock]
//    
//    init(task: DispatchBlock) {
//        tasks = [task]
//    }
//}
//
//enum Future<T> {
//    case NotYet(Promise)
//    case Some(T)
//    case Error(NSError)
//    
//    
//    init(_ task: DispatchBlock) {
//        let promise = Promise(task)
//        self = .NotYet(promise)
//    }
//}

//class Future<T> {
////    var task: (String) -> Void
////    var next: Future? = nil
//    var value: T? = nil
//    typealias TaskType = (T) -> Void
//    var tasks = [TaskType]()
//    
//    func then(f: TaskType) -> Future {
//        tasks.append(f)
//        return self
//    }
//    
//    func then(f: () -> ()) -> Future {
//        tasks.append({ _ in
//            f()
//        })
//        return self
//    }
////
////    init(_ task: (String) -> Void) {
////        self.task = task
////    }
////    
////    func then(next: Future) -> Future {
////        self.next = next
////        return next
////    }
////    
//    func resolve(value: T) {
//        self.value = value
//        for task in tasks {
//            task(value)
//        }
//    }
//}
//
//func task1() -> Future<String> {
//    let f = Future<String>()
//    
//    dispatchOnBackground() {
//        println("Task 1")
//        dispatchOnMain() {
//            f.resolve("Task 1 value")
//        }
//    }
//    
//    return f
//}
//
//func task2() -> Future<Int> {
//    let f = Future<Int>()
//    
//    dispatchOnMain() {
//        println("Task 2")
//        dispatchOnMain() {
//            f.resolve(55)
//        }
//    }
//    
//    return f
//}
//
//public func testFuture() {
//    let future = task1().then({ f in
//        println("task1 string: \(f)")
//    }).then({
//        println("Another then.")
//    })
//    
//    //        .then(
//    //        task2()
//    //        ).then({
//    //            println("Task 3")
//    //        })
//}
////    let future = Future({ () -> String in
////        return "Hello"
////    })
