//
//  ReachabilityComponent.swift
//  Arciem
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class ReachabilityComponent : Component {
    public private(set) var inEnabledPort: InputPort!
    public private(set) var outStatusPort: OutputPort!
    
    private let reachability: Reachability
    
    private var enabled: Bool = false {
        willSet {
            if enabled != newValue {
                if newValue {
                    reachability.startNotifier()
                    sendReachability()
                } else {
                    reachability.stopNotifier()
                }
            }
        }
    }
    
    private func sendReachability() {
        let s = reachability.currentReachabilityString
        outStatusPort.sendObject(s)
    }

    public init(hostname: String) {
        reachability = Reachability(hostname: hostname)
        
        super.init()
        
        inEnabledPort = addInputPortNamed("enabled", synchronous: true) { [unowned self] packet in
            let _  = packet ★ { v in self.enabled = v.boolValue ?? false }
        }
        
        outStatusPort = addOutputPortNamed("status", synchronous: true)

        reachability.whenReachable = { [unowned self] _ in
            self.sendReachability()
        }
        
        reachability.whenUnreachable = { [unowned self] _ in
            self.sendReachability()
        }
    }
}