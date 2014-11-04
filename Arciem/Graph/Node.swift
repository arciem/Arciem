//
//  Node.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Node : Element {
    internal(set) public var inEdges = EdgeSet()
    internal(set) public var outEdges = EdgeSet()
}

extension Node : Printable {
    public var description: String { get { return "[Node \(eid)]" } }
}

public typealias NodeSet = Set<Node>
