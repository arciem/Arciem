//
//  View.swift
//  Arciem
//
//  Created by Robert McNally on 6/9/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit

public extension UIView {
    public func frameSetter() -> RectSetter {
        return RectSetter(rect: frame) { [unowned self] (r) in self.frame = r }
    }
}
