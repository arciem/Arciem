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
    
    public var value : Any? {
        get { return self["value"] }
        set { self["value"] = newValue! }
    }
    
    public func setValue(value: Any?) -> Self {
        self.value = value
        return self
    }
    
    public var hasValue : Bool {
        get { return value != nil }
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

extension Element {
    public var dotLabel : String? {
        get {
            var label: String?
            var labelFields = [(String, Any)]()
//            labelFields.append(("id", eid))
            if let name = self.name? {
                labelFields.append(("name", name))
            }
            if let value = self.value? {
                labelFields.append(("value", value))
            }
            let labelFieldStrings: [String] = map(labelFields) { (key:String, value:Any) in
                var s = ""
                if key != "name" {
                    s += "\(key):"
                }
                s += "\(value)"
                return s
            }
            let f = join("\\n", labelFieldStrings)
            if f != "" {
                label = f
            }
            return label
        }
    }
    
    public var dotAttributes : [String : String] {
        get {
            var attrs = [String : String]()
            attrs["label"] = dotLabel
            return attrs
        }
    }
}

// "name assign"
public func ¶=<E: Element>(inout lhs: E, rhs: String) {
    lhs.name = rhs
}

// "name extract"
public postfix func ¶(lhs: Element) -> String? {
    return lhs.name
}

// "value assign"
public func ^=<E: Element, T>(inout lhs: E, rhs: T) {
    lhs.value = rhs
}

// "value extract"
public postfix func ^(lhs: Element) -> Any? {
    return lhs.value
}
