//
//  Graph.swift
//  Arciem
//
//  Created by Robert McNally on 11/3/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Graph {
    public var nodes = Set<Node>()
    public var edges = Set<Edge>()
    public var root: Node? = nil
    public var name: String? = nil
    var error: NSError? = nil
    
    public func addNode<N: Node>(node: N) -> N {
        _setMine(node)
        _addNode(node)
        return node
    }
    
    public func removeNode(node: Node) {
        _assertMine(node)
        removeEdges(node)
        _setUnowned(node)
        _removeNode(node)
    }
    
    public func addEdge(edge: Edge, tail: Node, head: Node) {
        _assertMine(tail)
        _assertMine(head)
        _setMine(edge)
        _addEdge(edge)
        _setEdge(edge, tail: tail, head: head)
    }

    public func removeEdge(edge: Edge) {
        _assertMine(edge)
        _setUnowned(edge)
        _removeEdge(edge)
        _unsetEdge(edge)
    }
    
    public func moveEdge(edge: Edge, tail: Node, head: Node) {
        _assertMine(edge)
        _assertMine(tail)
        _assertMine(head)
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
        _assertMine(node)
        for edge in node.inEdges {
            _removeEdge(edge)
        }
    }
    
    public func removeOutEdges(node: Node) {
        _assertMine(node)
        for edge in node.outEdges {
            _removeEdge(edge)
        }
    }
    
    public func removeEdges(node: Node) {
        _assertMine(node)
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
        get {
            var s = ""
            if let d = self.name? {
                s = " \"\(d)\""
            }
            return s
        }
    }
}

extension Graph {
    public var expandedDescription: String {
        get {
            var s = ""
            
            for node in nodes {
                s += "\n\(node)\n"
                
                for edge in node.outEdges {
                    s += "\t ➡️ \(edge) ➡️ \(edge.head)\n"
                }
                
                for edge in node.inEdges {
                    s += "\t ⬅️ \(edge) ⬅️ \(edge.tail)\n"
                }
            }
            
            return s
        }
    }
    
    public class func stringFromDotAttributes(attrs: [String : String]) -> String {
        var strings = [String]()
        for (key, value) in attrs {
            strings.append("\(key)=\"\(value)\"")
        }
        let s = join(",", strings)
        return "[\(s)]"
    }
    
    public var dotDescription: String {
        get {
            var lines = [String]()
            lines.append("digraph G {")
            
            for node in nodes {
                var s = "\t\(node.eid)"
                var attrs = node.dotAttributes
                var attrsStr = self.dynamicType.stringFromDotAttributes(attrs)
                s += " \(attrsStr);"
                lines.append(s)
                for edge in node.outEdges {
                    var s = "\t\(edge.tail.eid) -> \(edge.head.eid)"
                    var attrs = edge.dotAttributes
                    var attrsStr = self.dynamicType.stringFromDotAttributes(attrs)
                    s += " \(attrsStr);"
                    lines.append(s)
                }
            }
            
            lines.append("}")
            return join("\n", lines)
        }
    }
    
    public func writeDotDescriptionToFilename(filename: String) {
        if let url = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil)? {
            let data = dotDescription.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            let path = "\(filename).dot"
            let url2 = url.URLByAppendingPathComponent(path)
            let result = data.writeToURL(url2, atomically: false)
            println("path: \(url2.path!)")
        }
    }
}

// "new"
public prefix func •<V>(rhs: Graph) -> OpNode<V> {
    let node = OpNode<V>()
    rhs.addNode(node)
    return node
}

// "successor"
public func →<V1,V2>(lhs: OpNode<V1>, rhs: OpNode<V2>) -> OpEdge<V1> {
    return lhs.addEdgeTo(rhs)
}
