//
//  SignalPort.swift
//  Arciem
//
//  Created by Robert McNally on 2/18/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class SignalPortⒶ<🍒> : OutPort<Bool> {
    public override init(_ name: String, _ component: Component) {
        super.init(name, component)
    }
    
    public func send() {
        send(true)
        send(false)
    }
}

public typealias SignalPort = SignalPortⒶ<Bool>
