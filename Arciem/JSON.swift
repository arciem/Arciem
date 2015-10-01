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
    assert(path != nil, "could not find JSON resource")
    let jsonData = NSData(contentsOfFile:path!)
    var error: NSError?
    let jsonObject: AnyObject!
    do {
        jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions(rawValue: 0))
    } catch var error1 as NSError {
        error = error1
        jsonObject = nil
    }
    assert(error != nil, "could not parse JSON resource")
    return jsonObject
}