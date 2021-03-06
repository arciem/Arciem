//
//  HTTPWorker.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public class HTTPWorker : Worker {
    public let request: NSURLRequest
    public let session: NSURLSession
    public var data: NSData?
    public var httpResponse: NSHTTPURLResponse!
    public var json: AnyObject?
    var networkActivity: NetworkActivityIndicator.Activity?
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
    
    public class func stringForStatusCode(statusCodeOpt: Int?) -> String? {
        var s: String?
        if let statusCode = statusCodeOpt {
            let statusCodeString = NSHTTPURLResponse.localizedStringForStatusCode(statusCode)
            s = "\(statusCode) \(statusCodeString)"
        }
        return s
    }
    
    public var statusCodeString : String {
        get {
            return self.dynamicType.stringForStatusCode(self.httpResponse.statusCode)!
        }
    }

    public init(request: NSURLRequest, allowUntrustedCertificate: Bool = false) {
        self.request = request
        self.sessionDelegate = SessionDelegate()
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: self.sessionDelegate, delegateQueue: nil)
        super.init()
        self.allowUntrustedCertificate = allowUntrustedCertificate
        self.task = { [unowned self] (manager: WorkerManager) -> Void in
            self.networkActivity = NetworkActivityIndicator.instance().makeActivity()
            self.sessionTask = self.session.dataTaskWithRequest(self.request, completionHandler: { (data: NSData?, responseOpt: NSURLResponse?, 🚫: NSError?) -> Void in
                self.data = data
                self.httpResponse = responseOpt as? NSHTTPURLResponse
                if 🚫 != nil {
                    self.🚫 = 🚫
                } else {
                    if self.httpResponse.MIMEType == JSONMIMEType {
                        var jsonError: ErrorType?
                        do {
                            self.json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                        } catch {
                            jsonError = error
                            self.json = nil
                        }
                        if jsonError != nil {
                            self.🚫 = jsonError!
                        }
                    }
                    
                    if 🚫 == nil {
                        let statusCode = self.httpResponse.statusCode
                        if !(200...299 ~= statusCode) {
                            let httpError = NSError(domain: HTTPErrorDomain, code: statusCode, localizedDescription: self.statusCodeString)
                            self.🚫 = httpError
                        }
                    }
                }
                manager.workerDone(self)
                self.networkActivity = nil
            })
            self.sessionTask.resume()
        }
    }
    
    class SessionDelegate : NSObject, NSURLSessionDelegate {
        var allowUntrustedCertificate = false
        func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if(allowUntrustedCertificate) {
                    let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
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
