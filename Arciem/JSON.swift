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
    public class func objectForResource(name: String) -> Result<JSONObject> {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        if path == nil {
            let error = NSError("Could not find JSON resource: \(name)")
            return .Error(error)
        } else {
            let jsonData = NSData(contentsOfFile:path!)
            if jsonData == nil {
                return .Error(NSError("Could not load data from file: \(path)"))
            } else {
                return objectWithData(jsonData!)
            }
        }
    }
    
    public class func dataWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> Result<NSData> {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(0)
        var error: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: options, error: &error)
        if let error = error? {
            return .Error(error)
        }
        return Result(value: jsonData!)
    }
    
    public class func bytesWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> Result<[Byte]> {
        switch dataWithObject(obj, prettyPrinted: prettyPrinted) {
        case .Value(let v):
            return Result(value: v.unbox.toByteArray())
        case .Error(let e):
            return .Error(e)
        default:
            return .None
        }
    }
    
    public class func stringWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> Result<String> {
        let bytes = bytesWithObject(obj, prettyPrinted: prettyPrinted)
        switch bytes {
        case .Value(let v):
            if let s = stringFromUTF8Bytes(v.unbox) {
                return Result(value: s)
            } else {
                return .Error(NSError("Could not convert bytes to string using UTF8"))
            }
        case .Error(let e):
            return .Error(e)
        default:
            return .None
        }
    }
    
    public class func objectWithData(data: NSData) -> Result<JSONObject> {
        var error: NSError?
        var jsonObject: JSONObject?
        jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
        if error == nil {
            return Result(value: jsonObject!)
        } else {
            return .Error(error!)
        }
    }
    
    public class func objectWithBytes(bytes: [Byte]) -> Result<JSONObject> {
        return objectWithData(NSData(byteArray: bytes))
    }
    
    public class func objectWithString(string: String) -> Result<JSONObject> {
        return objectWithBytes(string.toUTF8Bytes())
    }
}