//
//  ProducerⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//


public class ProducerⒸ<🍒: DataflowⓋ>: Component {
    public typealias OutPortⓉ = OutPort<🍒>
    
    public private(set) var out🅟: OutPortⓉ!
    
    public init(_ name: String?, _ component: Component?) {
        super.init(name: name ?? "Producer", component)
        out🅟 = OutPortⓉ("out", self)
    }
    
    public func send(@autoclosure f:() -> 🍒) {
        out🅟.send(f)
    }
}
