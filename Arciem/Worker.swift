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

public enum WorkerState : String, CustomStringConvertible {
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

public class Worker : CustomStringConvertible {
    var task: WorkerBlock?
    var success: DispatchBlock?
    var failure: ErrorBlock?
    var finally: DispatchBlock?

    var state = Observable<WorkerState>(.Ready)
    var id: Int
    var error: NSError?
    
    public init() {
        self.id = _Worker_nextID++
    }

    public var description: String {
    get {
        return "Worker \(id)"
    }
    }
}

public class WorkerManager {
    let queue: DispatchQueue
    var workers = NSMutableSet()
    let serializer = Serializer(name: "WorkerManager Serializer")
    
    public init(queue: DispatchQueue) {
        self.queue = queue
        print("\(self) init")
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    public func addWorker(worker: Worker) {
        serializer.dispatch { [weak self] in
            assert(worker.state^ == .Ready, "worker is not ready")
            self?.workers.addObject(worker)
            worker.state =^ .Queueing
            dispatchOn(queue: self!.queue) {
                if(worker.state^ != .Canceled) {
                    worker.state =^ .Executing
                    worker.task?(manager: self!)
                }
            }
        }
    }
    
    func done(worker: Worker, error: NSError? = nil) {
        serializer.dispatch { [unowned self] in
            if let err = error {
                worker.state =^ .Failure
                worker.error = err
                worker.failure?(error: err)
            } else {
                worker.state =^ .Success
                worker.success?()
            }
            worker.finally?()
            self.workers.removeObject(worker)
        }
    }
}

public class DummyWorker : Worker {
//    let delay: NSTimeInterval
    
    public override init() {
        super.init()
        task = { [unowned self] (unowned manager) in
            _ = dispatchOnBackground(afterDelay: 1.0) {
                manager.done(self, error: nil)
            }
        }
    }
}

var workerManager: WorkerManager!
public func testWorker() {
    workerManager = WorkerManager(queue: backgroundQueue)
    
    let worker = DummyWorker()
    
    worker.state.addObservance(Observer(didChange: { newValue in
        print("\(worker) \(newValue)")
        }, willChange: nil, didInitialize: nil))
    workerManager.addWorker(worker)
    
    dispatchOnMain(afterDelay: 5) {
        workerManager = nil
    }
}
