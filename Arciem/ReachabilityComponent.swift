//
//  ReachabilityComponent.swift
//  Arciem
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class ReachabilityⒸ : Component {
    public typealias OutStringPortⓉ = OutPort<String>
    public var outString🅟: OutStringPortⓉ!

    public typealias OutStatusPortⓉ = OutPort<Reachability.NetworkStatus>
    public var outStatus🅟: OutStatusPortⓉ!

    private let reachability: Reachability
    
    public var enabled: Bool = false {
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
        outString🅟.send(reachability.currentReachabilityString)
    }

    public init(_ name: String?, _ component: Component?, hostname: String) {
        reachability = Reachability(hostname: hostname)

        super.init(name: name ?? "Reachability", component)
        
        outString🅟 = OutStringPortⓉ("outString", self)
        outStatus🅟 = OutStatusPortⓉ("outStatus", self)

        reachability.whenReachable = { [unowned self] _ in
            self.sendReachability()
        }
        
        reachability.whenUnreachable = { [unowned self] _ in
            self.sendReachability()
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}