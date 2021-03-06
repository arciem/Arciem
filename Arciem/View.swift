//
//  View.swift
//  Arciem
//
//  Created by Robert McNally on 6/9/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

public extension OSView {
    public func frameSetter() -> RectSetter {
        return RectSetter(rect: frame) { [unowned self] (r) in self.frame = r }
    }

    public func tranparentPointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
    }
    
    public func makeTransparent(debugColor: UIColor = UIColor.clearColor(), debug: Bool = false) {
        opaque = false
        backgroundColor = debug ? debugColor.colorWithAlphaComponent(0.25) : UIColor.clearColor()
    }
    
    public func constrainToSuperview() -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        let sv = superview!
        let constraints = [
            layoutLeft ==⦿ sv.layoutLeft,
            layoutRight ==⦿ sv.layoutRight,
            layoutTop ==⦿ sv.layoutTop,
            layoutBottom ==⦿ sv.layoutBottom
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func constrainToView(view: OSView) -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        assert(view.superview != nil, "View must have a superview.")
        assert(superview == view.superview, "Views must have same superview.")
        let constraints = [
            layoutCenterX ==⦿ view.layoutCenterX,
            layoutCenterY ==⦿ view.layoutCenterY,
            layoutWidth ==⦿ view.layoutWidth,
            layoutHeight ==⦿ view.layoutHeight
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func constrainCenterToSuperviewCenter() -> [NSLayoutConstraint] {
        assert(superview != nil, "View must have a superview.")
        let sv = superview!
        let constraints = [
            layoutCenterX ==⦿ sv.layoutCenterX,
            layoutCenterY ==⦿ sv.layoutCenterY
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        return constraints
    }
    
    public func printViewHierarchy() {
        printViewHierarchy(self, indent: "", level: 0)
    }
    
    private func printViewHierarchy(view: OSView, indent: String, level: Int) {
        var scrollViewPrefix = "⬜️"
        #if os(iOS) || os(tvOS)
            if let scrollView = view as? UIScrollView {
                scrollViewPrefix = "🔃"
                #if os(iOS)
                if scrollView.scrollsToTop {
                    scrollViewPrefix = "🔝"
                }
                #endif
            }
        #endif
        let translatesPrefix = view.osTranslatesAutoresizingMaskIntoConstraints ? "⬜️" : "✅"
        let ambiguousPrefix = view.osHasAmbiguousLayout ? "❓" : "⬜️"
        var auxInfoStrings = [String]()
        
        auxInfoStrings.append("opaque:\(view.opaque)")
        #if os(iOS) || os(tvOS)
            auxInfoStrings.append("backgroundColor:\(view.backgroundColor)")
            if let label = view as? UILabel {
                auxInfoStrings.append("textColor:\(label.textColor)")
            }
            auxInfoStrings.append("tintColor:\(view.tintColor)")
        #endif
        auxInfoStrings.append("alpha:\(view.osAlpha)")
        let debugName = view.debugName
        let debugNameString = debugName == nil ? "" : "\(debugName): "
        let auxInfoString = auxInfoStrings.joinWithSeparator(" ")
        let prefix = "\(scrollViewPrefix) \(translatesPrefix) \(ambiguousPrefix)"
        let s = NSString(format: "%@%@%3d %@%@ %@", prefix, indent, level, debugNameString, view, auxInfoString)
        Swift.print(s)
        
        let nextIndent = indent + "  |"
        for subview in view.subviews {
            printViewHierarchy(subview, indent: nextIndent, level: level + 1)
        }
    }
    
    public func printConstraintsHierarchy() {
        printConstraintsHierarchy(self, indent: "", level: 0)
    }
    
    private func printConstraintsHierarchy(view: OSView, indent: String, level: Int) {
        let translatesPrefix = view.osTranslatesAutoresizingMaskIntoConstraints ? "⛔️" : "✅"
        let ambiguousPrefix = view.osHasAmbiguousLayout ? "❓" : "✅"
        let prefix = "\(translatesPrefix) \(ambiguousPrefix)"
        let debugName = view.debugName
        let debugNameString = debugName == nil ? "" : "\(debugName): "
        let viewString = NSString(format: "%@<%p>", NSStringFromClass(view.dynamicType), view)
        let frameString = NSString(format: "(%g %g; %g %g)", Float(view.frame.left), Float(view.frame.top), Float(view.frame.width), Float(view.frame.height))
        let s = NSString(format: "%@ ⬜️ %@%3d %@%@ %@", prefix, indent, level, debugNameString, viewString, frameString)
        Swift.print(s)
        for constraint in view.constraints {
            let layoutGroupName = constraint.layoutGroupName
            let layoutGroupNameString = layoutGroupName == nil ? "" : "\(layoutGroupName): "
            Swift.print("⬜️ ⬜️ 🔵 \(indent)  │    \(layoutGroupNameString)\(constraint)")
        }
        
        let nextIndent = indent + "  |"
        for subview in view.subviews {
            printConstraintsHierarchy(subview, indent: nextIndent, level: level + 1)
        }
    }
}

//prefix operator ~ { }

public prefix func ~<V: OSView>(v: V) -> V {
    #if os(iOS) || os(tvOS)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.opaque = false
    #elseif os(OSX)
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.wantsLayer = true
    #endif
    return v
}

public class CView : OSView {
    required public init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        _setup()
    }

    #if os(OSX)
    public override var flipped: Bool {
        get {
            return true
        }
    }
    #endif
    
    public convenience init() {
        self.init(frame: CGRect.zero)
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
    
    public func osDidSetNeedsDisplay() {
    }
    
    #if os(iOS) || os(tvOS)
    override public func setNeedsDisplay() {
        super.setNeedsDisplay()
        osDidSetNeedsDisplay()
    }
    
    public func osSetNeedsDisplay() {
        setNeedsDisplay()
    }
    #endif
    
    #if os(OSX)
    override public var needsDisplay: Bool {
        didSet {
            osDidSetNeedsDisplay()
        }
    }

    public func osSetNeedsDisplay() {
        needsDisplay = true
    }
    
    public override func setNeedsDisplayInRect(rect: CGRect) {
        super.setNeedsDisplayInRect(rect)
        osDidSetNeedsDisplay()
    }
    #endif
    
    #if os(iOS) || os(tvOS)
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
    #endif
}

#if os(iOS) || os(tvOS)

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
#endif
