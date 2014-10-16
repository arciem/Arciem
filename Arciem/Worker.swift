//
//  Worker.swift
//  Arciem
//
//  Created by Robert McNally on 6/12/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public typealias ErrorBlock = (error: NSError) -> Void
public typealias WorkerBlock = (manager: WorkerManager) -> Void

public enum WorkerState : String, Printable {
    case Ready = "Ready"
    case Queueing = "Queueing"
    case Canceled = "Canceled"
    case Executing = "Executing"
    case Success = "Success"
    case Failure = "Failure"
    
    public var description: String {
    get {
        return self.rawValue
    }
    }
}

var _Worker_nextID: Int = 0

public class Worker : Printable {
    let id: Int
    var state = ObservableValue<WorkerState>(.Ready)
    var error: NSError?

    var task: WorkerBlock?
    var success: DispatchBlock?
    var failure: ErrorBlock?
    var finally: DispatchBlock?
    
    public init() {
        self.id = _Worker_nextID++
    }

    public var description: String {
    get {
        return "Worker \(id)"
    }
    }
}

