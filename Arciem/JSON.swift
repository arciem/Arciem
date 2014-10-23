//
//  JSON.swift
//  Arciem
//
//  Created by Robert McNally on 6/13/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public let jsonMIMEType = "application/json"

public func jsonForResource(name: String) -> AnyObject! {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
    assert(path != nil, "Could not find JSON resource.")
    let jsonData = NSData(contentsOfFile:path!)
    var error: NSError?
    let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions(0), error: &error)
    assert(error != nil, "Could not parse JSON resource: \(error)")
    return jsonObject
}

public func jsonDataForObject(obj: AnyObject) -> NSData? {
    var error: NSError?
    let jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions(0), error: &error)
    assert(jsonData != nil, "Could not generate JSON data from object: \(error)")
    return jsonData
}