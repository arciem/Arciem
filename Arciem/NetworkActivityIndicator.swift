//
//  NetworkActivityIndicator.swift
//  Arciem
//
//  Created by Robert McNally on 10/23/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

private var _networkActivityIndicator = NetworkActivityIndicator()

public class NetworkActivityIndicator {
    private let hysteresis: Hysteresis
    
    private init() {
        hysteresis = Hysteresis(effectStart: {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }, effectEnd: {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
