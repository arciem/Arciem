//
//  Component.swift
//  Arciem
//
//  Created by Robert McNally on 2/17/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

var dfLogger = Logger(tag: "DATAFLOW")


public class Component {
    public let oid = OID()
    public let name: String
    public internal(set) weak var component: Component?
    var cables = [CableⒶ]()
    var components = [Component]()
    
    public func addCable<🍋: CableⒶ>(cable: 🍋) {
        cables.append(cable)
    }
    
    public func addComponent<🍒: Component>(component: 🍒) {
        components.append(component)
    }
    
    public init(name: String, _ component: Component? = nil) {
        self.name = name
        self.component = component
        component?.addComponent(self)
        dfLogger?.trace("init \(self)")
    }
    
    deinit {
        dfLogger?.trace("deinit \(self)")
    }
}

extension Component: Printable {
    public var description: String {
        get {
            if let component = component {
                return "\(oid): Component '\(name)' in '\(component.name)'"
            } else {
                return "\(oid): Component '\(name)' at top"
            }
        }
    }
}

public func +><🍇>(🅛: OutPort<🍇>, 🅡: InPort<🍇>) -> Cable<🍇> {
    return Cable(tail: 🅛, head: 🅡)
}

public class DFTransform💌Ⓒ<🍋: DataflowⓋ, 🍇: DataflowⓋ>: Component {
    public typealias InPortⓉ = InPort<🍋>
    public typealias OutPortⓉ = OutPort<🍇>
    
    public typealias TransformⒻ = (🍋) -> 🍇
    
    public private(set) var input: InPortⓉ!
    public private(set) var output: OutPortⓉ!
    
    public init(_ name: String?, _ component: Component?, transform: TransformⒻ) {
        super.init(name: name ?? "Transform💌", component)
        
        let inPlug: InPortⓉ.InPlugⒻ = { [unowned self] r in
            switch r {
            case .😄(let 📫):
                self.output.🅥 = 🎁(transform(📫⬆️))
            case .😡(let 🚫):
                self.output.🅥 = 🎁(🚫: 🚫)
            }
        }
        
        input = InPort("in", self, inPlug: inPlug)
        output = OutPort("out", self)
    }
}

public class DFTransform🎁Ⓒ<🍋: DataflowⓋ, 🍇: DataflowⓋ>: Component {
    public typealias InPortⓉ = InPort<🍋>
    public typealias OutPortⓉ = OutPort<🍇>
    
    public typealias TransformⓉ = (🎁<🍋>) -> 🎁<🍇>
    
    public private(set) var input: InPortⓉ!
    public private(set) var output: OutPortⓉ!
    
    public init(_ name: String?, _ component: Component?, transform: TransformⓉ) {
        super.init(name: name ?? "Transform🎁", component)
        
        let inPlug: InPortⓉ.InPlugⒻ = { [unowned self] 📫 in
            self.output.🅥 = transform(📫)
        }
        
        input = InPort("in", self, inPlug: inPlug)
        output = OutPort("out", self)
    }
}
