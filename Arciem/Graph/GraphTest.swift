//
//  GraphTest.swift
//  Arciem
//
//  Created by Robert McNally on 1/31/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Arciem
import XCTest

public func graphTest() {
    graphTest4()
}

func graphTest1() {
    let g = Graph()
    
    let n1 = Node<Double>(g).setName("n1")
    let n2 = Node(🅛: n1).setName("n2")
    let n3 = (-n2).setName("n3")
    let n4 = Node<Double>(g).setName("n4")
    let n5 = (n2 * n4).setName("n5")
    let n6 = (n5 - n4).setName("n6")
    n1.result = Result(10.5)
    n4.result = Result(2.0)
    g.writeDotDescriptionToFilename("test")
}

func graphTest2() {
    let graph = Graph()
    
    typealias N = Node<Void>
    typealias E = Edge<Void>
    
    var root = N(graph).setName("root")
    graph.root = root
    
    var a = N(graph).setName("a")
    var b = N(graph).setName("b")
    var c = N(graph).setName("c")
    var d = N(graph).setName("d")
    var e = N(graph).setName("e")
    var f = N(graph).setName("f")
    var g = N(graph).setName("g")
    var h = N(graph).setName("h")
    var i = N(graph).setName("i")
    var j = N(graph).setName("j")
    var k = N(graph).setName("k")
    var l = N(graph).setName("l")
    var m = N(graph).setName("m")
    var n = N(graph).setName("n")
    
    var ra = E(tail: root, head: a).setName("ra")
    var rb = E(tail: root, head: b).setName("rb")
    var rc = E(tail: root, head: c).setName("rc")
    
    var bd = E(tail: b, head: d).setName("bd")
    var be = E(tail: b, head: e).setName("be")
    
    var cf = E(tail: c, head: f).setName("cf")
    var cg = E(tail: c, head: g).setName("cg")
    
    var dh = E(tail: d, head: h).setName("dh")
    var di = E(tail: d, head: i).setName("di")
    var dj = E(tail: d, head: j).setName("dj")
    
    var fk = E(tail: f, head: k).setName("fk")
    var fl = E(tail: f, head: l).setName("fl")
    
    var gm = E(tail: g, head: m).setName("gm")
    var gn = E(tail: g, head: n).setName("gn")
    
    graph.writeDotDescriptionToFilename("test")
}

func graphTest3() {
    let graph = Graph()
    
    var a = Node<Double>(graph).setName("a").setValue(4)
    var b = Node<Double>(graph).setName("b").setValue(25)
    var c = Node<Double>(graph).setName("c").setValue(3)
    var d = Node<Double>(graph).setName("d").setValue(6)
    var e = Node<Double>(graph).setName("e").setValue(7)
    
    let x = (a + b * c + d) % e
    
    graph.writeDotDescriptionToFilename("test")
}

var g4: Graph!
func graphTest4() {
    g4 = Graph()
    
    var a = Node<Double>(g4).setName("a")
    var b = Node<Double>(g4).setName("b")
    var c = Node<Double>(g4).setName("c")
    var d = Node<Double>(g4).setName("d")
    var e = Node<Double>(g4).setName("e")
    
    let x = (a - b * c + d) % e
    
    g4.writeDotDescriptionToFilename("test")

    let err = NSError(domain: "FooDomain", code: 666, userInfo: nil)

    let nodes = shuffled([a, b, c, d, e])
    var values: [Any] = shuffled([3.3, 4.4, err, 6.6, 7.7])
//    values[0] = err
    var t: NSTimeInterval = 5
    for (var node, value) in Array(Zip2(nodes, values)) {
        var result: Result<Double>?
        if let f = value as? Double {
            result = Result(f)
        } else if let 🚫 = value as? ErrorType {
            result = Result(error: 🚫)
        }
        if let result = result {
            node.setOperation(delayedResult(result, t))
            node.operate()
            t += Random.randomDouble(2.0..<5.0)
        }
    }
}

func delayedResult<V>(result: Result<V>, delay: NSTimeInterval) -> ((Node<V>) -> Void) {
    return { (var node: Node<V>) -> Void in
        node.canceler?.cancel()
        node.canceler = dispatchOnBackgroundAfterDelay(delay) {
            node.canceler = dispatchOnMain() {
                switch result {
                case .Error:
                    node.graph.cancel()
                default:
                    break
                }
                node.setResult(result)
                node.graph.writeDotDescriptionToFilename("test")
            }
        }
    }
}