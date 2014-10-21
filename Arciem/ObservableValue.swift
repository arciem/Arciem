//
//  ObservableValue.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public class ObservableValue<T> : Valuable {
    typealias ObserverType = Observer<T>
    typealias WeakObserverType = WeakValue<ObserverType>
    var observers = [WeakObserverType]()
    var _value: T

    var log: Logger? { get { return observerLogger } }

    // conformance to Valuable
    public var value : T {
        get {
            return _value
        }
        set {
            beforeSet()
            _value = newValue
            afterSet()
        }
    }
    
    public init(_ value: T) {
        self._value = value
        log?.trace("\(self) init")
    }
    
    deinit {
        log?.trace("\(self) deinit")
    }
    
    func beforeSet() {
        let v = value
        for observer in observers {
            (observer^)?.willChange?(oldValue: v)
        }
    }
    
    func afterSet() {
        let v = value
        for observer in observers {
            (observer^)?.didChange?(newValue: v)
        }
    }
    
    public func addObserver(newObserver: ObserverType) {
        assert(newObserver.observedValue == nil, "attempting to re-add observer")
        var updatedObservers = [WeakObserverType]()
        for weakObserver in observers {
            if let observer = weakObserver^ {
                updatedObservers.append(weakObserver)
            }
        }
        updatedObservers.append(WeakValue(newObserver))
        newObserver.observedValue = self
        observers = updatedObservers
        newObserver.didInitialize?(initialValue: value)
    }
    
    public func removeObserver(observer: ObserverType) {
        assert(observer.observedValue != nil, "attempting to remove non-added observer")
        assert(observer.observedValue! === self, "attempting to remove observer never added to self")
        var updatedObservers = [WeakObserverType]()
        var found = false
        for weakObserver in observers {
            if let observer = weakObserver^ {
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
        return identifierOf(self)
    }
}
