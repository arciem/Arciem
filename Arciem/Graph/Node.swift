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
        self.dispatchOnQueue(backgroundQueue, f)
    }
    
    public func dispatchOnMain(f: DispatchBlock) {
        self.dispatchOnQueue(mainQueue, f)
    }
    
    public func dispatchOnQueue(queue: DispatchQueue, f: DispatchBlock) {
        if !isCanceled {
            canceler = Arciem.dispatchOnQueue(queue, f)
        }
    }
}

public class Node<ValueType> : AbstractNode {
    public typealias OutEdgeType = Edge<ValueType>
    public typealias ResultType = Result<ValueType>
    public var result: ResultType? {
        didSet {
            for edge in outEdges as [OutEdgeType] {
                edge.transfer?()
            }
        }
    }

    public func setResult(result: ResultType) -> Self {
        self.result = result
        return self
    }
    
    public func setValue(value: ValueType) -> Self {
        return setResult(Result(value))
    }
    
    public typealias OperationFunc = (Node<ValueType>) -> Void
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
    
    public convenience init(lhs: Node<ValueType>, operation: OperationFunc? = nil) {
        self.init(lhs.graph, operation)
        Edge(tail: lhs, head: self) { [unowned lhs, unowned self] in lhs.result => self.result }
    }
    
    public override var dotAttributes : [String : String] {
        get {
            var attrs = super.dotAttributes
            if let result = result? {
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
            if let result = result? {
                result
                    ★ { value in labels.append("=\(value)") }
                    † { error in labels.append("!\(error.code)") }
            }
            return labels
        }
    }
}


extension Node : Printable {
    public var description: String {
        get {
            var items = [typeNameOf(self), "eid:\(eid)"]
            if let name = name? {
                items.append("name:\(name)")
            }
            items.append("result:\(result)")
            let s = join(" ", items)
            return "[\(s)]"
        }
    }
}

public class OutputNode<ValueType> : Node<ValueType> {
    public typealias OutputFunc = (ResultType?) -> Void
    public var output: OutputFunc
    public override var result: ResultType? {
        didSet {
            output(result)
        }
    }
    
    public init(_ graph: Graph, output: OutputFunc) {
        self.output = output
        super.init(graph)
    }
}

public func newOutputNode<ValueType>(graph: Graph, name: String?, lhs: Node<ValueType>, output:(Result<ValueType>?) -> Void) -> Node<ValueType> {
    let head = OutputNode<ValueType>(graph, output: output)
    head.name = name
    Edge(tail: lhs, head: head) { [unowned lhs, unowned head] in lhs.result => head.result }
    return head
}

public class PrefixOpNode<RHSType, ValueType> : Node<ValueType> {
    public var rhs: Result<RHSType>? {
        didSet {
            operate()
        }
    }

    public override init(_ graph: Graph, operation: OperationFunc?) {
        super.init(graph, operation)
    }
}

public func newPrefixOpNode<R, ValueType>(graph: Graph, name: String?, op:((R) -> ValueType))(rhs: Node<R>) -> Node<ValueType> {
    let head = PrefixOpNode<R, ValueType>(graph) { (node) in
        let n = node as PrefixOpNode<R, ValueType>
        if let rhs = n.rhs? {
            n.result = rhs → { op($0) }
        } else {
            n.result = nil
        }
    }
    head.name = name
    let e = Edge(tail: rhs, head: head) { [unowned rhs, unowned head] in rhs.result => head.rhs }
    e.transfer?()
    return head
}

public class InfixOpNode<LHSType, RHSType, ValueType> : Node<ValueType> {
    public var rhs: Result<RHSType>? {
        didSet {
            operate()
        }
    }
    public var lhs: Result<LHSType>? {
        didSet {
            operate()
        }
    }
    public init(_ graph: Graph, operation: OperationFunc) {
        super.init(graph, operation)
    }
}

public func newInfixOpNode<L, R, ValueType>(graph: Graph, name: String?, op:((l: L, r:R) -> ValueType))(lhs: Node<L>, rhs: Node<R>) -> Node<ValueType> {
    let head = InfixOpNode<L, R, ValueType>(graph) { node in
        let n = node as InfixOpNode<L, R, ValueType>
        if let lhs = n.lhs? {
            if let rhs = n.rhs? {
                switch (lhs, rhs) {
                case (.Value(let lv), .Value(let rv)):
                    n.result = Result(op(l: lv.unbox, r: rv.unbox))
                case (.Error(let e), _):
                    n.result = .Error(e)
                case (_, .Error(let e)):
                    n.result = .Error(e)
                default:
                    n.result = nil
                }
            } else {
                n.result = nil
            }
        } else {
            n.result = nil
        }
    }
    head.name = name
    let e1 = Edge(tail: rhs, head: head) { [unowned rhs, unowned head] in rhs.result => head.rhs }.setName("rhs")
    e1.transfer?()
    let e2 = Edge(tail: lhs, head: head) { [unowned lhs, unowned head] in lhs.result => head.lhs }.setName("lhs")
    e2.transfer?()
    return head
}

public prefix func -<T: SignedNumberType>(rhs: Node<T>) -> Node<T> {
    return newPrefixOpNode(rhs.graph, "-"){ return -$0 } (rhs: rhs)
}

public func +<T: ImmutableArithmeticable>(lhs: Node<T>, rhs: Node<T>) -> Node<T> {
    return newInfixOpNode(lhs.graph, "+"){ return $0 + $1 } (lhs: lhs, rhs: rhs)
}

public func -<T: ImmutableArithmeticable>(lhs: Node<T>, rhs: Node<T>) -> Node<T> {
    return newInfixOpNode(lhs.graph, "-"){ return $0 - $1 }(lhs: lhs, rhs: rhs)
}

public func *<T: ImmutableArithmeticable>(lhs: Node<T>, rhs: Node<T>) -> Node<T> {
    return newInfixOpNode(lhs.graph, "*"){ return $0 * $1 }(lhs: lhs, rhs: rhs)
}

public func /<T: ImmutableArithmeticable>(lhs: Node<T>, rhs: Node<T>) -> Node<T> {
    return newInfixOpNode(lhs.graph, "/"){ return $0 / $1 }(lhs: lhs, rhs: rhs)
}

public func %<T: ImmutableArithmeticable>(lhs: Node<T>, rhs: Node<T>) -> Node<T> {
    return newInfixOpNode(lhs.graph, "%"){ return $0 % $1 }(lhs: lhs, rhs: rhs)
}
