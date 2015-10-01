//
//  HTTPRequestⓋ.swift
//  Arciem
//
//  Created by Robert McNally on 2/19/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct HTTPRequestⓋ {
    public var method: HTTPMethod!
    public var urlComposer = URLComposer()
    public var expectedMIMEType: String?
    public var body: NSData?
    
    public var url: NSURL {
        get {
            return urlComposer.url
        }
    }
    
    public var request: NSURLRequest {
        get {
            let r = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
            r.HTTPMethod = method.rawValue
            r.HTTPBody = body
            
            return r
        }
    }
    
    public var bodyAsString: String {
        get { return body!.toString()! }
        set { body = newValue.toData() }
    }
    
    public var bodyAsJSON: JSON {
        get {
            if let data = body {
                switch JSON.createWithData(data) {
                case .😄(let 📫):
                    return 📫
                case .😡(let 🚫):
                    fatalError("Unable to convert body to JSON: \(🚫)")
                }
            } else {
                fatalError("No body to convert to JSON.")
            }
        }
        set {
            switch newValue.rawData() {
            case .😄(let 📫):
                body = 📫
            case .😡(let 🚫):
                fatalError("Unable to convert JSON to data: \(🚫)")
            }
        }
    }
    
    // Required for DataflowⓋ
    public init() {
        urlComposer = URLComposer()
    }
    
    public init(method: HTTPMethod, urlComposer: URLComposer, expectedMIMEType: String? = nil, body: NSData? = nil) {
        self.method = method
        self.urlComposer = urlComposer
        self.expectedMIMEType = expectedMIMEType
        self.body = body
    }
}

extension HTTPRequestⓋ: DataflowⓋ {
}

public func ==(🅛: HTTPRequestⓋ, 🅡: HTTPRequestⓋ) -> Bool { return false }
