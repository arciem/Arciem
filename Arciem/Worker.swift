//
//  Worker.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public typealias WorkerBlock = (manager: WorkerManager) -> Void

private var _Worker_nextID = 0
var workerLogger : Logger? = Logger(tag: "WORKER", enabled: true)

public enum WorkerState : String {
    case Ready = "Ready"
    case Queueing = "Queueing"
    case Canceled = "Canceled"
    case Executing = "Executing"
    case Success = "Success"
    case Failure = "Failure"
}

extension WorkerState : CustomStringConvertible {
    public var description: String {
        get {
            return self.rawValue
        }
    }
}

public class Worker {
    public let id: Int
    public var task: WorkerBlock?
    public var 😄: DispatchBlock?   // "success"
    public var 😡: ErrorBlock?      // "failure"
    public var 😎: DispatchBlock?   // "finally"

    public var state = ObservableValue(WorkerState.Ready)
    public var 🚫: ErrorType?

    var log: Logger? { get { return workerLogger } }

    public init() {
        self.id = _Worker_nextID++
        log?.trace("\(self) init")
    }
    
    deinit {
        log?.trace("\(self) deinit")
    }
}

extension Worker : CustomStringConvertible {
    public var description: String {
        get {
            return "\(typeNameOf(self)) <id:\(id)>"
        }
    }
}

extension Worker : Equatable {
}

public func ==(🅛: Worker, 🅡: Worker) -> Bool {
    return 🅛 === 🅡
}

extension Worker : Hashable {
    public var hashValue: Int { get {
        return id
    }}
}
