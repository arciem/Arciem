//
//  WorkerManager.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

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
//        log?.trace("\(identifierOfObject(self)) init")
    }
    
    public convenience init() {
        self.init(workQueue: backgroundQueue, callbackQueue: mainQueue)
    }
    
    deinit {
//        log?.trace("\(identifierOfObject(self)) deinit")
    }
    
    public func addWorker(worker: Worker) {
        serializer.dispatch { [unowned self] in
            assert(worker.state.value as? WorkerState == WorkerState.Ready, "worker is not ready")
            self.workers.insert(worker)
            worker.state.value = WorkerState.Queueing
            dispatchOnQueue(self.workQueue) {
                if(worker.state.value as? WorkerState == WorkerState.Canceled) {
                    worker.state.value = WorkerState.Executing
                    worker.task?(manager: self)
                }
            }
        }
    }
    
    public func cancelWorker(worker: Worker) {
        serializer.dispatch {
            worker.state.value = WorkerState.Canceled
            self.workers.remove(worker)
        }
    }
    
    func workerDone(worker: Worker) {
        serializer.dispatch { [unowned self] in
            self.workers.remove(worker)
            if(worker.state.value as? WorkerState == WorkerState.Canceled) {
                dispatchOnQueue(self.callbackQueue) {
                    if(worker.state.value as? WorkerState == WorkerState.Canceled) {
                        if worker.🚫 != nil {
                            worker.state.value = WorkerState.Failure
                            worker.😡?(🚫: worker.🚫!)
                        } else {
                            worker.state.value = WorkerState.Success
                            worker.😄?()
                        }
                        worker.😎?()
                    }
                }
            }
        }
    }
}

public class DummyWorker : Worker {

    public override init() {
        super.init()
        task = { [unowned self] (manager) in
            _ = dispatchOnBackgroundAfterDelay(1.0) {
                manager.workerDone(self)
            }
        }
    }
}

var workerManager: WorkerManager!
public func testWorker() {
    workerManager = WorkerManager()
    
    let worker = DummyWorker()

    worker.state.addObserver(Observer(didChange: { newValue in
        print("\(worker) \(newValue)")
        }))
    workerManager.addWorker(worker)
    
    dispatchOnMainAfterDelay(5) {
        workerManager = nil
    }
}
