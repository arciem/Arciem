//
//  Edge.swift
//  Arciem
//
//  Created by Robert McNally on 1/28/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class AbstractEdge : Element {
    public weak var tail: AbstractNode!
    public weak var head: AbstractNode!
    
    public init(tail: AbstractNode, head: AbstractNode) {
        self.tail = tail
        self.head = head
        super.init(tail.graph)
        tail.addOutEdge(self)
        head.addInEdge(self)
        graph.addEdge(self)
    }
}

public class Edge<ResultType> : AbstractEdge {
    public typealias TailNodeType = Node<ResultType>
    public typealias TransferFunc = () -> Void

    public let transfer: TransferFunc?
    
    public init(tail: TailNodeType, head: AbstractNode, transfer: TransferFunc? = nil) {
        self.transfer = transfer
        super.init(tail: tail, head: head)
    }
    
    public override var dotAttributes : [String : String] {
        get {
            var attrs = super.dotAttributes
            if let t = tail as? TailNodeType {
                switch t.result {
                case .None:
                    break
                case .Value(let v):
                    attrs["color"] = "green3"
                    break
                case .Error(let e):
                    attrs["color"] = "red"
                    break
                }
            }
            return attrs
        }
    }
}

extension Edge : Printable {
    public var description: String {
        get {
            var items = [typeNameOf(self), "eid:\(eid)"]
            if let name = name? {
                items.append("name:\(name)")
            }
            items.append("tail:\(tail) ➡️ head:\(head)")
            let s = join(" ", items)
            return "(\(s))"
        }
    }
}
