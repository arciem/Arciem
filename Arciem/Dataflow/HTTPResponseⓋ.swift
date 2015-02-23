//
//  HTTPResponseⓋ.swift
//  Arciem
//
//  Created by Robert McNally on 2/19/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public struct HTTPResponseⓋ: DataflowⓋ {
    public var response: NSHTTPURLResponse
    public var request: NSURLRequest
    public var body: NSData?
    public var json: JSON?
    
    public var statusCode: Int {
        get { return response.statusCode }
    }
    
    public var bodyAsString: String {
        get { return body!.toString()! }
        set { body = newValue.toData() }
    }
    
    public init() {
        self.response = NSHTTPURLResponse()
        self.request = NSURLRequest()
        self.body = nil
    }
    
    public init(response: NSHTTPURLResponse, request: NSURLRequest, body: NSData? = nil) {
        self.response = response
        self.request = request
        self.body = body
    }
}

public func ==(🅛: HTTPResponseⓋ, 🅡: HTTPResponseⓋ) -> Bool { return false }
