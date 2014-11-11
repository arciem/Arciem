//
//  Node.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Node : Element {
    internal(set) public var inEdges = Set<Edge>()
    internal(set) public var outEdges = Set<Edge>()
    
    public typealias OpFuncType = (Node) -> Void
    public var operation: OpFuncType?
    public var canceler: Canceler?
    
    override public var value : Any? {
        didSet {
            valueDidChange()
        }
    }

    public func valueDidChange() {
        for edge in outEdges {
            edge.transferValue()
        }
        for edge in outEdges {
            edge.head.performOperation()
        }
    }
    
    public func performOperation() {
        operation?(self)
    }
}

extension Node : Printable {
    public var description: String { get { return "[\(eid)]" } }
}

// "operation assign"
public func §= (inout lhs: Node, rhs:Node.OpFuncType) {
    lhs.operation = rhs
    lhs.performOperation()
}

public func infix<T: ImmutableArithmeticable>(symbol: String, op:((l: T, r: T) -> T))(lhs: Node, rhs: Node) -> Node {
    lhs._assertSameOwner(rhs)
    let graph = lhs.owner!
    var node = •graph;
    node ¶= symbol
    node §= { (var node: Node) -> Void in
        if let lhsValue = node["lhs"]? as? T {
            if let rhsValue = node["rhs"]? as? T {
                node ^= op(l: lhsValue, r: rhsValue)
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

func addValues      <T: ImmutableArithmeticable>(lhs: T, rhs: T) -> T { return lhs + rhs }
func subtractValues <T: ImmutableArithmeticable>(lhs: T, rhs: T) -> T { return lhs - rhs }
func multiplyValues <T: ImmutableArithmeticable>(lhs: T, rhs: T) -> T { return lhs * rhs }
func divideValues   <T: ImmutableArithmeticable>(lhs: T, rhs: T) -> T { return lhs / rhs }
func remainderValues<T: ImmutableArithmeticable>(lhs: T, rhs: T) -> T { return lhs % rhs }

let addNodeValues       = infix("+", { (lhs: Int, rhs: Int) -> Int in lhs + rhs })
let subtractNodeValues  = infix("-", { (lhs: Int, rhs: Int) -> Int in lhs - rhs })
let multiplyNodeValues  = infix("*", { (lhs: Int, rhs: Int) -> Int in lhs * rhs })
let divideNodeValues    = infix("/", { (lhs: Int, rhs: Int) -> Int in lhs / rhs })
let remainderValues     = infix("%", { (lhs: Int, rhs: Int) -> Int in lhs % rhs })

public func +(lhs: Node, rhs: Node) -> Node { return addNodeValues(lhs: lhs, rhs: rhs) }
public func -(lhs: Node, rhs: Node) -> Node { return subtractNodeValues(lhs: lhs, rhs: rhs)  }
public func *(lhs: Node, rhs: Node) -> Node { return multiplyNodeValues(lhs: lhs, rhs: rhs) }
public func /(lhs: Node, rhs: Node) -> Node { return divideNodeValues(lhs: lhs, rhs: rhs) }
public func %(lhs: Node, rhs: Node) -> Node { return remainderValues(lhs: lhs, rhs: rhs) }
