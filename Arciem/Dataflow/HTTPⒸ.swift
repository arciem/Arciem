//
//  HTTPⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/19/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}

public let HTTPErrorDomain = "HTTPErrorDomain"

public let HTTPⒸErrorDomain = "HTTPⒸErrorDomain"

public enum HTTPⒸError: Int {
    case MIMETypeMismatch
}

public class HTTPⒸ : Component {
    public typealias InPortⓉ = InPort<HTTPRequestⓋ>
    public typealias OutPortⓉ = OutPort<HTTPResponseⓋ>
    
    public private(set) var inRequest🅟: InPortⓉ!
    public private(set) var outResponse🅟: OutPortⓉ!
    
    public var allowUntrustedCertificate = false
    
    public init(_ name: String?, _ component: Component?) {
        super.init(name: name ?? "HTTP", component)
        
        outResponse🅟 = OutPortⓉ("outResponse", self)
        inRequest🅟 = InPortⓉ("inRequest", self) { [unowned self] 📫 in
            switch 📫 {
            case .😡(let 🚫):
                self.outResponse🅟.🅥 = 🎁(🚫: 🚫)
            case .😄(let 💌):
                let request🅥 = 💌⬆️
                let request: NSURLRequest = request🅥.request
                
                let sessionDelegate = SessionDelegate()
                sessionDelegate.allowUntrustedCertificate = self.allowUntrustedCertificate
                
                let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: sessionDelegate, delegateQueue: nil)
                var networkActivity: NetworkActivityIndicator.Activity? = NetworkActivityIndicator.instance().makeActivity()
                
                let sessionTask = session.dataTaskWithRequest(request) { (data: NSData!, response🅐: NSURLResponse!, 🚫: NSError!) -> Void in
                    if 🚫 != nil {
                        self.outResponse🅟.🅥 = 🎁(🚫: 🚫)
                    } else {
                        let response = response🅐 as! NSHTTPURLResponse
                        
                        var response🅥 = HTTPResponseⓋ()
                        response🅥.request = request
                        response🅥.body = data
                        response🅥.response = response
                        
                        var 🚫: NSError?
                        
                        if response.MIMEType == JSONMIMEType {
                            switch JSON.createWithData(data) {
                            case .😄(let 📫):
                                response🅥.json = 📫⬆️
                            case .😡(let 🚫2):
                                🚫 = 🚫2
                            }
                        }
                        
                        if 🚫 == nil {
                            if let expectedMIMEType = request🅥.expectedMIMEType, mimeType = response.MIMEType {
                                if mimeType != expectedMIMEType {
                                    🚫 = NSError(domain: HTTPⒸErrorDomain, code: HTTPⒸError.MIMETypeMismatch.rawValue, localizedDescription: "Expected MIME Type: \(expectedMIMEType), got:\(mimeType).")
                                }
                            }
                        }
                        
                        if 🚫 == nil {
                            let statusCode = response.statusCode
                            switch statusCode {
                            case 200...299:
                                break
                            default:
                                🚫 = NSError(domain: HTTPErrorDomain, code: statusCode, localizedDescription: NSHTTPURLResponse.localizedStringForStatusCode(statusCode))
                            }
                        }
                        
                        if let 🚫 = 🚫 {
                            self.outResponse🅟.🅥 = 🎁(🚫: 🚫)
                        } else {
                            self.outResponse🅟.🅥 = 🎁(response🅥)
                        }
                    }
                    networkActivity = nil
                }
                sessionTask.resume()
            }
        }
    }
    
    private class SessionDelegate : NSObject, NSURLSessionDelegate {
        var allowUntrustedCertificate = false
        func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if(allowUntrustedCertificate) {
                    let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
                    completionHandler(.UseCredential, credential)
                } else {
                    completionHandler(.PerformDefaultHandling, nil)
                }
            } else {
                completionHandler(.PerformDefaultHandling, nil)
            }
        }
    }
}
