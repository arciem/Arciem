//
//  JSON.swift
//  Arciem
//
//  Created by Robert McNally on 6/13/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public let JSONErrorDomain = "JSONErrorDomain"
public let JSONMIMEType = "application/json"
public typealias JSONObject = AnyObject
public typealias JSONDictionary = [String: JSONObject]
public typealias JSONArray = [JSONObject]

public enum JSONErrorCode : Int {
    case UnsupportedType = 1
    case IndexOutOfBounds
    case WrongType
    case DoesNotExist
}

public enum JSONType : Swift.String {
    case Number = "Number"
    case String = "String"
    case Bool = "Bool"
    case Array = "Array"
    case Dictionary = "Dictionary"
    case Null = "Null"
}

enum JSONObjCType : String {
    case Bool = "c"
    case Int = "q"
    case Float = "f"
    case Double = "d"
}

public func jsonTypeForObject(object: AnyObject) -> Result<JSONType> {
    var jsonType: JSONType?
    
    switch object {
    case let n as NSNumber:
        if let s = String.fromCString(object.objCType), objCType = JSONObjCType(rawValue: s) {
            switch objCType {
            case .Bool:
                jsonType = .Bool
            case .Int, .Float, .Double:
                jsonType = .Number
            }
        }
    case let s as NSString:
        jsonType = .String
    case let a as NSArray:
        jsonType = .Array
    case let d as NSDictionary:
        jsonType = .Dictionary
    case let n as NSNull:
        jsonType = .Null
    default:
        break
    }
    
    if let jsonType = jsonType {
        return Result(jsonType)
    } else {
        return .Error(NSError(domain: JSONErrorDomain, code: JSONErrorCode.UnsupportedType.rawValue, localizedDescription: "Unsupported JSON type for: \(object)"))
    }
}

public struct JSON {
    public private(set) var object: JSONObject
    
    public init(_ object: JSONObject) {
        self.object = object
    }
}

// Mark: - Creation & Serialization

let JSONDefaultReadingOptions: NSJSONReadingOptions = .AllowFragments

extension JSON {
    public static func createWithData(data: NSData, options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> Result<JSON> {
        var error: NSError?
        var object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error)
        if let error = error {
            return .Error(error)
        } else {
            return Result(JSON(object!))
        }
    }
    
    public static func createWithBytes(bytes: [UInt8], options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> Result<JSON> {
        return createWithData(NSData(byteArray: bytes), options: options)
    }
    
    public static func createWithString(string: String, options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> Result<JSON> {
        return createWithBytes(string.toUTF8Bytes(), options: options)
    }
    
    public static func createFromResource(name: String, options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> Result<JSON> {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        if path == nil {
            let error = NSError("Could not find JSON resource: \(name)")
            return .Error(error)
        } else {
            let jsonData = NSData(contentsOfFile:path!)
            if jsonData == nil {
                return .Error(NSError("Could not load data from file: \(path)"))
            } else {
                return createWithData(jsonData!)
            }
        }
    }
    
    public func rawData(prettyPrinted: Bool = false) -> Result<NSData> {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(0)
        var error: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(object, options: options, error: &error)
        if let error = error {
            return .Error(error)
        }
        return Result(jsonData!)
    }
    
    public func rawBytes(prettyPrinted: Bool = false) -> Result<[UInt8]> {
        return rawData(prettyPrinted: prettyPrinted) → { data in data.toByteArray() }
    }
    
    public func rawString(prettyPrinted: Bool = false) -> Result<String> {
        var result: Result<String>!
        rawBytes(prettyPrinted: prettyPrinted)
            ★ { bytes in
                if let s = stringFromUTF8Bytes(bytes) {
                    result = Result(s)
                } else {
                    result = .Error(NSError("Could not convert bytes to string using UTF8"))
                }
            }
            † { error in
                result = .Error(error)
        }
        return result
    }
}

// MARK: - Type Info

extension JSON {
    public var type: Result<JSONType> {
        get {
            return jsonTypeForObject(object)
        }
    }
    
    private func isType(type: JSONType) -> Bool {
        var r: Bool = false
        self.type ★ { r = $0 == type }
        return r
    }
    
    public var isNumber: Bool { return isType(.Number) }
    public var isBool: Bool { return isType(.Bool) }
    public var isString: Bool { return isType(.String) }
    public var isArray: Bool { return isType(.Array) }
    public var isDictionary: Bool { return isType(.Dictionary) }
    public var isNull: Bool { return isType(.Null) }
}


// MARK: - Getting Values

extension JSON {
    public var int: Int { get { return object as! Int } set { object = newValue } }
    public var float: Float { get { return object as! Float } set { object = newValue } }
    public var double: Double { get { return object as! Double } set { object = newValue } }
    public var number: Double { get { return object as! Double } set { object = newValue } }
    public var bool: Bool { get { return object as! Bool } set { object = newValue } }
    public var string: String { get { return object as! String } set { object = newValue } }
    public var array: JSONArray { get { return object as! JSONArray } set { object = newValue } }
    public var dictionary: JSONDictionary { get { return object as! JSONDictionary } set { object = newValue } }
    
    public var intValue: Int? { return (object as? NSNumber)?.integerValue }
    public var floatValue: Float? { return (object as? NSNumber)?.floatValue }
    public var doubleValue: Double? { return (object as? NSNumber)?.doubleValue }
    public var numberValue: Double? { return (object as? NSNumber)?.doubleValue }
    public var boolValue: Bool? { return isBool ? (object as? NSNumber)?.boolValue : nil }
    public var arrayValue: JSONArray? { return object as? JSONArray }
    public var dictionaryValue: JSONDictionary? { return object as? JSONDictionary }
}

// MARK: - Sequence

extension JSON : SequenceType {
    public var isEmpty: Bool {
        get {
            var answer: Bool = true
            type ★ { type in
                switch type {
                case .Array:
                    answer = self.array.isEmpty
                case .Dictionary:
                    answer = self.dictionary.isEmpty
                default:
                    break
                }
            }
            return answer
        }
    }
    
    public var count: Int {
        get {
            var answer: Int = 0
            type ★ { type in
                switch type {
                case .Array:
                    answer = self.array.count
                case .Dictionary:
                    answer = self.dictionary.count
                default:
                    break
                }
            }
            return answer
        }
    }
    
    public func generate() -> GeneratorOf<(String, JSON)> {
        var answer = GeneratorOf<(String, JSON)> { return nil }
        type ★ { type in
            switch type {
            case .Array:
                var g = self.array.generate()
                var i = 0
                answer = GeneratorOf<(String, JSON)> {
                    if let element: AnyObject = g.next() {
                        return ("\(i++)", JSON(element))
                    } else {
                        return nil
                    }
                }
            case .Dictionary:
                var g = self.dictionary.generate()
                answer = GeneratorOf<(String, JSON)> {
                    if let(k: String, v: JSONObject) = g.next() {
                        return (k, JSON(v))
                    } else {
                        return nil
                    }
                }
            default:
                break
            }
        }
        return answer
    }
}

// MARK: - Subscript

public protocol JSONSubscriptType {}
extension Int: JSONSubscriptType {}
extension String: JSONSubscriptType {}
public typealias JSONPath = [JSONSubscriptType]

extension JSON {
    private subscript(#index: Int) -> JSON? {
        get {
            return JSON(array[index])
        }
        set {
            var a = array
            a[index] = newValue!.object
            object = a
        }
    }
    
    private subscript(#key: String) -> JSON? {
        get {
            if let value: JSONObject = dictionary[key] {
                return JSON(value)
            } else {
                return nil
            }
        }
        set {
            var d = dictionary
            d[key] = newValue!.object
            object = d
        }
    }
    
    private subscript(#sub: JSONSubscriptType) -> JSON? {
        get {
            if sub is String {
                return self[key: sub as! String]
            } else {
                return self[index: sub as! Int]
            }
        }
        set {
            if sub is String {
                self[key: sub as! String] = newValue!
            } else {
                self[index: sub as! Int] = newValue!
            }
        }
    }
    
    public subscript(path: JSONPath) -> JSON? {
        get {
            var next: JSON?
            if path.count > 0 {
                next = self
                for pathElement in path {
                    next = next![sub: pathElement]
                    if next == nil {
                        break
                    }
                }
            }
            return next
        }
    }
}

func testJSON() {
    var jsonResult: Result<JSON>!
    JSON.createWithString("[4, [10, 20, 30], {\"A\": 100, \"B\": 200}]")
        ★ { json in
            let j: JSONObject = json[[2, "B"]]!.object
            println("value: \(j)")
        }
        ‡ { result in
            jsonResult = result
            println("Goodbye.")
        }
    println("jsonResult: \(jsonResult)")
}

/*
public typealias JSONObject = Any
public typealias JSONDictionary = [String: AnyObject]

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
        return Result(jsonData!)
    }
    
    public class func bytesWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> Result<[UInt8]> {
        return dataWithObject(obj, prettyPrinted: prettyPrinted) ¿ { data in data.toByteArray() }
    }
    
    public class func stringWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> Result<String> {
        return bytesWithObject(obj, prettyPrinted: prettyPrinted) ¿ { bytes in
            if let s = stringFromUTF8Bytes(bytes) {
                return Result(s)
            } else {
                return .Error(NSError("Could not convert bytes to string using UTF8"))
            }
        }
    }
    
    public class func objectWithData(data: NSData) -> Result<JSONObject> {
        var error: NSError?
        var jsonObject: JSONObject?
        jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
        if error == nil {
            return Result(jsonObject!)
        } else {
            return .Error(error!)
        }
    }
    
    public class func objectWithBytes(bytes: [UInt8]) -> Result<JSONObject> {
        return objectWithData(NSData(byteArray: bytes))
    }
    
    public class func objectWithString(string: String) -> Result<JSONObject> {
        return objectWithBytes(string.toUTF8Bytes())
    }
}
*/