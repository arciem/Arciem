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
    return pattern.numberOfMatchesInString(str, options: nil, range: NSRange(location: 0,  length: countElements(str))) > 0
}

public func ~= (str: String, pattern: NSRegularExpression) -> Bool {
    return pattern.numberOfMatchesInString(str, options: nil, range: NSRange(location: 0,  length: countElements(str))) > 0
}

// Regex creation operator

operator prefix ~/ {}

@prefix func ~/ (pattern: String) -> NSRegularExpression {
    return NSRegularExpression(pattern: pattern, options: nil, error: nil)
}

public func testRegex() {
    var regex = ~/"\\wpple"
    var str = "Foo"
    
    var b: Bool = regex ~= str
}