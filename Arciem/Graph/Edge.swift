//
//  Edge.swift
//  Arciem
//
//  Created by Robert McNally on 11/4/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public class Edge : Element {
    weak internal(set) public var tail: Node! = nil
    weak internal(set) public var head: Node! = nil
}

extension Edge : Printable {
    public var description: String {
        get { return "(Edge \(eid))" }
    }
}

public typealias EdgeSet = Set<Edge>
