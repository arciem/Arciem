//
//  Log.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case Trace = 0
    case Debug
    case Info
    case Warn
    case Error
    case Fatal
}

extension LogLevel : Printable {
    public var description : String {
        get {
            switch self {
            case Trace: return "TRACE"
            case Debug: return "DEBUG"
            case Info: return "INFO"
            case Warn: return "WARN"
            case Error: return "ERROR"
            case Fatal: return "FATAL"
            }
        }
    }
}

var logSerializer = Serializer(name: "Log")
public var logLevel: LogLevel? = LogLevel.Info
public var logTags = Set<String>()
public var logDateFormatter: NSDateFormatter = {
    let f = NSDateFormatter()
    f.dateFormat = "yyyyMMdd hh:mm:ss.SSS"
    return f
}()

public func log(message: String, _ level: LogLevel? = .Info, _ tag: String? = nil) {
    if logLevel != nil {
        if level == nil || level!.rawValue >= logLevel!.rawValue {
            if tag == nil || logTags.contains(tag!) {
                let date = NSDate()
                logSerializer.dispatch() {
                    let d = logDateFormatter.stringFromDate(date)
                    var s = "[\(d)"
                    if let lev = level {
                        s += " \(lev)"
                    }
                    if let t = tag {
                        s += " \(t)"
                    }
                    s += "]"
                    println("\(s) \(message)")
                }
            }
        }
    }
}

public class Logger {
    public var tag: String? = nil
    
    public init?(tag: String? = nil, enabled: Bool = true) {
        if logLevel == nil || !enabled {
            return nil
        }
        if let t = tag {
            self.tag = tag
        }
    }
    
    public func trace(message: String) {
        log(message, .Trace, tag)
    }
    
    public func debug(message: String) {
        log(message, .Debug, tag)
    }
    
    public func info(message: String) {
        log(message, .Info, tag)
    }
    
    public func warn(message: String) {
        log(message, .Warn, tag)
    }
    
    public func error(message: String) {
        log(message, .Error, tag)
    }
    
    public func error(error err: NSError) {
        error(err.description)
    }
    
    public func fatal(message: String) {
        log(message, .Fatal, tag)
    }
    
    public func fatal(error: NSError) {
        fatal(error.description)
    }
}