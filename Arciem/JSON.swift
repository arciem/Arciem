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

public func jsonTypeForObject(object: AnyObject) -> JSONType? {
    var type: JSONType?
    
    switch object {
    case _ as NSNumber:
        if let s = String.fromCString(object.objCType), objCType = JSONObjCType(rawValue: s) {
            switch objCType {
            case .Bool:
                type = .Bool
            case .Int, .Float, .Double:
                type = .Number
            }
        }
    case _ as NSString:
        type = .String
    case _ as NSArray:
        type = .Array
    case _ as NSDictionary:
        type = .Dictionary
    case _ as NSNull:
        type = .Null
    default:
        break
    }
    
    return type
}

public struct JSON: DataflowⓋ {
    public static let null = JSON(NSNull())
    
    public var type: JSONType
    public var object: JSONObject
    
    public init(_ object: JSONObject) {
        self.object = object
        if let type = jsonTypeForObject(object) {
            self.type = type
        } else {
            fatalError("Unsupported JSON type for object: \(object)")
        }
    }
    
    public init() {
        self.init(NSNull())
    }
}

// Mark: - Creation & Serialization

let JSONDefaultReadingOptions: NSJSONReadingOptions = .AllowFragments

extension JSON {
    public static func createWithData(data: NSData, options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> 🎁<JSON> {
        var 🚫: NSError?
        var object: AnyObject?
        do {
            object = try NSJSONSerialization.JSONObjectWithData(data, options: options)
        } catch let error as NSError {
            🚫 = error
            object = nil
        }
        if let 🚫 = 🚫 {
            return .😡(🚫)
        } else {
            return 🎁(JSON(object!))
        }
    }
    
    public static func createWithBytes(bytes: [UInt8], options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> 🎁<JSON> {
        return createWithData(NSData(byteArray: bytes), options: options)
    }
    
    public static func createWithString(string: String, options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> 🎁<JSON> {
        return createWithBytes(string.toUTF8Bytes(), options: options)
    }
    
    public static func createFromResource(name: String, options: NSJSONReadingOptions = JSONDefaultReadingOptions) -> 🎁<JSON> {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        if path == nil {
            let 🚫 = NSError("Could not find JSON resource: \(name)")
            return .😡(🚫)
        } else {
            let jsonData = NSData(contentsOfFile:path!)
            if jsonData == nil {
                return .😡(NSError("Could not load data from file: \(path)"))
            } else {
                return createWithData(jsonData!)
            }
        }
    }
    
    public func rawData(prettyPrinted: Bool = false) -> 🎁<NSData> {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        var 🚫: NSError?
        let jsonData: NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(object, options: options)
        } catch let error as NSError {
            🚫 = error
            jsonData = nil
        }
        if let 🚫 = 🚫 {
            return .😡(🚫)
        }
        return 🎁(jsonData!)
    }
    
    public func rawBytes(prettyPrinted prettyPrinted: Bool = false) -> 🎁<[UInt8]> {
        return rawData(prettyPrinted) → { data in data.toByteArray() }
    }
    
    public func rawString(prettyPrinted prettyPrinted: Bool = false) -> 🎁<String> {
        var result: 🎁<String>!
        rawBytes(prettyPrinted: prettyPrinted)
            ★ { bytes in
                if let s = stringFromUTF8Bytes(bytes) {
                    result = 🎁(s)
                } else {
                    result = .😡(NSError("Could not convert bytes to string using UTF8"))
                }
            }
            † { 🚫 in
                result = .😡(🚫)
        }
        return result
    }
}

// MARK: - Type Info

extension JSON {
    public var isNumber: Bool { return type == .Number }
    public var isBool: Bool { return type == .Bool }
    public var isString: Bool { return type == .String }
    public var isArray: Bool { return type == .Array }
    public var isDictionary: Bool { return type == .Dictionary }
    public var isNull: Bool { return type == .Null }
}


// MARK: - Getting Values

extension JSON {
    public var int: Int { get { return object as! Int } mutating set { object = newValue } }
    public var float: Float { get { return object as! Float } mutating set { object = newValue } }
    public var double: Double { get { return object as! Double } mutating set { object = newValue } }
    public var number: Double { get { return object as! Double } mutating set { object = newValue } }
    public var nsNumber: NSNumber { return object as! NSNumber }
    public var bool: Bool { get { return object as! Bool } mutating set { object = newValue } }
    public var string: String { get { return object as! String } mutating set { object = newValue } }
    public var array: JSONArray { get { return object as! JSONArray } mutating set { object = newValue } }
    public var nsArray: NSArray { return object as! NSArray }
    public var dictionary: JSONDictionary { get { return object as! JSONDictionary } mutating set { object = newValue } }
    public var nsDictionary: NSDictionary { return object as! NSDictionary }
    public var url: NSURL { get { return NSURL(string: self.string)! } mutating set { string = newValue.path! } }
    public var data: NSData { get { return fromBase64(string)! } mutating set { string = toBase64(data) } }
    public var bytes: [UInt8] { get { return fromBase64(string)! } mutating set { string = toBase64(newValue) } }
    
    public var intValue: Int? { return (object as? NSNumber)?.integerValue }
    public var floatValue: Float? { return (object as? NSNumber)?.floatValue }
    public var doubleValue: Double? { return (object as? NSNumber)?.doubleValue }
    public var numberValue: Double? { return (object as? NSNumber)?.doubleValue }
    public var boolValue: Bool? { return isBool ? (object as? NSNumber)?.boolValue : nil }
    public var arrayValue: JSONArray? { return object as? JSONArray }
    public var dictionaryValue: JSONDictionary? { return object as? JSONDictionary }
    public var urlValue: NSURL? { return isString ? NSURL(string: string) : nil }
    public var dataValue: NSData? { get { return isString ? fromBase64(string) : nil } }
    public var bytesValue: [UInt8]? { get { return isString ? fromBase64(string) : nil } }
    
    public var json: JSON {
        get {
            switch JSON.createWithString(string) {
            case .😄(let 📫):
                return 📫
            case .😡(let 🚫):
                fatalError("parsing JSON: \(🚫.localizedDescription)")
            }
        }
        
        mutating set {
            switch newValue.rawString() {
            case .😄(let 📫):
                object = 📫
            case .😡(let 🚫):
                fatalError("creating JSON: \(🚫.localizedDescription)")
            }
        }
    }
    
    public var jsonValue: JSON? {
        get {
            if isString {
                switch JSON.createWithString(string) {
                case .😄(let 📫):
                    return 📫
                case .😡:
                    return nil
                }
            } else {
                return nil
            }
        }
    }
}

// MARK: - Sequence

extension JSON : SequenceType {
    public var isEmpty: Bool {
        get {
            var answer: Bool = true
            switch type {
            case .Array:
                answer = self.array.isEmpty
            case .Dictionary:
                answer = self.dictionary.isEmpty
            default:
                break
            }
            return answer
        }
    }
    
    public var count: Int {
        get {
            var answer: Int = 0
            switch type {
            case .Array:
                answer = self.array.count
            case .Dictionary:
                answer = self.dictionary.count
            default:
                break
            }
            return answer
        }
    }
    
    public func generate() -> AnyGenerator<(String, JSON)> {
        var answer: AnyGenerator<(String, JSON)>
        switch type {
        case .Array:
            var g = self.array.generate()
            var i = 0
            answer = anyGenerator {
                if let element: AnyObject = g.next() {
                    return ("\(i++)", JSON(element))
                } else {
                    return nil
                }
            }
        case .Dictionary:
            var g = self.dictionary.generate()
            answer = anyGenerator {
                if let(k, v): (String, JSONObject) = g.next() {
                    return (k, JSON(v))
                } else {
                    return nil
                }
            }
        default:
            answer = anyGenerator { return nil }
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
    private subscript(index index: Int) -> JSON {
        get {
            let array_ = self.object as! [AnyObject]
            return JSON(array_[index])
        }
        set {
            var array_ = self.object as! [AnyObject]
            array_[index] = newValue.object
            self.object = array_
        }
    }
    
    private subscript(key key: String) -> JSON {
        get {
            if let object_: AnyObject = self.object[key] {
                return JSON(object_)
            } else {
                return JSON.null
            }
        }
        set {
            var dictionary_ = self.object as! [String : AnyObject]
            dictionary_[key] = newValue.object
            self.object = dictionary_
        }
    }

    private subscript(sub sub: JSONSubscriptType) -> JSON {
        get {
            if sub is String {
                return self[key:sub as! String]
            } else {
                return self[index:sub as! Int]
            }
        }
        set {
            if sub is String {
                self[key:sub as! String] = newValue
            } else {
                self[index:sub as! Int] = newValue
            }
        }
    }
    /**
    Find a json in the complex data structuresby using the Int/String's array.
    
    - parameter path: The target json's path. Example:
    
    let json = JSON[data]
    let path = [9,"list","person","name"]
    let name = json[path]
    
    The same as: let name = json[9]["list"]["person"]["name"]
    
    - returns: Return a json found by the path or a null json with error
    */
    public subscript(path: [JSONSubscriptType]) -> JSON {
        get {
            if path.count == 0 {
                return JSON.null
            }
            
            var next = self
            for sub in path {
                next = next[sub:sub]
            }
            return next
        }
        set {
            switch path.count {
            case 0: return
            case 1: self[sub:path[0]] = newValue
            default:
                var last = newValue
                var newPath = path
                newPath.removeLast()
                for sub in Array(path.reverse()) {
                    var previousLast = self[newPath]
                    previousLast[sub:sub] = last
                    last = previousLast
                    if newPath.count <= 1 {
                        break
                    }
                    newPath.removeLast()
                }
                self[sub:newPath[0]] = last
            }
        }
    }
    
    /**
    Find a json in the complex data structuresby using the Int/String's array.
    
    - parameter path: The target json's path. Example:
    
    let name = json[9,"list","person","name"]
    
    The same as: let name = json[9]["list"]["person"]["name"]
    
    - returns: Return a json found by the path or a null json with error
    */
    public subscript(path: JSONSubscriptType...) -> JSON {
        get {
            return self[path]
        }
        set {
            self[path] = newValue
        }
    }

    //    private subscript(#index: Int) -> JSON? {
//        get {
//            return JSON(array[index])
//        }
//        set {
//            updateValue(newValue!.object, forIndex: index)
//        }
//    }
//    
//    private subscript(#key: String) -> JSON? {
//        get {
//            if let value: JSONObject = dictionary[key] {
//                return JSON(value)
//            } else {
//                return nil
//            }
//        }
//        set {
//            updateValue(newValue!.object, forKey: key)
//        }
//    }
    
//    public subscript(key: String) -> JSONObject? {
//        get {
//            if let value: JSONObject = dictionary[key] {
//                return value
//            } else {
//                return nil
//            }
//        }
//        set {
//            updateValue(newValue!, forKey: key)
//        }
//    }
    
//    private subscript(#sub: JSONSubscriptType) -> JSON? {
//        get {
//            if sub is String {
//                if let value: JSONObject = valueForKey(sub as! String) {
//                    return JSON(value)
//                } else {
//                    return nil
//                }
//            } else {
//                if let value: JSONObject = valueForIndex(sub as! Int) {
//                    return JSON(value)
//                } else {
//                    return nil
//                }
//            }
//        }
//        set {
//            if sub is String {
//                updateValue(newValue!.object, forKey:(sub as! String))
//            } else {
//                updateValue(newValue!.object, forIndex:(sub as! Int))
//            }
//        }
//    }
//
//    public subscript(sub: JSONSubscriptType) -> JSON? {
//        get {
//            return self[sub: sub]
//        }
//        set {
//            self[sub: sub] = newValue!
//        }
//    }
//    
//    public subscript(sub: JSONSubscriptType) -> JSONObject? {
//        get {
//            if let j = self[sub: sub] {
//                return j.object
//            } else {
//                return nil
//            }
//        }
//        set {
//            if let newValue: JSONObject = newValue {
//                self[sub: sub] = JSON(newValue)
//            } else {
//                self[sub: sub] = nil
//            }
//        }
//    }

    
//    private subscript(#path: JSONPath) -> JSON? {
//        get {
//            return self[sub: path[0]]
//        }
//        set {
//            self[sub: path[0]] = newValue!
//        }
//    }
    
//    public subscript(path: JSONSubscriptType...) -> JSONObject? {
//        get {
//            if let j = self[sub: path[0]] {
//                return j.object
//            } else {
//                return nil
//            }
//        }
//        set {
//            if let newValue: JSONObject = newValue {
//                self[sub: path[0]] = JSON(newValue)
//            } else {
//                self[sub: path[0]] = nil
//            }
//        }
//    }

//    public subscript(sub: JSONSubscriptType) -> JSONObject? {
//        get {
//            if sub is String {
//                if let value: JSONObject = valueForKey(sub as! String) {
//                    return value
//                } else {
//                    return nil
//                }
//            } else {
//                if let value: JSONObject = valueForIndex(sub as! Int) {
//                    return value
//                } else {
//                    return nil
//                }
//            }
//        }
//        mutating set {
//            if sub is String {
//                updateValue(newValue!, forKey:(sub as! String))
//            } else {
//                updateValue(newValue!, forIndex:(sub as! Int))
//            }
//        }
//    }
//
//    private func lastElementOfPath(path: JSONPath) -> JSON? {
//        var next: JSON? = self
//        if path.count > 0 {
//            for pathElement in path {
//                next = next![sub: pathElement]
//                if next == nil {
//                    break
//                }
//            }
//        }
//        return next
//    }
//    
//    private subscript(#path: JSONPath) -> JSON? {
//        get {
//            return lastElementOfPath(path)
//        }
//        
//        set {
//            if path.count > 0 {
//                let subToModify: JSONSubscriptType = path.last!
//                var pathToElemToModify: JSONPath = path; pathToElemToModify.removeLast()
//                var elemToModify: JSON = lastElementOfPath(pathToElemToModify)!
//                elemToModify[sub:subToModify] = newValue!
//            }
//        }
//    }
//
//    public subscript(path: JSONSubscriptType...) -> JSON? {
//        get {
//            return self[path:path]
//        }
//        
//        set {
//            self[path:path] = newValue
//        }
//    }
//    
//    public subscript(path: JSONSubscriptType...) -> JSONObject? {
//        get {
//            return self[path:path]?.object
//        }
//        
//        set {
//            self[path:path] = JSON(newValue!)
//        }
//    }
}

// MARK: - LiteralConvertible

extension JSON: StringLiteralConvertible {
    public init(stringLiteral value: StringLiteralType) { self.init(value) }
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) { self.init(value) }
    public init(unicodeScalarLiteral value: StringLiteralType) { self.init(value) }
}

extension JSON: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) { self.init(value) }
}

extension JSON: BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) { self.init(value) }
}

extension JSON: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) { self.init(value) }
}

extension JSON: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, JSONObject)...) {
        var dict = [String : JSONObject]()
        for (key, value) in elements { dict[key] = value }
        self.init(dict)
    }
}

extension JSON: ArrayLiteralConvertible {
    public init(arrayLiteral elements: JSONObject...) { self.init(elements) }
}

extension JSON: NilLiteralConvertible {
    public init(nilLiteral: ()) { self.init(NSNull()) }
}

// MARK: - Equatable

extension JSON: Equatable { }

public func ==(🅛: JSON, 🅡: JSON) -> Bool {
    
    switch (🅛.type, 🅡.type) {
    case (.Number, .Number):
        return 🅛.nsNumber == 🅡.nsNumber
    case (.String, .String):
        return 🅛.string == 🅡.string
    case (.Bool, .Bool):
        return 🅛.bool == 🅡.bool
    case (.Array, .Array):
        return 🅛.nsArray == 🅡.nsArray
    case (.Dictionary, .Dictionary):
        return 🅛.nsDictionary == 🅡.nsDictionary
    case (.Null, .Null):
        return true
    default:
        return false
    }
}

// MARK: - Printable

extension JSON: CustomStringConvertible {
    public var description: String {
        switch rawString(prettyPrinted: true) {
        case .😄(let 📫):
            return "JSON: \(📫)"
        case .😡(let 🚫):
            return "Converting JSON to string: \(🚫.localizedDescription)"
        }
    }
}

// MARK: - Tests

//func testJSON() {
//    var json🎁: 🎁<JSON>!
//    JSON.createWithString("[4, [10, 20, 30], {\"A\": 100, \"B\": 200}]")
//        ★ { json in
//            let j: JSONObject = json[[2, "B"]]!.object
//            println("value: \(j)")
//        }
//        ‡ { }
//    println("json🎁: \(json🎁)")
//}

/*
public typealias JSONObject = Any
public typealias JSONDictionary = [String: AnyObject]

public class JSON {
    public class func objectForResource(name: String) -> 🎁<JSONObject> {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        if path == nil {
            let 🚫 = NSError("Could not find JSON resource: \(name)")
            return .Error(🚫)
        } else {
            let jsonData = NSData(contentsOfFile:path!)
            if jsonData == nil {
                return .Error(NSError("Could not load data from file: \(path)"))
            } else {
                return objectWithData(jsonData!)
            }
        }
    }
    
    public class func dataWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> 🎁<NSData> {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(0)
        var 🚫: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: options, 🚫: &🚫)
        if let 🚫 = 🚫? {
            return .Error(🚫)
        }
        return 🎁(jsonData!)
    }
    
    public class func bytesWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> 🎁<[UInt8]> {
        return dataWithObject(obj, prettyPrinted: prettyPrinted) ¿ { data in data.toByteArray() }
    }
    
    public class func stringWithObject(obj: JSONObject, prettyPrinted: Bool = false) -> 🎁<String> {
        return bytesWithObject(obj, prettyPrinted: prettyPrinted) ¿ { bytes in
            if let s = stringFromUTF8Bytes(bytes) {
                return 🎁(s)
            } else {
                return .Error(NSError("Could not convert bytes to string using UTF8"))
            }
        }
    }
    
    public class func objectWithData(data: NSData) -> 🎁<JSONObject> {
        var 🚫: NSError?
        var jsonObject: JSONObject?
        jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), 🚫: &🚫)
        if 🚫 == nil {
            return 🎁(jsonObject!)
        } else {
            return .Error(🚫!)
        }
    }
    
    public class func objectWithBytes(bytes: [UInt8]) -> 🎁<JSONObject> {
        return objectWithData(NSData(byteArray: bytes))
    }
    
    public class func objectWithString(string: String) -> 🎁<JSONObject> {
        return objectWithBytes(string.toUTF8Bytes())
    }
}
*/