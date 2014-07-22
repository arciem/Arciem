//
//  Observer.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation



public class Observer<T> {
    var id: Int?
    var didChange: Optional <(newValue: T) -> Void>
    var willChange: Optional <(oldValue: T) -> Void>
    var didInitialize: Optional <(initialValue: T) -> Void>
    
    public init(didChange: Optional <(newValue: T) -> Void>, willChange: Optional <(oldValue: T) -> Void>, didInitialize: Optional <(initialValue: T) -> Void> ) {
        self.didChange = didChange
        self.willChange = willChange
        self.didInitialize = didInitialize
        println("\(self) init")
    }
    
    deinit {
        println("\(self) deinit")
    }
}


var _Observer_nextID = 0

public class Observable<T> {
    var observances = NSMutableSet()

    // KLUDGE: Workaround for compiler crash
    
    //    var _value: T
    //    var value : T {
    //    get {
    //        return _value
    //    }
    //    set {
    //        beforeSet()
    //        _value = newValue
    //        afterSet()
    //    }
    //    }

    var _value: [T]
    public var value : T {
    get {
        return _value[0]
    }
    set {
        beforeSet()
        _value = [newValue]
        afterSet()
    }
    }
    
//    func __conversion() -> T? { return value }
    
    public init(_ value: T) {
        self._value = [value]
        println("\(self) init")
    }
    
    deinit {
        println("\(self) deinit")
    }

    func beforeSet() {
        let v = value
        for observance : AnyObject in observances {
            (observance as Observer<T>).willChange?(oldValue: v)
        }
    }
    
    func afterSet() {
        let v = value
        for observance : AnyObject in observances {
            (observance as Observer<T>).didChange?(newValue: v)
        }
    }

    public func addObservance(observance: Observer<T>) {
        assert(observance.id == nil, "attempting to re-add observance")
        observance.id = _Observer_nextID++
        observances.addObject(observance)
        observance.didInitialize?(initialValue: value)
    }
    
    public func removeObservance(observance: Observer<T>) {
        assert(observance.id != nil, "attempting to remove non-added observance")
        if observances.containsObject(observance) {
            observance.id = nil
            observances.removeObject(observance)
        } else {
            fatalError("attempting to remove observance not on observer")
        }
    }
}

operator infix =^ { }
operator postfix ^ { }

@infix @assignment public func =^ <T> (inout left: Observable<T>, right: T) {
    left.value = right
}

@infix @assignment public func =^ <T> (inout left: T, right: Observable<T>) {
    left = right.value
}

@postfix public func ^ <T> (left: Observable<T>) -> T {
    return left.value
}

public class ObserverTestObject {
    var s = Observable<String?>(nil)
    
    public init(_ s: String) {
        self.s =^ s
        println("\(self) \(self.s.value) init")
        
        let observance = Observer<String?>(
            didChange: { newValue in
                println("did change to \(newValue)")
            },
            willChange: { oldValue in
                println("will change from \(oldValue)")
            },
            didInitialize: { initialValue in
                println("initialized with value \(initialValue)")
            })
        
        self.s.addObservance(observance)
        
        t()
        self.s =^ "A000"
    }
    
    func t() {
        s =^ "A1"
    }
    
    deinit {
        println("\(self) \(s.value) deinit")
    }
}

public func testObserver() {
    var obj: ObserverTestObject! = ObserverTestObject("A")

    var observance = Observer<String?>(
        didChange: { newValue in
            println("s did change to \(newValue)")
        },
        willChange: { oldValue in
            println("s will change from \(oldValue)")
        },
        didInitialize: { initialValue in
            println("s initialized with value \(initialValue)")
        })
    obj.s.addObservance(observance)
    
    obj.s =^ "A2"
    obj.s =^ "A3"
    obj = nil
    println("done")
}
