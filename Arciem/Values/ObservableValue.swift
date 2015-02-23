//
//  ObservableValue.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class ObservableValue /*: Valuable*/ {
    typealias WeakObserverType = WeakValue<Observer>
    var observers = [WeakObserverType]()
    var _value: Any?

    var log: Logger? { get { return observerLogger } }

    // conformance to Valuable
    public var value : Any? {
        get {
            return _value
        }
        set {
            beforeSet()
            _value = newValue
            afterSet()
        }
    }
    
    public init(_ value: Any?) {
        self._value = value
        log?.trace("\(self) init")
    }
    
    deinit {
        log?.trace("\(self) deinit")
    }
    
    func beforeSet() {
        let v = value
        for observer in observers {
            (observer.value)?.willChange?(oldValue: v)
        }
    }
    
    func afterSet() {
        let v = value
        for observer in observers {
            (observer.value)?.didChange?(newValue: v)
        }
    }
    
    public func addObserver(newObserver: Observer) {
        assert(newObserver.observedValue == nil, "attempting to re-add observer")
        var updatedObservers = [WeakObserverType]()
        for weakObserver in observers {
            if let observer = weakObserver.value {
                updatedObservers.append(weakObserver)
            }
        }
        updatedObservers.append(WeakValue(newObserver))
        newObserver.observedValue = self
        observers = updatedObservers
        newObserver.didInitialize?(initialValue: value)
    }
    
    public func removeObserver(observer: Observer) {
        assert(observer.observedValue != nil, "attempting to remove non-added observer")
        assert(observer.observedValue! === self, "attempting to remove observer never added to self")
        var updatedObservers = [WeakObserverType]()
        var found = false
        for weakObserver in observers {
            if let observer = weakObserver.value {
                found = true
            } else {
                updatedObservers.append(weakObserver)
            }
        }
        observer.observedValue = nil
        observers = updatedObservers
    }
}

extension ObservableValue : Printable {
    public var description : String {
        return identifierOfObject(self)
    }
}

//public func == (🅛: ObservableValue, 🅡: Any?) {
//    return 🅛.value == 🅡
//}