//
//  GraphTest.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public func graphTest() {
    graphTest4()
}

func graphTest1() {
    let graph = Graph()
    
    var root = OpNode<Int>().addToGraph(graph).setName("root")
    graph.root = root
    
    var a = Node().addToGraph(graph).setName("a")
    var b = Node().addToGraph(graph).setName("b")
    var c = Node().addToGraph(graph).setName("c")
    var d = Node().addToGraph(graph).setName("d")
    var e = Node().addToGraph(graph).setName("e")
    var f = Node().addToGraph(graph).setName("f")
    var g = Node().addToGraph(graph).setName("g")
    var h = Node().addToGraph(graph).setName("h")
    var i = Node().addToGraph(graph).setName("i")
    var j = Node().addToGraph(graph).setName("j")
    var k = Node().addToGraph(graph).setName("k")
    var l = Node().addToGraph(graph).setName("l")
    var m = Node().addToGraph(graph).setName("m")
    var n = Node().addToGraph(graph).setName("n")
    
    var ra = Edge().addToGraph(graph, tail: root, head: a).setName("ra")
    var rb = Edge().addToGraph(graph, tail: root, head: b).setName("rb")
    var rc = Edge().addToGraph(graph, tail: root, head: c).setName("rc")
    
    var bd = Edge().addToGraph(graph, tail: b, head: d).setName("bd")
    var be = Edge().addToGraph(graph, tail: b, head: e).setName("be")
    
    var cf = Edge().addToGraph(graph, tail: c, head: f).setName("cf")
    var cg = Edge().addToGraph(graph, tail: c, head: g).setName("cg")
    
    var dh = Edge().addToGraph(graph, tail: d, head: h).setName("dh")
    var di = Edge().addToGraph(graph, tail: d, head: i).setName("di")
    var dj = Edge().addToGraph(graph, tail: d, head: j).setName("dj")
    
    var fk = Edge().addToGraph(graph, tail: f, head: k).setName("fk")
    var fl = Edge().addToGraph(graph, tail: f, head: l).setName("fl")
    
    var gm = Edge().addToGraph(graph, tail: g, head: m).setName("gm")
    var gn = Edge().addToGraph(graph, tail: g, head: n).setName("gn")
    
    graph.writeDotDescriptionToFilename("graph")
}

func graphTest2() {
    let graph = Graph()
    
    var a = OpNode<Int>().addToGraph(graph).setName("a").setValue(3)
    var b = OpNode<Int>().addToGraph(graph).setName("b").setValue(4)
    var c = OpNode<Int>().addToGraph(graph).setName("c").setValue(25)
    var d = OpNode<Int>().addToGraph(graph).setName("d").setValue(6)
    var e = OpNode<Int>().addToGraph(graph).setName("e").setValue(7)
    
    let x = (a + b * c + d) % e

    graph.writeDotDescriptionToFilename("graph")
}

func graphTest3() {
    let graph = Graph()

    var a = OpNode<Int>().addToGraph(graph).setValue(3).setName("a")
    var b = OpNode<Int>().addToGraph(graph).setValue(5).setName("b")
    var x = a * b
    
    graph.writeDotDescriptionToFilename("graph")
}

// This graph needs to have a longer lifetime than the graphTest4() function.
var g4: Graph!
func graphTest4() {
    g4 = Graph()

    var a = OpNode<Int>().addToGraph(g4).setName("a")
    var b = OpNode<Int>().addToGraph(g4).setName("b")
    var c = OpNode<Int>().addToGraph(g4).setName("c")
    var d = OpNode<Int>().addToGraph(g4).setName("d")
    var e = OpNode<Int>().addToGraph(g4).setName("e")
    
    let x = (a - b * c + d) % e

    g4.writeDotDescriptionToFilename("graph")
    
    let nodes = [a, b, c, d, e]
    let values = [3, 4, 5, 6, 7]
    var t: NSTimeInterval = 5
    for (var node, value) in shuffled(Array(Zip2(nodes, values))) {
        node.setOperation(delayedValue(value, t))
        t += Random.randomDouble(2.0..<5.0)
    }
}

func delayedValue<V>(value: V, delay: NSTimeInterval) -> ((OpNode<V>) -> Void) {
    return { (var node: OpNode<V>) -> Void in
        node.canceler?.cancel()
        node.canceler = dispatchOnBackgroundAfterDelay(delay) {
            dispatchOnMain() {
                node.setValue(value)
                node.owner!.writeDotDescriptionToFilename("graph")
            }
        }
    }
}