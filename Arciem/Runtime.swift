//
//  Runtime.swift
//  Arciem
//
//  Created by Robert McNally on 6/11/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public func setAssociatedObject(#object: NSObject, #key: NSString, #value: NSObject?) {
    setAssociatedObject_glue(object, key, value)
}

public func getAssociatedObject(#object: NSObject, #key: NSString) -> NSObject? {
    return getAssociatedObject_glue(object, key)
}
