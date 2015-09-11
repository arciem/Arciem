//
//  String.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

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
    
    public func toUTF8Bytes() -> [UInt8] {
        var a = [UInt8]()
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
    
    public func toData() -> NSData {
        return NSData(byteArray: toUTF8Bytes())
    }

    public subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    public func truncatedAtLength(maxLength: Int, ellipsis: String = "…") -> String {
        let length = self.characters.count
        let ellipsisLength = ellipsis.characters.count
        let truncLength = max(0, maxLength - ellipsisLength)
        let realMaxLength = min(length, truncLength)
        var t = self[0..<realMaxLength]
        if realMaxLength == truncLength {
            t += ellipsis
        }
        return t
    }
}

public func stringFromUTF8Bytes(bytes: [UInt8]) -> String? {
    return NSString(bytes: bytes, length: bytes.count, encoding: NSUTF8StringEncoding) as? String
}

public func stringFromUTF8Data(data: NSData) -> String? {
    return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
}

public func hexStringFromByte(byte: UInt8) -> String {
    return NSString(format: "0x%02x", byte) as String
}

public func hexStringFromBytes(bytes: [UInt8]) -> String {
    var strings = [String]()
    for byte in bytes {
        strings.append(hexStringFromByte(byte))
    }
    let s = strings.joinWithSeparator(", ")
    return "[\(s)]"
}

public func joinKeysToValues<🍒, 🍋>(separator: String, dict: [🍒 : 🍋]) -> [String] {
    var a = [String]()
    for (key, value) in dict {
        a.append(["\(key)", "\(value)"].joinWithSeparator(separator))
    }
    return a
}

public func macRomanToUnicodeString(s: String) -> String {
    let s1 = s as NSString
    let len = s1.lengthOfBytesUsingEncoding(NSMacOSRomanStringEncoding)
    let s2: String
    if len > 0 {
        let d = s1.dataUsingEncoding(NSMacOSRomanStringEncoding)!
        s2 = d.toString()!
    } else {
        s2 = s
    }
    return s2
}

