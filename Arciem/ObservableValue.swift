//
//  ObservableValue.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public class ObservableValue<T> : Valuable {
    var observances = NSMutableSet()
    
    var _value: T
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
