//
//  WorkerManager.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public class WorkerManager {
    let queue: DispatchQueue
    var workers = NSMutableSet()
    let serializer = Serializer(name: "WorkerManager Serializer")
    
    public init(queue: DispatchQueue) {
        self.queue = queue
        println("\(self) init")
    }
    
    deinit {
        println("\(self) deinit")
    }
    
    public func addWorker(worker: Worker) {
        serializer.dispatch { [weak self] in
            assert(worker.state^ == WorkerState.Ready, "worker is not ready")
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
        println("\(worker) \(newValue)")
        }, willChange: nil, didInitialize: nil))
    workerManager.addWorker(worker)
    
    dispatchOnMain(afterDelay: 5) {
        workerManager = nil
    }
}
