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
        edges.insert(edge)
    }
    
    func addNode(node: AbstractNode) {
        nodes.insert(node)
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
        let s = joinStrings(",", strings)
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
            return joinStrings("\n", lines)
        }
    }

    public func writeDotDescriptionToFilename(filename: String) {
        if let url = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil) {
            let data = dotDescription.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            let path = "\(filename).dot"
            let url2 = url.URLByAppendingPathComponent(path)
            let result = data.writeToURL(url2, atomically: false)
            println("path: \(url2.path!)")
        }
    }
}


public prefix func •<🍒>(🅡:(Graph) -> Node<🍒>) -> (Graph, Node<🍒>) {
    let graph = Graph()
    let node = 🅡(graph)
    graph.root = node
    return (graph, node)
}

//public prefix func •<🍒, A>(🅡:(Graph) -> ((A) -> Node<🍒>)) -> ((A) -> Node<🍒>) {
//    return 🅡(Graph())
//}

public func →<🍒>(🅛: (graph: Graph, node: Node<🍒>), 🅡: (🍒) -> Void) -> (Graph, Node<🍒>) {
    let graph = 🅛.graph
    let n = newOutputNode(🅛.graph, "=", 🅛.node)
        { [unowned graph] result in
            if let result = result {
                result
                    ★ { 🅡($0) }
                    † { graph.failure?(🚫: $0) ?? () }
            }
            graph.finally?()
    }
    return (🅛.graph, n)
}

public func †<🍒>(🅛: (graph: Graph, node: Node<🍒>), 🅡: ErrorBlock) -> (Graph, Node<🍒>) {
    🅛.graph.failure = 🅡
    return 🅛
}

public func ‡<🍒>(🅛: (graph: Graph, node: Node<🍒>), 🅡: DispatchBlock) -> Graph {
    🅛.graph.finally = 🅡
    🅛.graph.root?.operate()
    return 🅛.graph
}