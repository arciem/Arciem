//
//  Edge.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Edge : Element {
    weak internal(set) public var tail: Node! = nil
    weak internal(set) public var head: Node! = nil
    
    public func transferValue() {
        _assertHasEndNodes()
        if let edgeName = self.name? {
            if let tailValue = tail.value? {
                head[edgeName] = tailValue
            }
        }
    }
    
    private func _assertHasEndNodes() {
        assert(tail != nil && head != nil, "Unexpected deallocation/removal of end nodes from \(self).")
    }
}

extension Edge : Printable {
    public var description: String { get { return "(\(eid))" } }
}
