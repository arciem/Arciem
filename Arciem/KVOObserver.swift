//
//  KVOObserver.swift
//  Arciem
//
//  Created by Robert McNally on 6/10/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public typealias KVOChangeDictionary = [NSObject : AnyObject]
public typealias KVOObserverCallback = (value: AnyObject?, object: AnyObject?, change: KVOChangeDictionary?) -> ()

public extension NSKeyValueChange {
    public static func kindForChange(changeDict: KVOChangeDictionary!) -> NSKeyValueChange {
        let raw = UInt(changeDict[NSKeyValueChangeKindKey]!.integerValue)
        return NSKeyValueChange(rawValue: raw)!
    }
    
    public static func isPriorForChange(changeDict: KVOChangeDictionary!) -> Bool {
        let n: NSNumber? = changeDict[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber
        return n?.boolValue == true
    }
    
    public static func newValueForChange(changeDict: KVOChangeDictionary!) -> AnyObject? {
        return changeDict[NSKeyValueChangeNewKey]
    }
    
    public static func oldValueForChange(changeDict: KVOChangeDictionary!) -> AnyObject? {
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

        var options = NSKeyValueObservingOptions(rawValue: 0)
        if didChange != nil { options.insert(.New) }
        if willChange != nil { options.insert(.Prior); options.insert(.Old) }
        if initial != nil { options.insert(.Initial); options.insert(.New) }

        object.addObserver(self, forKeyPath: keyPath, options: options, context: nil)
    }

    deinit {
        Unmanaged<NSObject>.fromOpaque(object).takeUnretainedValue().removeObserver(self, forKeyPath: keyPath, context: nil)
    }

    public class func indexesForChangeDictionary(changeDict: NSDictionary) -> NSIndexSet? {
        return changeDict[NSKeyValueChangeIndexesKey] as? NSIndexSet
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if NSKeyValueChange.isPriorForChange(change) {
            willChange?(value: change?[NSKeyValueChangeOldKey], object: object, change: change)
        } else if NSKeyValueChange.oldValueForChange(change) != nil && NSKeyValueChange.kindForChange(change) == .Setting {
            initial?(value: NSKeyValueChange.newValueForChange(change), object: object, change: change)
        } else {
            didChange?(value: NSKeyValueChange.newValueForChange(change), object: object, change: change)
        }
    }
}

public class KVOTestObj : NSObject {
    var s: NSString!
    var observer: KVOObserver!
    
    public init(_ s: String) {
        self.s = s
        
        super.init()
        print("\(s) init")
        
        observer = KVOObserver(object: self, keyPath: "s",
            didChange: { newValue, _, _ in
                print("s did change to \(newValue)")
            },
            willChange: { oldValue, _, _ in
                print("s will change from \(oldValue)")
            },
            initial: { initialValue, _, _ in
                print("s initial value \(initialValue)")
            })
        
        t()
        self.setValue("A000", forKey: "s")
    }
    
    func t() {
        s = "A1"
    }
    
    deinit {
        print("\(s) deinit")
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
    print("done")
}
