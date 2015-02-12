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
    
    public func constrainToSuperview() -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        let sv = superview!
        var constraints = [
            layoutLeft ==⦿ sv.layoutLeft,
            layoutRight ==⦿ sv.layoutRight,
            layoutTop ==⦿ sv.layoutTop,
            layoutBottom ==⦿ sv.layoutBottom
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func constrainToView(view: UIView) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        assert(view.superview != nil, "View must have a superview.")
        assert(superview == view.superview, "Views must have same superview.")
        var constraints = [
            layoutLeft ==⦿ view.layoutLeft,
            layoutRight ==⦿ view.layoutRight,
            layoutTop ==⦿ view.layoutTop,
            layoutBottom ==⦿ view.layoutBottom
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func constrainCenterToSuperviewCenter() -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        let sv = superview!
        var constraints = [
            layoutCenterX ==⦿ sv.layoutCenterX,
            layoutCenterY ==⦿ sv.layoutCenterY
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func printViewHierarchy() {
        printViewHierarchy(self, indent: "", level: 0)
    }
    
    private func printViewHierarchy(view: UIView, indent: String, level: Int) {
        var scrollViewPrefix = "⬜️"
        if let scrollView = view as? UIScrollView {
            scrollViewPrefix = "🔃"
            if scrollView.scrollsToTop {
                scrollViewPrefix = "🔝"
            }
        }
        let translatesPrefix = view.translatesAutoresizingMaskIntoConstraints() ? "⬜️" : "✅"
        let ambiguousPrefix = view.hasAmbiguousLayout() ? "❓" : "⬜️"
        var auxInfoStrings = [String]()
        
        auxInfoStrings.append("opaque:\(view.opaque)")
        auxInfoStrings.append("backgroundColor:\(view.backgroundColor)")
        if let label = view as? UILabel {
            auxInfoStrings.append("textColor:\(label.textColor)")
        }
        auxInfoStrings.append("tintColor:\(view.tintColor)")
        auxInfoStrings.append("alpha:\(view.alpha)")
        let debugName = view.debugName
        let debugNameString = debugName == nil ? "" : "\(debugName): "
        let auxInfoString = joinStrings(" ", auxInfoStrings)
        let prefix = "\(scrollViewPrefix) \(translatesPrefix) \(ambiguousPrefix)"
        let s = NSString(format: "%@%@%3d %@%@ %@", prefix, indent, level, debugNameString, view, auxInfoString)
        println(s)
        
        let nextIndent = indent + "  |"
        for subview in view.subviews as! [UIView] {
            printViewHierarchy(subview, indent: nextIndent, level: level + 1)
        }
    }
    
    public func printConstraintsHierarchy() {
        printConstraintsHierarchy(self, indent: "", level: 0)
    }
    
    private func printConstraintsHierarchy(view: UIView, indent: String, level: Int) {
        let translatesPrefix = view.translatesAutoresizingMaskIntoConstraints() ? "⬜️" : "✅"
        let ambiguousPrefix = view.hasAmbiguousLayout() ? "❓" : "⬜️"
        let prefix = "\(translatesPrefix) \(ambiguousPrefix)"
        let debugName = view.debugName
        let debugNameString = debugName == nil ? "" : "\(debugName): "
        let viewString = NSString(format: "%@<%p>", NSStringFromClass(view.dynamicType), view)
        let frameString = NSString(format: "(%g %g; %g %g)", Float(view.frame.left), Float(view.frame.top), Float(view.frame.width), Float(view.frame.height))
        let s = NSString(format: "%@ ⬜️ %@%3d %@%@ %@", prefix, indent, level, debugNameString, viewString, frameString)
        println(s)
        for constraint in view.constraints() as! [NSLayoutConstraint] {
            let layoutGroupName = constraint.layoutGroupName
            let layoutGroupNameString = layoutGroupName == nil ? "" : "\(layoutGroupName): "
            println("⬜️ ⬜️ 🔵 \(indent)  │    \(layoutGroupNameString)\(constraint)")
        }
        
        let nextIndent = indent + "  |"
        for subview in view.subviews as! [UIView] {
            printConstraintsHierarchy(subview, indent: nextIndent, level: level + 1)
        }
    }
}

//prefix operator ~ { }

public prefix func ~<V: UIView>(v: V) -> V {
    v.setTranslatesAutoresizingMaskIntoConstraints(false)
    v.opaque = false
    return v
}

public class CView : UIView {
    required public init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        _setup()
    }
    
    override public init() {
        super.init()
        _setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    func _setup() {
        ~self
        setup()
    }
    
    public func setup() {
    }
    
    public var backgroundColorLocked = false
    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        
        set {
            if !backgroundColorLocked {
                super.backgroundColor = newValue
            }
        }
    }
}

public class CImageView : UIImageView {
    public required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        _setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    override init(image: UIImage!) {
        super.init(image: image)
        _setup()
    }
    
    override init(image: UIImage!, highlightedImage: UIImage!) {
        super.init(image: image, highlightedImage: highlightedImage)
        _setup()
    }
    
    func _setup() {
        ~self
        setup()
    }
    
    public func setup() {
    }
    
    public var backgroundColorLocked = false
    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        
        set {
            if !backgroundColorLocked {
                super.backgroundColor = newValue
            }
        }
    }
}