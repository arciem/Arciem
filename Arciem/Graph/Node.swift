//
//  Node.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Node : Element {
    public var inEdges = Set<Edge>()
    public var outEdges = Set<Edge>()
    
    public func performOperation() { }
    
    public func addToGraph(g: Graph) -> Self {
        g.addNode(self)
        return self
    }
}

extension Node : Printable {
    public var description: String { get { return "[\(eid)]" } }
}

public class OpNode<V> : Node {
    public typealias ValueType = V
    
    public typealias OpFuncType = (OpNode<V>) -> Void
    public var operation: OpFuncType?
    public var canceler: Canceler?
    
    public required override init() {
    }
    
    public func valueDidChange() {
        for edge in outEdges {
            if let e = edge as? OpEdge<ValueType> {
                e.transferValue()
            }
        }
        for edge in outEdges {
            edge.head.performOperation()
        }
    }
    
    public var value : ValueType? {
        get { return self["value"] as ValueType? }
        set {
            self["value"] = newValue!
            valueDidChange()
        }
    }
    
    public func setValue(value: ValueType?) -> Self {
        self.value = value
        return self
    }
    
    public var hasValue : Bool {
        get { return value != nil }
    }
    
    public override func performOperation() {
        operation?(self)
    }
    
    public func setOperation(op: OpFuncType) -> Self {
        self.operation = op
        performOperation()
        return self
    }
    
    public func addEdgeTo(head: Node) -> OpEdge<ValueType> {
        let graph = self.owner!
        var edge = OpEdge<ValueType>()
        graph.addEdge(edge, tail: self, head: head)
        return edge
    }

    public override var dotAttributes : [String : String] {
        get {
            var attrs = super.dotAttributes
            if hasValue {
                attrs["color"] = "green3"
            }
            return attrs
        }
    }
    
    public override var dotLabels : [String] {
        get {
            var labels = super.dotLabels
            if let value = self.value? {
                labels.append("=\(value)")
            }
            return labels
        }
    }
}

extension OpNode {
    // KLUDGE: Declarations in extensions cannot override yet
    // public override var dotAttributes : [String : String]
}

// "value assign"
public func ^=<V>(inout lhs: OpNode<V>, rhs: V) {
    lhs.value = rhs
}

// "value extract"
public postfix func ^<V>(lhs: OpNode<V>) -> V? {
    return lhs.value
}

// "operation assign"
public func §=<V>(inout lhs: OpNode<V>, rhs:OpNode<V>.OpFuncType) {
    lhs.setOperation(rhs)
}

public func infix<T: ImmutableArithmeticable>(symbol: String, op:((l: T, r: T) -> T))(lhs: OpNode<T>, rhs: OpNode<T>) -> OpNode<T> {
    lhs._assertSameOwner(rhs)
    let graph = lhs.owner!
    var node: OpNode<T> = •graph;
    node ¶= symbol
    node §= { (var node: OpNode<T>) -> Void in
        if let lhsValue = node["lhs"]? as? T {
            if let rhsValue = node["rhs"]? as? T {
                let result = op(l: lhsValue, r: rhsValue)
                node.setValue(result)
            }
        }
    }
    var ledge = lhs → node; ledge ¶= "lhs";
    var redge = rhs → node; redge ¶= "rhs";
    ledge.transferValue()
    redge.transferValue()
    node.performOperation()
    return node
}

public func +<V: ImmutableArithmeticable>(lhs: OpNode<V>, rhs: OpNode<V>) -> OpNode<V> { return infix("+", { (lhs: V, rhs: V) -> V in lhs + rhs })(lhs: lhs, rhs:rhs) }
public func -<V: ImmutableArithmeticable>(lhs: OpNode<V>, rhs: OpNode<V>) -> OpNode<V> { return infix("-", { (lhs: V, rhs: V) -> V in lhs - rhs })(lhs: lhs, rhs:rhs) }
public func *<V: ImmutableArithmeticable>(lhs: OpNode<V>, rhs: OpNode<V>) -> OpNode<V> { return infix("*", { (lhs: V, rhs: V) -> V in lhs * rhs })(lhs: lhs, rhs:rhs) }
public func /<V: ImmutableArithmeticable>(lhs: OpNode<V>, rhs: OpNode<V>) -> OpNode<V> { return infix("/", { (lhs: V, rhs: V) -> V in lhs / rhs })(lhs: lhs, rhs:rhs) }
public func %<V: ImmutableArithmeticable>(lhs: OpNode<V>, rhs: OpNode<V>) -> OpNode<V> { return infix("%", { (lhs: V, rhs: V) -> V in lhs % rhs })(lhs: lhs, rhs:rhs) }
