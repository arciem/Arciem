//
//  JSON.swift
//  Arciem
//
//  Created by Robert McNally on 6/13/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public func jsonForResource(name: String) -> AnyObject! {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
    assert(path, "could not find JSON resource")
    let jsonData = NSData(contentsOfFile:path)
    var error: NSError?
    let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(0), error: &error)
    assert(!error, "could not parse JSON resource")
    return jsonObject
}