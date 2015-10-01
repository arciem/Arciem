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
        assert(self.superview != nil, "View must have a superview.")
        let superview = self.superview!
        let constraints = [
            self.layoutLeft ==⦿ superview.layoutLeft,
            self.layoutRight ==⦿ superview.layoutRight,
            self.layoutTop ==⦿ superview.layoutTop,
            self.layoutBottom ==⦿ superview.layoutBottom
        ]
        NSLayoutConstraint.activateConstraintsGlue(constraints, targetView:superview)
    }
}

public class CView : UIView {
    public required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        _setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    func _setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.opaque = false
        setup()
    }
    
    public func setup() {
    }
}

public class CImageView : UIImageView {
    public required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        _setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        _setup()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage!) {
        super.init(image: image, highlightedImage: highlightedImage)
        _setup()
    }
    
    func _setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.opaque = false
        setup()
    }
    
    public func setup() {
    }
}