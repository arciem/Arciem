//
//  JSON.swift
//  Arciem
//
//  Created by Robert McNally on 6/13/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public let jsonMIMEType = "application/json"
public typealias JSONObject = AnyObject
public typealias JSONDict = [String: AnyObject]

public class JSON {
    public class func objectForResource(name: String) -> (NSError?, JSONObject?) {
        var error: NSError?
        var jsonObject: JSONObject?
        
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        if path == nil {
            error = NSError("Could not find JSON resource: \(name)")
        } else {
            let jsonData = NSData(contentsOfFile:path!)
            if jsonData == nil {
                error = NSError("Could not load data from file: \(path)")
            } else {
                (error, jsonObject) = objectWithData(jsonData!)
            }
        }
        
        return (error, jsonObject)
    }
    
    public class func dataWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> (NSError?, NSData?) {
        var error: NSError?
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(0)
        let jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: options, error: &error)
        assert(jsonData != nil, "Could not generate JSON data from object: \(error)")
        return (error, jsonData)
    }
    
    public class func bytesWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> (NSError?, [Byte]?) {
        let (error, data) = dataWithObject(obj, prettyPrinted: prettyPrinted)
        var bytes: [Byte]?
        if error == nil {
            bytes = data!.toByteArray()
        }
        return (error, bytes)
    }
    
    public class func stringWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> (NSError?, String?) {
        let (error, bytes) = bytesWithObject(obj, prettyPrinted: prettyPrinted)
        var string: String?
        if error == nil {
            string = stringFromUTF8Bytes(bytes!)
        }
        return (error, string)
    }
    
    public class func objectWithData(data: NSData) -> (NSError?, JSONObject?) {
        var error: NSError?
        var jsonObject: JSONObject?
        jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
        return (error, jsonObject)
    }
    
    public class func objectWithBytes(bytes: [Byte]) -> (NSError?, JSONObject?) {
        return objectWithData(NSData(byteArray: bytes))
    }
    
    public class func objectWithString(string: String) -> (NSError?, JSONObject?) {
        return objectWithBytes(string.toUTF8Bytes())
    }
}