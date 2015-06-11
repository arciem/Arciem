//
//  OrderedDictionary.swift
//  Arciem
//
//  Created by Robert McNally on 2/8/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public struct OrderedDictionary<K: Hashable, V> {
    
    private typealias T = (i: Int, v: V)
    private var array = [K]()
    private var dict = [K : T]()
    
    public init() { }
    
    public subscript(k: K) -> V? {
        get {
            if let t = dict[k] {
                return t.v
            } else {
                return nil
            }
        }
        set(v) {
            if let t = dict[k] {
                if let v = v {
                    dict[k] = (t.i, v)
                } else {
                    dict[k] = nil
                    array.removeAtIndex(t.i)
                }
            } else {
                if let v = v {
                    let i = array.count
                    array.append(k)
                    dict[k] = (i, v)
                }
            }
        }
    }
    
    public subscript(i: Int) -> V? {
        get {
            let k = array[i]
            let t = dict[k]!
            return t.v
        }
        set(v) {
            let k = array[i]
            dict[k] = (i, v!)
        }
    }
}

extension OrderedDictionary: CustomStringConvertible {
    public var description: String {
        get {
            var a = [String]()
            for (i, k) in array.enumerate() {
                let t = dict[k]
                a.append("\(i): \(k): \(t!.v)")
            }
            let aa = joinStrings(", ", elements: a)
            let s = "[\(aa)]"
            return s
        }
    }
}
