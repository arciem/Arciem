//
//  JSONToStringⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/18/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class JSONToStringⒸ : Component {
    public private(set) var inJSON🅟: InPort<JSON>!
    public private(set) var outString🅟: OutPort<String>!
    public var prettyPrint: Bool = false
    
    public init(_ name: String?, _ component: Component?) {
        super.init(name: name ?? "JSONToString", component)
        outString🅟 = OutPort("outString", self)
        inJSON🅟 = InPort("inJSON", self) { [unowned self] 🅥 in
            switch 🅥 {
            case .😄(let 📫):
                switch 📫⬆️.rawString(prettyPrinted: self.prettyPrint) {
                case .😄(let 📫):
                    self.outString🅟.🅥 = 🎁(📫⬆️)
                case .😡(let 🚫):
                    self.outString🅟.🅥 = 🎁(🚫: 🚫)
                }
                break
            case .😡(let 🚫):
                self.outString🅟.🅥 = 🎁(🚫: 🚫)
            }
        }
    }
}