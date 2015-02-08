//
//  Component.swift
//  Arciem
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

var dataflowLogger = Logger(tag: "DATAFLOW")

public class Component {
    private var inputPorts = [InputPort]()
    private var outputPorts = [OutputPort]()
    private var namedPorts = [String: Port]()
    
    func addInputPortNamed(name: String, synchronous: Bool, receive: ReceiveFunc) -> InputPort {
        let port = InputPort(synchronous: synchronous)
        port.name = name
        port.component = self
        port.receive = receive
        inputPorts.append(port)
        namedPorts[name] = port
        return port
    }
    
    func addOutputPortNamed(name: String, synchronous: Bool) -> OutputPort {
        let port = OutputPort(synchronous: synchronous)
        port.name = name
        port.component = self
        outputPorts.append(port)
        namedPorts[name] = port
        return port
    }
    
    public subscript(name: String) -> Port? {
        get {
            return namedPorts[name]
        }
    }
    
    deinit {
        dataflowLogger?.trace("deinit \(self)")
    }
}

public typealias TransformFunc = (Packet) -> Packet

public class TransformComponent : Component {
    public let inPort: InputPort!
    public let outPort: OutputPort!
    let transform: TransformFunc
    public init(synchronous: Bool, transform: TransformFunc) {
        self.transform = transform
        super.init()
        inPort = addInputPortNamed("in", synchronous: synchronous) { [unowned self] inPacket in
            let outPacket = transform(inPacket)
            self.outPort.send(outPacket)
        }
        outPort = addOutputPortNamed("out", synchronous: synchronous)
    }
}

public class NegateComponent : TransformComponent {
    public init() {
        super.init(synchronous: false, transform: { packet in
            packet → { json in JSON(-json.number) }
        })
    }
}
