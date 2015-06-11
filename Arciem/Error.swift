//
//  Error.swift
//  Arciem
//
//  Created by Robert McNally on 10/21/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public var AppErrorDomain = "AppErrorDomain"

extension NSError {
    public convenience init(domain: String, code: Int, localizedDescription: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    public convenience init(_ localizedDescription: String) {
        self.init(domain: AppErrorDomain, code: 1, localizedDescription: localizedDescription)
    }
}

public struct Error {
    public let error: NSError
    
    public init(_ error: NSError) {
        self.error = error
    }
    
    public init(_ localizedDescription: String) {
        self.error = NSError(localizedDescription)
    }
    
    public init(domain: String, code: Int, localizedDescription: String) {
        self.error = NSError(domain: domain, code: code, localizedDescription: localizedDescription)
    }
    
    public var localizedDescription : String {
        return error.localizedDescription
    }
}

extension Error : CustomStringConvertible {
    public var description: String { return error.description }
}