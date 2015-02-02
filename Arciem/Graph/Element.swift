//
//  Element.swift
//  Arciem
//
//  Created by Robert McNally on 1/28/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//


public typealias EID = Int
var _nextEID: EID = 0

public class Element {
    public let eid: EID
    public weak var graph: Graph!
    
    public init(_ graph: Graph) {
        eid = _nextEID++
        self.graph = graph
        graphLogger?.trace("init \(typeNameOf(self)) eid:\(eid)")
    }
    
    public var name: String?
    public func setName(name: String?) -> Self {
        self.name = name
        return self
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

    // Declarations in extensions cannot override yet
    public var dotLabels : [String] {
        get {
            var labels = [String]()
            if let name = self.name? {
                labels.append(name)
            }
            return labels
        }
    }
    
    deinit {
        graphLogger?.trace("deinit \(typeNameOf(self)) eid:\(eid)")
    }
}


extension Element : Hashable {
    public var hashValue: Int {
        get { return eid }
    }
}

public func ==(lhs: Element, rhs: Element) -> Bool {
    return lhs.eid == rhs.eid
}
