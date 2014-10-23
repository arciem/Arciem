//
//  String.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public extension String {
    // String already provides func toInt() -> Int?
    
    public func toFloat() -> Float? {
        let scanner = NSScanner(string: self)
        scanner.charactersToBeSkipped = NSCharacterSet.whitespaceCharacterSet()
        var val:Float = 0.0
        return scanner.scanFloat(&val) ? val : nil
    }
    
    public func toDouble() -> Double? {
        let scanner = NSScanner(string: self)
        scanner.charactersToBeSkipped = NSCharacterSet.whitespaceCharacterSet()
        var val:Double = 0.0
        return scanner.scanDouble(&val) ? val : nil
    }
    
    static let _tChars = NSCharacterSet(charactersInString: "YyTt")
    public func toBool() -> Bool {
        let scanner = NSScanner(string: self)
        scanner.charactersToBeSkipped = NSCharacterSet.whitespaceCharacterSet()
        return scanner.scanCharactersFromSet(String._tChars, intoString: nil)
    }
    
    public func toUTF8Bytes() -> [Byte] {
        var a = [Byte]()
        for c in self.utf8 {
            a.append(c)
        }
        return a
    }
    
    public func toCString() -> UnsafePointer<Int8> {
        return self.withCString() {
            return $0
        }
    }
    
    public static func fromUTF8Bytes(bytes: [Byte]) -> String? {
        return NSString(bytes: bytes, length: bytes.count, encoding: NSUTF8StringEncoding)
    }
    
    public static func fromUTF8Data(data: NSData) -> String? {
        return NSString(data: data, encoding: NSUTF8StringEncoding)
    }
}
