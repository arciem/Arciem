//
//  Observer.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

var _Observer_nextID = 0
var observerLogger : Logger? = Logger(tag: "OBSERVER", enabled: true)

public class Observer {
    let id: Int
    var didChange: ((newValue: Any?) -> Void)?
    var willChange: ((oldValue: Any?) -> Void)?
    var didInitialize: ((initialValue: Any?) -> Void)?
    weak var observedValue: ObservableValue?

    var log: Logger? { get { return observerLogger } }

    public init(didChange: ((newValue: Any?) -> Void)? = nil, willChange: ((oldValue: Any?) -> Void)? = nil, didInitialize: ((initialValue: Any?) -> Void)? = nil) {
        id = _Observer_nextID++
        self.didChange = didChange
        self.willChange = willChange
        self.didInitialize = didInitialize
        log?.trace("\(self) init")
    }
    
    deinit {
        log?.trace("\(self) deinit")
    }
}

extension Observer : CustomStringConvertible {
    public var description : String {
        return "\(identifierOfObject(self)) id:\(id)"
    }
}

//extension Observer : Equatable {
//}

//public func ==<🍒>(🅛: Observer<🍒>, 🅡: Observer<🍒>) -> Bool {
//    return 🅛 == 🅡
//}

//extension Observer : Hashable {
//    public var hashValue: Int {
//        get {
//            return id
//        }
//    }
//}


//public class ObserverTestObject {
//    var s = ObservableValue<String?>(nil)
//    
//    public init(_ s: String) {
//        self.s ^= s
//        println("\(self) \(self.s^) init")
//        
//        let observer = Observer<String?>(
//            didChange: { newValue in
//                println("did change to \(newValue)")
//            },
//            willChange: { oldValue in
//                println("will change from \(oldValue)")
//            },
//            didInitialize: { initialValue in
//                println("initialized with value \(initialValue)")
//            })
//        
//        self.s.addObserver(observer)
//        
//        t()
//        self.s ^= "A000"
//    }
//    
//    func t() {
//        s ^= "A1"
//    }
//    
//    deinit {
//        println("\(self) \(s^) deinit")
//    }
//}
//
//public func testObserver() {
//    var obj: ObserverTestObject! = ObserverTestObject("A")
//
//    var observer = Observer<String?>(
//        didChange: { newValue in
//            println("s did change to \(newValue)")
//        },
//        willChange: { oldValue in
//            println("s will change from \(oldValue)")
//        },
//        didInitialize: { initialValue in
//            println("s initialized with value \(initialValue)")
//        })
//    obj.s.addObserver(observer)
//    
//    obj.s ^= "A2"
//    obj.s ^= "A3"
//    obj = nil
//    println("done")
//}
