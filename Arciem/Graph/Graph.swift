//
//  Graph.swift
//  Arciem
//
//  Created by Robert McNally on 1/28/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

var graphLogger = Logger(tag: "GRAPH")

public class Graph {
    public private(set) var nodes = Set<AbstractNode>()
    public private(set) var edges = Set<AbstractEdge>()
    public var root: AbstractNode?
    
    public var failure: ErrorBlock?
    public var finally: DispatchBlock?
    
    public init() {
        graphLogger?.trace("init \(typeNameOf(self))")
    }
    
    func addEdge(edge: AbstractEdge) {
        edges.add(edge)
    }
    
    func addNode(node: AbstractNode) {
        nodes.add(node)
    }
    
    public func cancel() {
        for node in nodes {
            node.canceler?.cancel()
        }
    }
    
    public func printGraph() {
        println(expandedDescription)
    }

    deinit {
        graphLogger?.trace("deinit \(self)")
    }
}

extension Graph {
    public var expandedDescription: String {
        get {
            var s = ""
            
            for node in nodes {
                s += "\n\(node)\n"
                
                for edge in node.outEdges {
                    s += "\t ➡️ \(edge)\n"
                }
                
                for edge in node.inEdges {
                    s += "\t ⬅️ \(edge)\n"
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


public prefix func •<T>(rhs:(Graph) -> Node<T>) -> (Graph, Node<T>) {
    let graph = Graph()
    let node = rhs(graph)
    graph.root = node
    return (graph, node)
}

//public prefix func •<T, A>(rhs:(Graph) -> ((A) -> Node<T>)) -> ((A) -> Node<T>) {
//    return rhs(Graph())
//}

public func →<T>(lhs: (graph: Graph, node: Node<T>), rhs: (T) -> Void) -> (Graph, Node<T>) {
    let graph = lhs.graph
    let n = newOutputNode(lhs.graph, "=", lhs.node)
        { [unowned graph] result in
            if let result = result? {
                result
                    ★ { rhs($0) }
                    † { graph.failure?(error: $0) ?? () }
            }
            graph.finally?()
    }
    return (lhs.graph, n)
}

public func †<T>(lhs: (graph: Graph, node: Node<T>), rhs: ErrorBlock) -> (Graph, Node<T>) {
    lhs.graph.failure = rhs
    return lhs
}

public func ‡<T>(lhs: (graph: Graph, node: Node<T>), rhs: DispatchBlock) -> Graph {
    lhs.graph.finally = rhs
    lhs.graph.root?.operate()
    return lhs.graph
}