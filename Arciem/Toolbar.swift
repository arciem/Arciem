//
//  Toolbar.swift
//  Arciem
//
//  Created by Robert McNally on 1/26/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import UIKit
import QuartzCore

// See also extension for UINavigationBar
public extension UIToolbar {
    public func setBarStyle(barStyle: UIBarStyle, animated: Bool) {
        if animated && self.barStyle != barStyle {
            let transition = CATransition()
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            layer.addAnimation(transition, forKey: nil)
        }
        
        self.barStyle = barStyle
    }
}
