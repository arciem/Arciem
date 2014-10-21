//
//  HTTPWorker.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}

public class HTTPWorker : Worker {
    public let request: NSURLRequest
    public let session: NSURLSession
    public var data: NSData?
    public var response: NSHTTPURLResponse?
    public var json: AnyObject?
    var sessionTask: NSURLSessionDataTask!
    let sessionDelegate: SessionDelegate
    
    public var allowUntrustedCertificate: Bool {
        get {
            return sessionDelegate.allowUntrustedCertificate
        }
        set {
            sessionDelegate.allowUntrustedCertificate = newValue
        }
    }
    
    public init(request: NSURLRequest) {
        self.request = request
        self.sessionDelegate = SessionDelegate()
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: self.sessionDelegate, delegateQueue: nil)
        super.init()
        self.task = { [unowned self] (unowned manager: WorkerManager) -> Void in
            self.sessionTask = self.session.dataTaskWithRequest(self.request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                self.data = data
                self.response = response as? NSHTTPURLResponse
                self.error = error
                if error == nil {
                    if(response.MIMEType == jsonMIMEType) {
                        self.json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: &self.error)
                    }
                }
                manager.workerDone(self, error: error)
            })
            self.sessionTask.resume()
        }
    }
    
    class SessionDelegate : NSObject, NSURLSessionDelegate {
        var allowUntrustedCertificate = false
        func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if(allowUntrustedCertificate) {
                    let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
                    completionHandler(.UseCredential, credential)
                } else {
                    completionHandler(.PerformDefaultHandling, nil)
                }
            }
        }
    }
}
