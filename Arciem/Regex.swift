//
//  Regex.swift
//  Arciem
//
//  Created by Robert McNally on 6/11/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

// Regex matching operators

public func ~= (pattern: NSRegularExpression, str: String) -> Bool {
    return pattern.numberOfMatchesInString(str, options: [], range: NSRange(location: 0,  length: str.characters.count)) > 0
}

public func ~= (str: String, pattern: NSRegularExpression) -> Bool {
    return pattern.numberOfMatchesInString(str, options: [], range: NSRange(location: 0,  length: str.characters.count)) > 0
}

// Regex creation operator

prefix operator ~/ {}

prefix func ~/ (pattern: String) -> NSRegularExpression? {
    do {
        return try NSRegularExpression(pattern: pattern, options: [])
    } catch _ {
        return nil
    }
}

public func testRegex() -> Bool {
    let regex = ~/"\\wpple"
    let str = "Foo"
    
    return regex! ~= str
}
