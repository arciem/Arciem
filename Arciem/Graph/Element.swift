//
//  Element.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public typealias EID = Int
var _nextEID: EID = 0

public class Element {
    public let eid: EID
    internal(set) weak public var owner: Element?
    private var attrs = [String : Any]()
    
    public required init() { self.eid = _nextEID++ }
    
    public func setAttrForKey<V>(key: String, value: V) {
        attrs[key] = value
    }
    
    public func getAttrForKey<V>(key: String) -> V? {
        return attrs[key] as? V
    }
    
    public func removeAttrForKey<V>(key: String) -> V? {
        return attrs.removeValueForKey(key) as? V
    }
    
    subscript(key: String) -> Any? {
        get { return attrs[key] }
        set { attrs[key] = newValue }
    }
}

extension Element : Equatable { }

public func ==(lhs: Element, rhs: Element) -> Bool {
    return lhs.eid == rhs.eid
}

extension Element : Hashable {
    public var hashValue: Int {
        get {
            return eid
        }
    }
}