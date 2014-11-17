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
    
    private func _assertHasEndNodes() {
        assert(tail != nil && head != nil, "Unexpected deallocation/removal of end nodes from \(self).")
    }
    
    public func addToGraph(g: Graph, tail: Node, head: Node) -> Self {
        g.addEdge(self, tail: tail, head: head)
        return self
    }
}

extension Edge : Printable {
    public var description: String { get { return "(\(eid))" } }
}

public class OpEdge<V>: Edge {
    public typealias TailValueType = V
    
    public func transferValue() {
        _assertHasEndNodes()
        if let edgeName = self.name? {
            if let t = tail as? OpNode<TailValueType> {
                if let tailValue = t.value? {
                    head[edgeName] = tailValue
                }
            }
        }
    }
    
    public override var dotAttributes : [String : String] {
        get {
            var attrs = super.dotAttributes
            if let t = tail as? OpNode<TailValueType> {
                if t.hasValue {
                    attrs["color"] = "green3"
                }
            }
            return attrs
        }
    }
}