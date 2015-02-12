//
//  Connection.swift
//  Arciem
//
//  Created by Robert McNally on 2/6/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class Connection {
    private lazy var queue = PacketQueue()
    weak private var tail: OutputPort?
    weak private var head: InputPort?
    
    convenience init(tail: OutputPort, head: InputPort) {
        self.init()
        connect(tail: tail, head: head)
    }
    
    func connect(#tail: OutputPort, head: InputPort) {
        assert(self.tail == nil, "Connection tail is already bound.")
        assert(self.head == nil, "Connection head is already bound.")
        self.tail = tail
        self.head = head
        tail.addConnection(self)
        head.addConnection(self)
    }
    
    func send(packet: Packet) {
        if let head = head {
            if head.synchronous {
                head.receive?(packet)
            } else {
                queue.add(packet)
                dispatchOnBackground() {
                    var packet = self.queue.remove()
                    head.receive?(packet)
                }
            }
        }
    }
    
    deinit {
        dataflowLogger?.trace("deinit \(self)")
    }
}
