//
//  WorkerManager.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

var workerManagerLogger : Logger? = Logger(tag: "WORKER_MANAGER", enabled: true)

public class WorkerManager {
    let workQueue: DispatchQueue
    let callbackQueue: DispatchQueue
    var workers = Set<Worker>()
    let serializer = Serializer(name: "WorkerManager Serializer")
    
    var log: Logger? { get { return workerManagerLogger } }
    
    public init(workQueue: DispatchQueue, callbackQueue: DispatchQueue) {
        self.workQueue = workQueue
        self.callbackQueue = callbackQueue
        log?.trace("\(identifierOf(self)) init")
    }
    
    public convenience init() {
        self.init(workQueue: backgroundQueue, callbackQueue: mainQueue)
    }
    
    deinit {
        log?.trace("\(identifierOf(self)) deinit")
    }
    
    public func addWorker(worker: Worker) {
        serializer.dispatch { [unowned self] in
            assert(worker.state == .Ready, "worker is not ready")
            self.workers.add(worker)
            worker.state =^ .Queueing
            dispatchOn(queue: self.workQueue) {
                if(worker.state != .Canceled) {
                    worker.state =^ .Executing
                    worker.task?(manager: self)
                }
            }
        }
    }
    
    public func cancelWorker(worker: Worker) {
        serializer.dispatch {
            worker.state =^ .Canceled
            self.workers.remove(worker)
        }
    }
    
    func workerDone(worker: Worker, error: NSError? = nil) {
        serializer.dispatch { [unowned self] in
            self.workers.remove(worker)
            if(worker.state != .Canceled) {
                dispatchOn(queue: self.callbackQueue) {
                    if(worker.state != .Canceled) {
                        if let err = error {
                            worker.state =^ .Failure
                            worker.error = err
                            worker.failure?(error: err)
                        } else {
                            worker.state =^ .Success
                            worker.success?()
                        }
                        worker.finally?()
                    }
                }
            }
        }
    }
}

public class DummyWorker : Worker {

    public override init() {
        super.init()
        task = { [unowned self] (unowned manager) in
            _ = dispatchOnBackground(afterDelay: 1.0) {
                manager.workerDone(self, error: nil)
            }
        }
    }
}

var workerManager: WorkerManager!
public func testWorker() {
    workerManager = WorkerManager()
    
    let worker = DummyWorker()

    worker.state.addObserver(Observer(didChange: { newValue in
        println("\(worker) \(newValue)")
        }))
    workerManager.addWorker(worker)
    
    dispatchOnMain(afterDelay: 5) {
        workerManager = nil
    }
}
