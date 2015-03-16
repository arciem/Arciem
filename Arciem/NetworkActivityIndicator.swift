//
//  NetworkActivityIndicator.swift
//  Arciem
//
//  Created by Robert McNally on 10/23/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    #elseif os(OSX)
    import Cocoa
#endif

private var _networkActivityIndicator = NetworkActivityIndicator()

public class NetworkActivityIndicator {
    private let hysteresis: Hysteresis
    
    private init() {
        hysteresis = Hysteresis(effectStart: {
            #if os(iOS)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            #endif
        }, effectEnd: {
            #if os(iOS)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            #endif
        }, effectStartLag: 0.0, effectEndLag: 0.2)
    }
    
    public class func instance() -> NetworkActivityIndicator {
        return _networkActivityIndicator
    }
    
    public func makeActivity() -> Activity {
        return Activity(parent: self)
    }
    
    public class Activity {
        private let cause: Hysteresis.Cause
        
        private init(parent: NetworkActivityIndicator) {
            cause = parent.hysteresis.makeCause()
        }
    }
}
