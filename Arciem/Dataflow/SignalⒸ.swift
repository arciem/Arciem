//
//  SignalⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/18/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class SignalⒸ : Component {
    public private(set) var outSignal🅟: SignalPort!
    public let repeatInterval: NSTimeInterval // 0.0 means do only once
    private var canceler: Canceler?
    
    public init(_ name: String?, _ component: Component?, repeatInterval: NSTimeInterval = 0) {
        self.repeatInterval = repeatInterval
        super.init(name: name ?? "Signal", component)
        outSignal🅟 = SignalPort("out", self)
    }
    
    deinit {
        canceler?.cancel()
    }
    
    public func send() {
        canceler?.cancel()
        canceler = dispatchRepeatedOnBackground(atInterval: repeatInterval) { [unowned self] canceler in
            self.outSignal🅟.send()
        }
    }
}