//
//  ConsumerⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class ConsumerⒸ<🍒: DataflowⓋ>: Component {
    public typealias InPortⓉ = InPort<🍒>
    public typealias InPlugⒻ = InPortⓉ.InPlugⒻ
    
    public private(set) var in🅟: InPortⓉ!
    
    public init(_ name: String?, _ component: Component?, plug: InPlugⒻ) {
        super.init(name: name ?? "Consumer", component)
        in🅟 = InPortⓉ("in", self, inPlug: plug)
    }
}
