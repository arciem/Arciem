//
//  Observer.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation


var _Observer_nextID = 0

public class Observer<T> {
    var id: Int?
    var didChange: ((newValue: T) -> Void)?
    var willChange: ((oldValue: T) -> Void)?
    var didInitialize: ((initialValue: T) -> Void)?
    
    public init(didChange: ((newValue: T) -> Void)?, willChange: ((oldValue: T) -> Void)?, didInitialize: ((initialValue: T) -> Void)?) {
        self.didChange = didChange
        self.willChange = willChange
        self.didInitialize = didInitialize
        println("\(self) init")
    }
    
    deinit {
        println("\(self) deinit")
    }
}


public class ObserverTestObject {
    var s = ObservableValue<String?>(nil)
    
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
