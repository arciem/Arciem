//
//  Device.swift
//  Arciem
//
//  Created by Robert McNally on 6/9/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

public class Device {
    public static let isPhone =  UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
    public static let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
    public static let isPortrait = UIApplication.sharedApplication().statusBarOrientation.isPortrait
    public static let isLandscape = UIApplication.sharedApplication().statusBarOrientation.isLandscape
    public static let screenScale = UIScreen.mainScreen().scale
    public static let isHiDPI = screenScale > 1.0
    public static func isOSVersionAtLeast(minVerStr: String) -> Bool {
        let currSysVer = UIDevice.currentDevice().systemVersion
        return currSysVer.compare(minVerStr, options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    public static let documentDirectoryPath = (NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as! [NSURL]).last!
    public static let orientationsPadAllPhonePortrait = Int(interfaceOrientationMaskValue_glue(isPad ? UIInterfaceOrientationMask.All : UIInterfaceOrientationMask.Portrait))
    public static let orientationsPadAllPhoneAllButUpsideDown = Int(interfaceOrientationMaskValue_glue(isPad ? UIInterfaceOrientationMask.All : UIInterfaceOrientationMask.AllButUpsideDown))
}
