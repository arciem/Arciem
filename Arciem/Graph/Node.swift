//
//  Node.swift
//  Arciem
//
//  Created by Robert McNally on 1/28/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class AbstractNode : Element {
    public internal(set) var inEdges = [AbstractEdge]()
    public internal(set) var outEdges = [AbstractEdge]()
    public var canceler: Canceler?
    
    public func addInEdge(edge: AbstractEdge) {
        inEdges.append(edge)
    }

    public func addOutEdge(edge: AbstractEdge) {
        outEdges.append(edge)
    }
    
    public override init(_ graph: Graph) {
        super.init(graph)
        graph.addNode(self)
    }
    
    public func operate() -> Self {
        return self
    }
}

extension AbstractNode {
    public var isCanceled: Bool {
        set {
            canceler?.isCanceled = newValue
        }
        get {
            return canceler?.isCanceled ?? false
        }
    }
    
    public func cancel() {
        canceler?.cancel()
    }
    
    public func dispatchOnBackground(f: DispatchBlock) {
        self.dispatchOnQueue(backgroundQueue, f: f)
    }
    
    public func dispatchOnMain(f: DispatchBlock) {
        self.dispatchOnQueue(mainQueue, f: f)
    }
    
    public func dispatchOnQueue(queue: DispatchQueue, f: DispatchBlock) {
        if !isCanceled {
            canceler = Arciem.dispatchOnQueue(queue, f)
        }
    }
}

public class Node<🍒> : AbstractNode {
    public typealias OutEdgeType = Edge<🍒>
    public typealias 🎁Type = 🎁<🍒>
    public var result: 🎁Type? {
        didSet {
            for edge in outEdges as! [OutEdgeType] {
                edge.transfer?()
            }
        }
    }

    public func set🎁(result: 🎁Type) -> Self {
        self.result = result
        return self
    }
    
    public func setValue(value: 🍒) -> Self {
        return set🎁(🎁(value))
    }
    
    public typealias OperationFunc = (Node<🍒>) -> Void
    public var operation: OperationFunc?
    
    public override func operate() -> Self {
        operation?(self)
        return self
    }
    
    public func setOperation(operation: OperationFunc) -> Self {
        self.operation = operation
        return self
    }
    
    public init(_ graph: Graph, operation: OperationFunc? = nil) {
        self.operation = operation
        super.init(graph)
    }
    
    public convenience init(🅛: Node<🍒>, operation: OperationFunc? = nil) {
        self.init(🅛.graph, operation: operation)
        Edge(tail: 🅛, head: self) { [unowned 🅛, unowned self] in 🅛.result => self.result }
    }
    
    public override var dotAttributes : [String : String] {
        get {
            var attrs = super.dotAttributes
            if let result = result {
                result
                    ★ { _ in attrs["color"] = "green3" }
                    † { _ in attrs["color"] = "red" }
            }
            return attrs
        }
    }
    
    // Declarations in extensions cannot override yet
    public override var dotLabels : [String] {
        get {
            var labels = super.dotLabels
            if let result = result {
                result
                    ★ { 🍒 in labels.append("=\(🍒)") }
                    † { 🚫 in labels.append("!\(🚫.code)") }
            }
            return labels
        }
    }
}


extension Node : CustomStringConvertible {
    public var description: String {
        get {
            var items = [typeNameOf(self), "eid:\(eid)"]
            if let name = name {
                items.append("name:\(name)")
            }
            items.append("result:\(result)")
            let s = items.joinWithSeparator(" ")
            return "[\(s)]"
        }
    }
}

public class OutputNode<🍒> : Node<🍒> {
    public typealias OutputFunc = (🎁Type?) -> Void
    public var output: OutputFunc
    public override var result: 🎁Type? {
        didSet {
            output(result)
        }
    }
    
    public init(_ graph: Graph, output: OutputFunc) {
        self.output = output
        super.init(graph)
    }
}

public func newOutputNode<🍒>(graph: Graph, name: String?, 🅛: Node<🍒>, output:(🎁<🍒>?) -> Void) -> Node<🍒> {
    let head = OutputNode<🍒>(graph, output: output)
    head.name = name
    Edge(tail: 🅛, head: head) { [unowned 🅛, unowned head] in 🅛.result => head.result }
    return head
}

public class PrefixOpNode<🍇R, 🍒> : Node<🍒> {
    public var 🅡: 🎁<🍇R>? {
        didSet {
            operate()
        }
    }

    public override init(_ graph: Graph, operation: OperationFunc?) {
        super.init(graph, operation: operation)
    }
}

public func newPrefixOpNode<🍇R, 🍒>(graph: Graph, name: String?, op:((🍇R) -> 🍒))(🅡: Node<🍇R>) -> Node<🍒> {
    let head = PrefixOpNode<🍇R, 🍒>(graph) { (node) in
        let n = node as! PrefixOpNode<🍇R, 🍒>
        if let 🅡 = n.🅡 {
            n.result = 🅡 → { op($0) }
        } else {
            n.result = nil
        }
    }
    head.name = name
    let e = Edge(tail: 🅡, head: head) { [unowned 🅡, unowned head] in 🅡.result => head.🅡 }
    e.transfer?()
    return head
}

public class InfixOpNode<🍋L, 🍇R, 🍒> : Node<🍒> {
    public var 🅡: 🎁<🍇R>? {
        didSet {
            operate()
        }
    }
    public var 🅛: 🎁<🍋L>? {
        didSet {
            operate()
        }
    }
    public init(_ graph: Graph, operation: OperationFunc) {
        super.init(graph, operation: operation)
    }
}

public func newInfixOpNode<🍋L, 🍇R, 🍒>(graph: Graph, name: String?, op:((l: 🍋L, r:🍇R) -> 🍒))(🅛: Node<🍋L>, 🅡: Node<🍇R>) -> Node<🍒> {
    let head = InfixOpNode<🍋L, 🍇R, 🍒>(graph) { node in
        let n = node as! InfixOpNode<🍋L, 🍇R, 🍒>
        if let 🅛 = n.🅛, 🅡 = n.🅡 {
            switch (🅛, 🅡) {
            case (.😄(let 📫l), .😄(let 📫r)):
                n.result = 🎁(op(l: 📫l⬆️, r: 📫r⬆️))
            case (.😡(let 🚫), _):
                n.result = .😡(🚫)
            case (_, .😡(let 🚫)):
                n.result = .😡(🚫)
            default:
                n.result = nil
            }
        } else {
            n.result = nil
        }
    }
    head.name = name
    let e1 = Edge(tail: 🅡, head: head) { [unowned 🅡, unowned head] in 🅡.result => head.🅡 }.setName("🅡")
    e1.transfer?()
    let e2 = Edge(tail: 🅛, head: head) { [unowned 🅛, unowned head] in 🅛.result => head.🅛 }.setName("🅛")
    e2.transfer?()
    return head
}

public prefix func -(🅡: Node<Double>) -> Node<Double> {
    return newPrefixOpNode(🅡.graph, "-"){ return -$0 } (🅡: 🅡)
}

public func +(🅛: Node<Double>, 🅡: Node<Double>) -> Node<Double> {
    return newInfixOpNode(🅛.graph, "+"){ return $0 + $1 } (🅛: 🅛, 🅡: 🅡)
}

public func -(🅛: Node<Double>, 🅡: Node<Double>) -> Node<Double> {
    return newInfixOpNode(🅛.graph, "-"){ return $0 - $1 }(🅛: 🅛, 🅡: 🅡)
}

public func *(🅛: Node<Double>, 🅡: Node<Double>) -> Node<Double> {
    return newInfixOpNode(🅛.graph, "*"){ return $0 * $1 }(🅛: 🅛, 🅡: 🅡)
}

public func /(🅛: Node<Double>, 🅡: Node<Double>) -> Node<Double> {
    return newInfixOpNode(🅛.graph, "/"){ return $0 / $1 }(🅛: 🅛, 🅡: 🅡)
}

public func %(🅛: Node<Double>, 🅡: Node<Double>) -> Node<Double> {
    return newInfixOpNode(🅛.graph, "%"){ return $0 % $1 }(🅛: 🅛, 🅡: 🅡)
}
