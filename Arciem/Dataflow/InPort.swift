//
//  InPort.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class InPort<🍒: DataflowⓋ> : Port<🍒> {
    public typealias InPlugⒻ = (🎁<🍒>) -> Void
    private let inPlug: InPlugⒻ
    
    public init(_ name: String, _ component: Component, inPlug: InPlugⒻ) {
        self.inPlug = inPlug
        super.init(name, component)
    }
    
    // serialized
    override func 🅥DidChange(newValue: 🎁<🍒>) {
        inPlug(newValue)
    }
}
