//
//  GraphAlgorithm.swift
//  Arciem
//
//  Created by Robert McNally on 2/1/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public enum Mark {
    case White
    case Gray
    case Black
}

public class Markers {
    var dict = [EID : Mark]()
    
    public subscript(key: EID) -> Mark {
        get { return dict[key] ?? .White }
        set { dict[key] = newValue }
    }
}

public typealias NodeVisitor = (AbstractNode) -> Void
public typealias EdgeVisitor = (AbstractEdge) -> Void

public class DepthFirstSearch {
    var markers = Markers()
    let graph: Graph
    
    public var nodeVisitorInitialize: NodeVisitor?
    public var nodeVisitorStart: NodeVisitor?
    public var nodeVisitorDiscover: NodeVisitor?
    public var edgeVisitorExamine: EdgeVisitor?
    public var edgeVisitorTree: EdgeVisitor?
    public var edgeVisitorBack: EdgeVisitor?
    public var edgeVisitorForwardOrCross: EdgeVisitor?
    public var nodeVisitorFinish: NodeVisitor?
    
    required public init(graph: Graph) {
        self.graph = graph
    }
    
    public func start(startNode: AbstractNode? = nil) {
        if let node = startNode? {
            nodeVisitorStart?(node)
            visitNode(node)
        }
        
        for node in graph.nodes {
            if markers[node.eid] == .White {
                nodeVisitorStart?(node)
                visitNode(node)
            }
        }
    }
    
    func visitNode(node: AbstractNode) {
        markers[node.eid] = .Gray
        nodeVisitorDiscover?(node)
        for edge in node.outEdges {
            edgeVisitorExamine?(edge)
            let head = edge.head
            switch markers[head.eid] {
            case .White:
                edgeVisitorTree?(edge)
                visitNode(head)
            case .Gray:
                edgeVisitorBack?(edge)
            case .Black:
                edgeVisitorForwardOrCross?(edge)
            }
        }
        markers[node.eid] = .Black
        nodeVisitorFinish?(node)
    }
}

public class TopologialSort : DepthFirstSearch {
    var orderedNodes = [AbstractNode]()
    
    required public init(graph: Graph) {
        super.init(graph: graph)
        nodeVisitorFinish = { node in
            self.orderedNodes.append(node)
        }
    }
    
    public func sort() -> [AbstractNode] {
        start(startNode: nil)
        return self.orderedNodes.reverse()
    }
}
