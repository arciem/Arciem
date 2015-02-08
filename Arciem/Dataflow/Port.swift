//
//  Port.swift
//  Arciem
//
//  Created by Robert McNally on 2/3/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public typealias ReceiveFunc = (Packet) -> Void

public class Port {
    private let serializer = Serializer()
    public var name: String? = nil
    public internal(set) weak var component: Component? = nil
    public internal(set) var connections = [Connection]()
    public let synchronous: Bool
    
    init(synchronous: Bool) {
        self.synchronous = synchronous
    }
    
    public func addConnection(connection: Connection) {
        serializer.dispatch() {
            assert((self.connections.filter() { $0 === connection }).isEmpty, "Port is already bound to connection.")
            self.connections.append(connection)
        }
    }
    
    deinit {
        dataflowLogger?.trace("deinit \(self)")
    }
}

public class InputPort: Port {
    public var receive: ReceiveFunc? = nil

    public override init(synchronous: Bool) {
        super.init(synchronous: synchronous)
    }
}
    
public class OutputPort: Port {
    public override init(synchronous: Bool) {
        super.init(synchronous: synchronous)
    }

    public func send(packet: Packet) {
        serializer.dispatch() {
            for connection in self.connections {
                connection.send(packet)
            }
        }
    }

    public func sendJSON(json: JSON) {
        send(Packet(json))
    }
    
    public func sendObject(obj: JSONObject) {
        sendJSON(JSON(obj))
    }
    
    public func sendError(err: NSError) {
        send(Packet(error: err))
    }
}

public class ResultPort: InputPort {
    public convenience init(synchronous: Bool = true, receive: ReceiveFunc) {
        self.init(synchronous: synchronous)
        self.receive = receive
    }
}

public class ParameterPort: OutputPort {
    public override init(synchronous: Bool = true) {
        super.init(synchronous: synchronous)
    }
}

public func ≈>(tail: OutputPort, head: InputPort) -> Connection {
    return Connection(tail: tail, head: head)
}

public func ≈>(obj: JSONObject, head: InputPort) -> Connection {
    let tail = ParameterPort()
    let connection = Connection(tail: tail, head: head)
    tail.sendObject(obj)
    return connection
}

public func ≈>(tail: OutputPort, receive: ReceiveFunc) -> Connection {
    let head = ResultPort(receive: receive)
    let connection = Connection(tail: tail, head: head)
    return connection
}
