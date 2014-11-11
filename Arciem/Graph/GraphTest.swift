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
    
    var root = •graph; root ¶= "root"
    graph.root = root
    
    var a = •graph; a ¶= "a"
    var b = •graph; b ¶= "b"
    var c = •graph; c ¶= "c"
    var d = •graph; d ¶= "d"
    var e = •graph; e ¶= "e"
    var f = •graph; f ¶= "f"
    var g = •graph; g ¶= "g"
    var h = •graph; h ¶= "h"
    var i = •graph; i ¶= "i"
    var j = •graph; j ¶= "j"
    var k = •graph; k ¶= "k"
    var l = •graph; l ¶= "l"
    var m = •graph; m ¶= "m"
    var n = •graph; n ¶= "n"
    
    var ra = root → a; ra ¶= "ra"
    var rb = root → b; rb ¶= "rb"
    var rc = root → c; rc ¶= "rc"
    
    var bd = b → d; bd ¶= "bd"
    var be = b → e; be ¶= "be"
    
    var cf = c → f; cf ¶= "cf"
    var cg = c → g; cg ¶= "cg"
    
    var dh = d → h; dh ¶= "dh"
    var di = d → i; di ¶= "di"
    var dj = d → j; dj ¶= "dj"
    
    var fk = f → k; fk ¶= "fk"
    var fl = f → l; fl ¶= "fl"
    
    var gm = g → m; gm ¶= "gm"
    var gn = b → n; gn ¶= "gn"
    
    graph.writeDotDescriptionToFilename("graph")
}

func graphTest2() {
    let graph = Graph()
    
    var a = •graph; a ¶= "a"; a ^= 3
    var b = •graph; b ¶= "b"; b ^= 4
    var c = •graph; c ¶= "c"; c ^= 25
    var d = •graph; d ¶= "d"; d ^= 6
    var e = •graph; e ¶= "e"; e ^= 7
    
    let x = (a + b * c + d) % e

    graph.writeDotDescriptionToFilename("graph")
}

func graphTest3() {
    let graph = Graph()

    var a = •graph; a ^= 3; a ¶= "a"
    var b = •graph; b ^= 5; b ¶= "b"
    var x = a * b
    
    graph.writeDotDescriptionToFilename("graph")
}

// This graph needs to have a longer lifetime than the graphTest4() function.
var g4: Graph!
func graphTest4() {
    g4 = Graph()

    var a = •g4; a ¶= "a"
    var b = •g4; b ¶= "b"
    var c = •g4; c ¶= "c"
    var d = •g4; d ¶= "d"
    var e = •g4; e ¶= "e"
    
    let x = (a - b * c + d) % e

    g4.writeDotDescriptionToFilename("graph")
    
    let nodes = [a, b, c, d, e]
    let values = [3, 4, 5, 6, 7]
    var t: NSTimeInterval = 5
    for (var node, value) in shuffled(Array(Zip2(nodes, values))) {
        node §= delayedValue(value, t)
        t += Random.randomDouble(2.0..<5.0)
    }
}

func delayedValue(value: Int, delay: NSTimeInterval) -> ((Node) -> Void) {
    return { (var node: Node) -> Void in
        node.canceler?.cancel()
        node.canceler = dispatchOnBackgroundAfterDelay(delay) {
            dispatchOnMain() {
                node ^= value
                node.owner!.writeDotDescriptionToFilename("graph")
            }
        }
    }
}