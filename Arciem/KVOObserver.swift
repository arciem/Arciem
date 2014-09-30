//
//  KVOObserver.swift
//  Arciem
//
//  Created by Robert McNally on 6/10/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public typealias KVOChangeDictionary = [NSObject : AnyObject]
public typealias KVOObserverCallback = (value: AnyObject?, object: AnyObject, change: KVOChangeDictionary) -> ()

public extension NSKeyValueChange {
    public static func kindForChange(changeDict: KVOChangeDictionary) -> NSKeyValueChange {
        let raw = UInt(changeDict[NSKeyValueChangeKindKey]!.integerValue)
        return NSKeyValueChange(rawValue: raw)!
    }
    
    public static func isPriorForChange(changeDict: KVOChangeDictionary) -> Bool {
        let n: NSNumber? = changeDict[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber
        return n?.boolValue == true
    }
    
    public static func newValueForChange(changeDict: KVOChangeDictionary) -> AnyObject? {
        return changeDict[NSKeyValueChangeNewKey]
    }
    
    public static func oldValueForChange(changeDict: KVOChangeDictionary) -> AnyObject? {
        return changeDict[NSKeyValueChangeOldKey]
    }
}

public class KVOObserver : NSObject {
    let object: COpaquePointer
    let keyPath: String
    let didChange: KVOObserverCallback?
    let willChange: KVOObserverCallback?
    let initial: KVOObserverCallback?
    
    public init(object: NSObject, keyPath: String, didChange: KVOObserverCallback?, willChange: KVOObserverCallback? = nil, initial: KVOObserverCallback? = nil) {
        self.object = Unmanaged.passUnretained(object).toOpaque()
        self.keyPath = keyPath
        self.didChange = didChange
        self.willChange = willChange
        self.initial = initial

        super.init()

        var options = NSKeyValueObservingOptions(0)
        if didChange != nil { options = options | .New }
        if willChange != nil { options = options | .Prior; options = options | .Old }
        if initial != nil { options = options | .Initial; options = options | .New }

        object.addObserver(self, forKeyPath: keyPath, options: options, context: nil)
    }

    deinit {
        Unmanaged<NSObject>.fromOpaque(object).takeUnretainedValue().removeObserver(self, forKeyPath: keyPath, context: nil)
    }

    public class func indexesForChangeDictionary(changeDict: NSDictionary) -> NSIndexSet? {
        return changeDict[NSKeyValueChangeIndexesKey] as? NSIndexSet
    }

    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: KVOChangeDictionary, context: UnsafeMutablePointer<()>) {
        if NSKeyValueChange.isPriorForChange(change) {
            willChange?(value: change[NSKeyValueChangeOldKey], object: object, change: change)
        } else if NSKeyValueChange.oldValueForChange(change) != nil && NSKeyValueChange.kindForChange(change) == .Setting {
            initial?(value: NSKeyValueChange.newValueForChange(change), object: object, change: change)
        } else {
            didChange?(value: NSKeyValueChange.newValueForChange(change), object: object, change: change)
        }
    }
}

public class KVOTestObj : NSObject, Printable {
    var s: NSString!
    var observer: KVOObserver!
    
    public init(_ s: String) {
        self.s = s
        
        super.init()
        println("\(s) init")
        
        observer = KVOObserver(object: self, keyPath: "s",
            didChange: { newValue, _, _ in
                println("s did change to \(newValue)")
            },
            willChange: { oldValue, _, _ in
                println("s will change from \(oldValue)")
            },
            initial: { initialValue, _, _ in
                println("s initial value \(initialValue)")
            })
        
        t()
        self.setValue("A000", forKey: "s")
    }
    
    func t() {
        s = "A1"
    }
    
    deinit {
        println("\(s) deinit")
    }
    
    public override var description: String {
    get {
        return "\(super.description) \(s)"
    }
    }
}

public func testKVOObserver() {
    var obj: KVOTestObj! = KVOTestObj("A")
    obj.s = "A2"
    obj.s = "A3"
    obj = nil
    println("done")
}
