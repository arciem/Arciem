//
//  UserDefaults.swift
//  Arciem
//
//  Created by Robert McNally on 6/9/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public var defaults = NSUserDefaults.standardUserDefaults()

public extension NSUserDefaults {
    public subscript (key: String) -> AnyObject? {
        get { return self.objectForKey(key) }
        set { self.setObject(newValue, forKey: key) }
    }
}