//
//  Device.swift
//  Arciem
//
//  Created by Robert McNally on 6/9/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

public let isPhone = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
public let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad

public var isPortrait: Bool {
get { return UIApplication.sharedApplication().statusBarOrientation.isPortrait }
}

public var isLandscape: Bool {
get { return UIApplication.sharedApplication().statusBarOrientation.isLandscape }
}

var _screenScale: CGFloat = 0.0
public var screenScale: CGFloat {
get {
    if _screenScale == 0.0 {
        _screenScale = UIScreen.mainScreen().scale
    }
    return _screenScale
}
}

public func isHiDPI() -> Bool {
    return screenScale > 1.0
}

public func isOSVersionAtLeast(minVerStr: String) -> Bool {
    let currSysVer = UIDevice.currentDevice().systemVersion
    return currSysVer.compare(minVerStr, options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
}

public let isOSVersionAtLeast8 = isOSVersionAtLeast("8.0")

// suitable for returning from UIViewController.supportedInterfaceOrientations()
public let orientationsPadAllPhonePortrait = Int(interfaceOrientationMaskValue_glue(isPad ? UIInterfaceOrientationMask.All : UIInterfaceOrientationMask.Portrait))
public let orientationsPadAllPhoneAllButUpsideDown = Int(interfaceOrientationMaskValue_glue(isPad ? UIInterfaceOrientationMask.All : UIInterfaceOrientationMask.AllButUpsideDown))