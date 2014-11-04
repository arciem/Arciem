//
//  GraphAlgorithm.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public enum Mark {
    case White
    case Gray
    case Black
}

public class Markers<K: Hashable> {
    typealias KeyType = K
    var dict = [KeyType : Mark]()
    
    public subscript(key: KeyType) -> Mark {
        get { return dict[key] ?? .White }
        set { dict[key] = newValue }
    }
}

public typealias NodeVisitorBlock = (Node) -> Void
public typealias EdgeVisitorBlock = (Edge) -> Void

public class DepthFirstSearch {
    var markers = Markers<Node>()
    let graph: Graph

    public var nodeVisitorInitialize: NodeVisitorBlock?
    public var nodeVisitorStart: NodeVisitorBlock?
    public var nodeVisitorDiscover: NodeVisitorBlock?
    public var edgeVisitorExamine: EdgeVisitorBlock?
    public var edgeVisitorTree: EdgeVisitorBlock?
    public var edgeVisitorBack: EdgeVisitorBlock?
    public var edgeVisitorForwardOrCross: EdgeVisitorBlock?
    public var nodeVisitorFinish: NodeVisitorBlock?

    required public init(graph: Graph) {
        self.graph = graph
    }
   
    public func start(startNode: Node? = nil) {
        if let node = startNode? {
            nodeVisitorStart?(node)
            visitNode(node)
        }
        
        for node in graph.nodes {
            if markers[node] == .White {
                nodeVisitorStart?(node)
                visitNode(node)
            }
        }
    }
    
    func visitNode(node: Node) {
        markers[node] = .Gray
        nodeVisitorDiscover?(node)
        for edge in node.outEdges {
            edgeVisitorExamine?(edge)
            let head = edge.head
            switch markers[head] {
            case .White:
                edgeVisitorTree?(edge)
                visitNode(head)
            case .Gray:
                edgeVisitorBack?(edge)
            case .Black:
                edgeVisitorForwardOrCross?(edge)
            }
        }
        markers[node] = .Black
        nodeVisitorFinish?(node)
    }
}

public class TopologialSort : DepthFirstSearch {
    var orderedNodes = [Node]()
    
    required public init(graph: Graph) {
        super.init(graph: graph)
        nodeVisitorFinish = { node in
            self.orderedNodes.append(node)
        }
    }
    
    public func sort() -> [Node] {
        start(startNode: nil)
        return self.orderedNodes.reverse()
    }
}
