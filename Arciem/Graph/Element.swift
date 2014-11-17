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
    internal(set) weak public var owner: Graph?
    var attrs = [String : Any]()
    
    public required init() { self.eid = _nextEID++ }
    
    func setAttrForKey(key: String, value: Any) {
        attrs[key] = value
    }
    
    func getAttrForKey(key: String) -> Any? {
        return attrs[key]
    }
    
    public subscript(key: String) -> Any? {
        get { return getAttrForKey(key) }
        set { setAttrForKey(key, value: newValue!) }
    }
    
    func _assertOwned() {
        assert(owner != nil, "\(self) must be owned.")
    }
    
    func _assertSameOwner(e: Element) {
        assert(self.owner != nil && e.owner != nil && self.owner === e.owner, "\(self) and \(e) must have the same owner.")
    }

    public var name : String? {
        get { return self["name"] as? String }
        set { self["name"] = newValue! }
    }
    
    public func setName(name: String?) -> Self {
        self.name = name
        return self
    }
    
    public var hasName : Bool {
        get { return name != nil }
    }
    
    public var dotAttributes : [String : String] {
        get {
            var attrs = [String : String]()
            let labels = dotLabels
            let labelString = join("\\n", labels)
            if labelString != "" {
                attrs["label"] = labelString
            }
            return attrs
        }
    }

    public var dotLabels : [String] {
        get {
            var labels = [String]()
            if let name = self.name? {
                labels.append(name)
            }
            return labels
        }
    }
}

extension Element : Equatable { }

public func ==(lhs: Element, rhs: Element) -> Bool {
    return lhs.eid == rhs.eid
}

extension Element : Hashable {
    public var hashValue: Int {
        get { return eid }
    }
}

// "name assign"
public func ¶=<T: Element>(inout lhs: T, rhs: String) {
    lhs.name = rhs
}

// "name extract"
public postfix func ¶<T: Element>(lhs: T) -> String? {
    return lhs.name
}
