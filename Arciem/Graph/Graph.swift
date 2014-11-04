//
//  Graph.swift
//  Arciem
//
//  Created by Robert McNally on 11/3/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Graph : Element {
    public private(set) var nodes = NodeSet()
    public private(set) var edges = EdgeSet()
    
    public func addNode() -> Node {
        var node = Node()
        _setMine(node)
        _addNode(node)
        return node
    }
    
    public func removeNode(node: Node) {
        removeEdges(node)
        _setUnowned(node)
        _removeNode(node)
    }
    
    public func addEdge(tail: Node, head: Node) -> Edge {
        var edge = Edge()
        _setMine(edge)
        _addEdge(edge)
        _setEdge(edge, tail: tail, head: head)
        return edge
    }
    
    public func removeEdge(edge: Edge) {
        _setUnowned(edge)
        _removeEdge(edge)
        _unsetEdge(edge)
    }
    
    public func moveEdge(edge: Edge, tail: Node, head: Node) {
        _assertMine(edge)
        if tail !== edge.tail {
            _assertMine(tail)
            _unsetTail(edge: edge)
            _setTail(edge: edge, tail: tail)
        }
        if head !== edge.head {
            _assertMine(head)
            _unsetHead(edge: edge)
            _setHead(edge: edge, head: tail)
        }
    }
    
    public func removeInEdges(node: Node) {
        for edge in node.inEdges {
            _removeEdge(edge)
        }
    }
    
    public func removeOutEdges(node: Node) {
        for edge in node.outEdges {
            _removeEdge(edge)
        }
    }
    
    public func removeEdges(node: Node) {
        removeInEdges(node)
        removeOutEdges(node)
    }
    
    private func _assertMine(element: Element) {
        assert(element.owner === self, "\(element) must belong to \(self).")
    }
    
    private func _assertUnowned(element: Element) {
        assert(element.owner == nil, "\(element) must not belong to \(element.owner!).")
    }
    
    private func _setMine(element: Element) {
        _assertUnowned(element)
        element.owner = self
    }
    
    private func _setUnowned(element: Element) {
        _assertMine(element)
        element.owner = nil
    }
    
    private func _addNode(node: Node) { nodes.add(node) }
    private func _removeNode(node: Node) { nodes.remove(node) }
    private func _addEdge(edge: Edge) { edges.add(edge) }
    private func _removeEdge(edge: Edge) { edges.remove(edge) }
    
    private func _setTail(#edge: Edge, tail: Node) {
        edge.tail = tail
        tail.outEdges.add(edge)
    }
    
    private func _setHead(#edge: Edge, head: Node) {
        edge.head = head
        head.inEdges.add(edge)
    }
    
    private func _setEdge(edge: Edge, tail: Node, head: Node) {
        _setTail(edge: edge, tail: tail)
        _setHead(edge: edge, head: head)
    }
    
    private func _unsetTail(#edge: Edge) {
        edge.tail.outEdges.remove(edge)
        edge.tail = nil
    }
    
    private func _unsetHead(#edge: Edge) {
        edge.head.inEdges.remove(edge)
        edge.head = nil
    }
    
    private func _unsetEdge(edge: Edge) {
        _unsetTail(edge: edge)
        _unsetHead(edge: edge)
    }
}

extension Graph : Printable {
    public var description: String {
        get { return "<Graph \(eid)>" }
    }
}
