//
//  Port.swift
//  Arciem
//
//  Created by Robert McNally on 2/16/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class PortⒶ {
    public let name: String
    public weak var component: Component?
    
    let serial = Serializer()
    
    init(_ name: String, _ component: Component) {
        self.name = name
        self.component = component
        dfLogger?.trace("init \(self)")
    }
    
    deinit {
        dfLogger?.trace("deinit \(self)")
    }
}

public class Port<🍒: DataflowⓋ>: PortⒶ {
    public let oid = OID()
    private var _🅥: 🎁<🍒>
    public var 🅥: 🎁<🍒> {
        get {
            return serial.dispatchWithReturn { [unowned self] in
                return self._🅥
            }
        }
        
        set {
            serial.dispatch { [unowned self] in
                let equals: Bool
                
                switch (self._🅥, newValue) {
                case (.😄(let 📫1), .😄(let 📫2)):
                    let 💌1 = 📫1
                    let 💌2 = 📫2
                    equals = 💌1 == 💌2
                case (.😡(let 🚫1), .😡(let 🚫2)):
                    equals = 🚫1.code == 🚫2.code && 🚫1.domain == 🚫2.domain
                default:
                    equals = false
                }
                
                if !equals {
                    if let dfLogger = dfLogger {
                        let parentComponentName = self.component?.component?.name ?? "TOP"
                        dfLogger.debug("NEW VALUE: \(parentComponentName).\(self.component?.name).\(self.name) = \(newValue)")
                    }
                    self._🅥 = newValue
                    self.🅥DidChange(newValue)
                }
            }
        }
    }
    
    // serialized
    func 🅥DidChange(newValue: 🎁<🍒>) { }
    
    public override init(_ name: String, _ component: Component) {
        _🅥 = 🎁(🍒())
        super.init(name, component)
    }
}

extension Port: CustomStringConvertible {
    public var description: String {
        get {
            return "\(oid): Port '\(name)' in '\(component?.name)'"
        }
    }
}
