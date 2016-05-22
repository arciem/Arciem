//
//  TypedJSON.swift
//  Arciem
//
//  Created by Robert McNally on 2/19/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct TypedJSON {
    public var json: JSON
    
    public init(json: JSON, expectedType: String?) {
        self.json = json
        if let expectedType = expectedType {
            assert(type == expectedType, "expected type: \(expectedType) got:\(type)")
        }
    }
    
    public init(type: String) {
        json = JSON(["type" : type])
    }
    
    public var type: String {
        get { return json["type"].string }
        set { json["type"] = JSON(newValue) }
    }
}

extension TypedJSON : CustomStringConvertible {
    public var description: String {
        get {
            return ""
//            return "\(identifierOfType(self)) \(json.dictionary)"
        }
    }
}
