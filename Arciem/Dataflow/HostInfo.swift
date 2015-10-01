//
//  HostInfo.swift
//  Arciem
//
//  Created by Robert McNally on 2/20/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public struct HostInfo {
    public let scheme: String
    public let host: String
    public let port: Int?
    
    public init(scheme: String, host: String, port: Int? = nil) {
        self.scheme = scheme
        self.host = host
        self.port = port
    }
}

public struct URLComposer {
    public var hostInfo: HostInfo!
    public var pathComponents: [String]
    public var queryElements: [String : Any]
    
    public var url: NSURL {
        get {
            let path: String
            if pathComponents.count > 0 {
                path = "/" + pathComponents.joinWithSeparator("/")
            } else {
                path = "/"
            }
            
            let query: String
            if queryElements.count > 0 {
                query = "?" + joinKeysToValues("=", dict: queryElements).joinWithSeparator("&")
            } else {
                query = ""
            }
            
            let pathAndQuery = path + query

            let host = hostInfo.host
            
            let port: String
            if let p = hostInfo.port {
                port = ":\(p)"
            } else {
                port = ""
            }
            
            let hostAndPort = host + port
            
            return NSURL(scheme: hostInfo.scheme, host: hostAndPort, path: pathAndQuery)!
        }
    }
    
    public init() {
        pathComponents = [String]()
        queryElements = [String: Any]()
    }
    
    public init(hostInfo: HostInfo, pathComponents: [String] = [String](), queryElements: [String: Any] = [String: Any]()) {
        self.hostInfo = hostInfo
        self.pathComponents = pathComponents
        self.queryElements = queryElements
    }
}