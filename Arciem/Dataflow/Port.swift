//
//  Port.swift
//  Arciem
//
//  Created by Robert McNally on 2/3/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

typealias ReceiveFunc = (Packet) -> Void

class Port {
    var name: String
    var connection: Connection?
    
    init(name: String) {
        self.name = name
    }
}

class InputPort: Port {
    let receive: ReceiveFunc
    
    init(name: String, receive: ReceiveFunc) {
        self.receive = receive
        super.init(name: name)
    }
}

class OutputPort: Port  {
    override init(name: String) {
        super.init(name: name)
    }
    
    func send(packet: Packet) {
        connection?.send(packet)
    }
}

class Connection {
    var queue = [Packet]()
    var serializer: Serializer
    weak var tailPort: OutputPort?
    weak var headPort: InputPort?
    
    init() {
        self.serializer = Serializer(name: "Connection")
    }
    
    func send(packet: Packet) {
        queue.append(packet)
        serializer.dispatch {
            var packet: Packet = self.queue.removeAtIndex(0)
            self.headPort?.receive(packet)
        }
    }
}

class Component {
    var inputPorts = [InputPort]()
    var outputPorts = [OutputPort]()
    
    func addInputPortNamed(name: String, receive: ReceiveFunc) -> InputPort {
        let port = InputPort(name: name, receive: receive)
        inputPorts.append(port)
        return port
    }
    
    func addOutputPortNamed(name: String) -> OutputPort {
        let port = OutputPort(name: name)
        outputPorts.append(port)
        return port
    }
}

typealias TransformFunc = (Packet) -> Packet

class TransformComponent : Component {
    let input: InputPort!
    let output: OutputPort!
    let transform: TransformFunc
    init(transform: TransformFunc) {
        self.transform = transform
        super.init()
        input = addInputPortNamed("input") { [unowned self] inPacket in
            let outPacket: Packet = transform(inPacket)
            self.output.send(outPacket)
        }
        output = addOutputPortNamed("output")
    }
}
