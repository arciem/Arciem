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
    
    public func constrainToSuperview() {
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[self]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["self": self]) as [NSLayoutConstraint]
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[self]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["self": self]) as [NSLayoutConstraint]
        NSLayoutConstraint.activateConstraints(constraints)
    }
}

public class CView : UIView {
    public init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
        _setup()
    }
    
    public init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    func _setup() {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.opaque = false
        setup()
    }
    
    public func setup() {
    }
}

public class CImageView : UIImageView {
    public init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
        _setup()
    }
    
    public init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    init(image: UIImage!) {
        super.init(image: image)
        _setup()
    }
    
    init(image: UIImage!, highlightedImage: UIImage!) {
        super.init(image: image, highlightedImage: highlightedImage)
        _setup()
    }
    
    func _setup() {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.opaque = false
        setup()
    }
    
    public func setup() {
    }
}