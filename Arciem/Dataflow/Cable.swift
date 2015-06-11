//
//  Cable.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class CableⒶ {
    public let oid = OID()
    public internal(set) weak var component: Component?
    
    init(component: Component) {
        self.component = component
        component.addCable(self)
        dfLogger?.trace("init \(self)")
    }
    
    deinit {
        dfLogger?.trace("deinit \(self)")
    }
}

public class Cable<🍒: DataflowⓋ>: CableⒶ {
    weak var tail: OutPort<🍒>?
    weak var head: InPort<🍒>?
    
    public init(tail: OutPort<🍒>, head: InPort<🍒>) {
        self.tail = tail
        self.head = head
        super.init(component: tail.component!)
        tail.addPlug() { [unowned self] result in
            let _ = dispatchOnBackground() {
                dfLogger?.debug("TRANSMIT: \(self)")
                self.head?.🅥 = result
            }
        }
    }
    
    public var headTailDescription: String {
        return "'\(tail?.component?.name).\(tail?.name)' --> '\(head?.component?.name).\(head?.name)'"
    }
}

extension Cable: CustomStringConvertible {
    public var description: String {
        get {
            return "\(oid): Cable in '\(component?.name)' (\(headTailDescription))"
        }
    }
}
