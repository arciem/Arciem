//
//  OutPort.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class OutPort<🍒: DataflowⓋ> : Port<🍒> {
    public typealias OutPlugⒻ = (🎁<🍒>) -> Void
    private var _outPlugs = [OutPlugⒻ]()
    var outPlugs: [OutPlugⒻ] {
        get {
            return serial.dispatchWithReturn {
                return self._outPlugs
            }
        }
    }
    
    // serialized
    override func 🅥DidChange(newValue: 🎁<🍒>) {
        for outPlug in _outPlugs {
            outPlug(newValue)
        }
    }
    
    override public init(_ name: String, _ component: Component) {
        super.init(name, component)
    }
    
    public func addPlug(plug: OutPlugⒻ) {
        serial.dispatch() {
            self._outPlugs.append(plug)
        }
    }
    
    public func send(@autoclosure f:() -> 🍒) {
        if self.outPlugs.count > 0 {
            let 💌 = f()
            🅥 = 🎁(💌)
        }
    }
}
