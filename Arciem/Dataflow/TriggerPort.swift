//
//  TriggerPort.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class TriggerPortⒶ<🍒: DataflowⓋ> : InPort<Bool> {
    public override init(_ name: String, _ component: Component, inPlug: InPlugⒻ) {
        let myPlug: InPlugⒻ = { 📫 in
            📫
                ★ { if $0 == true { inPlug(📫) } }
                † { 🚫 in inPlug(📫) }
        }
        super.init(name, component, inPlug: myPlug)
    }
}

public typealias TriggerPort = TriggerPortⒶ<Bool>
