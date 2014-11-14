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
    
    var root = graph.newNode().setName("root")
    graph.root = root
    
    var a = graph.newNode().setName("a")
    var b = graph.newNode().setName("b")
    var c = graph.newNode().setName("c")
    var d = graph.newNode().setName("d")
    var e = graph.newNode().setName("e")
    var f = graph.newNode().setName("f")
    var g = graph.newNode().setName("g")
    var h = graph.newNode().setName("h")
    var i = graph.newNode().setName("i")
    var j = graph.newNode().setName("j")
    var k = graph.newNode().setName("k")
    var l = graph.newNode().setName("l")
    var m = graph.newNode().setName("m")
    var n = graph.newNode().setName("n")
    
    var ra = root.newEdgeTo(a).setName("ra")
    var rb = root.newEdgeTo(b).setName("rb")
    var rc = root.newEdgeTo(c).setName("rc")
    
    var bd = b.newEdgeTo(d).setName("bd")
    var be = b.newEdgeTo(e).setName("be")
    
    var cf = c.newEdgeTo(f).setName("cf")
    var cg = c.newEdgeTo(g).setName("cg")
    
    var dh = d.newEdgeTo(h).setName("dh")
    var di = d.newEdgeTo(i).setName("di")
    var dj = d.newEdgeTo(j).setName("dj")
    
    var fk = f.newEdgeTo(k).setName("fk")
    var fl = f.newEdgeTo(l).setName("fl")
    
    var gm = g.newEdgeTo(m).setName("gm")
    var gn = b.newEdgeTo(n).setName("gn")
    
    graph.writeDotDescriptionToFilename("graph")
}

func graphTest2() {
    let graph = Graph()
    
    var a = graph.newNode().setName("a").setValue(3)
    var b = graph.newNode().setName("b").setValue(4)
    var c = graph.newNode().setName("c").setValue(25)
    var d = graph.newNode().setName("d").setValue(6)
    var e = graph.newNode().setName("e").setValue(7)
    
    let x = (a + b * c + d) % e

    graph.writeDotDescriptionToFilename("graph")
}

func graphTest3() {
    let graph = Graph()

    var a = graph.newNode().setValue(3).setName("a")
    var b = graph.newNode().setValue(5).setName("b")
    var x = a * b
    
    graph.writeDotDescriptionToFilename("graph")
}

// This graph needs to have a longer lifetime than the graphTest4() function.
var g4: Graph!
func graphTest4() {
    g4 = Graph()

    var a = g4.newNode().setName("a")
    var b = g4.newNode().setName("b")
    var c = g4.newNode().setName("c")
    var d = g4.newNode().setName("d")
    var e = g4.newNode().setName("e")
    
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

func delayedValue(value: Int, delay: NSTimeInterval) -> ((Node) -> Void) {
    return { (var node: Node) -> Void in
        node.canceler?.cancel()
        node.canceler = dispatchOnBackgroundAfterDelay(delay) {
            dispatchOnMain() {
                node.setValue(value)
                node.owner!.writeDotDescriptionToFilename("graph")
            }
        }
    }
}