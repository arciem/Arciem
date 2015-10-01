//
//  LoggerⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

private var logger: Logger? = Logger(tag: "DFLOG")

public class LoggerⒸ: Component {
    public typealias InStringPortⓉ = InPort<String>
    
    public var inString🅟: InStringPortⓉ!
    
    public init(_ name: String?, _ component: Component?) {
        logTags.insert("DFLOG")
        
        super.init(name: name ?? "Logger", component)
        
        inString🅟 = InStringPortⓉ("inString", self, inPlug: { 📫 in
            📫
                ★ { 💌 in logger?.info(💌) }
                † { 🚫 in logger?.error(🚫) }
                ‡ { };
            return
        })
    }
}
