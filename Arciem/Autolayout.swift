//
//  Autolayout.swift
//  Arciem
//
//  Created by Robert McNally on 8/19/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

// Based on work by:
//
// Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
// Licensed under the MIT license, see LICENSE file for more info.

import UIKit

public struct ProtoLayoutConstraint {
    public let view: UIView
    public let attribute: NSLayoutAttribute
    public let multiplier: CGFloat = 1.0
    public let constant: CGFloat = 0.0
    
    public init(view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        self.view = view
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
    }
    
    public init(view: UIView, attribute: NSLayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
    
    // relateTo(), equalTo(), greaterThanOrEqualTo(), and lessThanOrEqualTo() used to be overloaded functions
    // instead of having two separately named functions (e.g. relateTo() and relateToConstant()) but they had
    // to be renamed due to a compiler bug where the compiler chose the wrong function to call.
    //
    // Repro case: http://cl.ly/3S0a1T0Q0S1D
    // rdar://17412596, OpenRadar: http://www.openradar.me/radar?id=5275533159956480
    
    // Builds a constraint by relating the item to another item.
    public func relateTo(right: ProtoLayoutConstraint, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
    }
    
    // Builds a constraint by relating the item to a constant value.
    public func relateTo(right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return  NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: right)
    }
    
    // Equivalent to NSLayoutRelation.Equal
    public func equalTo(right: ProtoLayoutConstraint) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    // Equivalent to NSLayoutRelation.Equal
    public func equalTo(right: CGFloat) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    // Equivalent to NSLayoutRelation.GreaterThanOrEqual
    public func greaterThanOrEqualTo(right: ProtoLayoutConstraint) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
    // Equivalent to NSLayoutRelation.GreaterThanOrEqual
    public func greaterThanOrEqualTo(right: CGFloat) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
   // Equivalent to NSLayoutRelation.LessThanOrEqual
    public func lessThanOrEqualTo(right: ProtoLayoutConstraint) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
    
    // Equivalent to NSLayoutRelation.LessThanOrEqual
    public func lessThanOrEqualTo(right: CGFloat) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
}

// Multiplies the operand's multiplier by the RHS value
public func * (left: ProtoLayoutConstraint, right: CGFloat) -> ProtoLayoutConstraint {
    return ProtoLayoutConstraint(view: left.view, attribute: left.attribute, multiplier: left.multiplier * right, constant: left.constant)
}

// Divides the operand's multiplier by the RHS value
public func / (left: ProtoLayoutConstraint, right: CGFloat) -> ProtoLayoutConstraint {
    return ProtoLayoutConstraint(view: left.view, attribute: left.attribute, multiplier: left.multiplier / right, constant: left.constant)
}

// Adds the RHS value to the operand's constant
public func + (left: ProtoLayoutConstraint, right: CGFloat) -> ProtoLayoutConstraint {
    return ProtoLayoutConstraint(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + right)
}

// Subtracts the RHS value from the operand's constant
public func - (left: ProtoLayoutConstraint, right: CGFloat) -> ProtoLayoutConstraint {
    return ProtoLayoutConstraint(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - right)
}

// ⦿
// CIRCLED BULLET
// Unicode: U+29BF, UTF-8: E2 A6 BF

// Declared in Operators.swift
//infix operator ==⦿ { }
//infix operator >=⦿ { }
//infix operator <=⦿ { }

// Equivalent to NSLayoutRelation.Equal
public func ==⦿ (left: ProtoLayoutConstraint, right: ProtoLayoutConstraint) -> NSLayoutConstraint {
    return left.equalTo(right)
}

// Equivalent to NSLayoutRelation.Equal
public func ==⦿ (left: ProtoLayoutConstraint, right: CGFloat) -> NSLayoutConstraint {
    return left.equalTo(right)
}

// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >=⦿ (left: ProtoLayoutConstraint, right: ProtoLayoutConstraint) -> NSLayoutConstraint {
    return left.greaterThanOrEqualTo(right)
}

// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >=⦿ (left: ProtoLayoutConstraint, right: CGFloat) -> NSLayoutConstraint {
    return left.greaterThanOrEqualTo(right)
}

// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <=⦿ (left: ProtoLayoutConstraint, right: ProtoLayoutConstraint) -> NSLayoutConstraint {
    return left.lessThanOrEqualTo(right)
}

// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <=⦿ (left: ProtoLayoutConstraint, right: CGFloat) -> NSLayoutConstraint {
    return left.lessThanOrEqualTo(right)
}

public func =⦿= (left: NSLayoutConstraint, right: UILayoutPriority) -> NSLayoutConstraint {
    left.priority = right
    return left
}

public extension NSLayoutConstraint {
    public class func activateConstraintsGlue(constraints: [NSLayoutConstraint], targetView: UIView) {
        if isOSVersionAtLeast8 {
            NSLayoutConstraint.activateConstraints(constraints)
        } else {
            for constraint in constraints {
                targetView.addConstraint(constraint)
            }
        }
    }
    
    public var layoutGroupName: String? {
        get {
            return getAssociatedObject(object: self, key: "layoutGroupName") as String?
        }
        set {
            setAssociatedObject(object: self, key: "layoutGroupName", value: newValue?)
        }
    }
}

public extension UIView {

    func layoutAttribute(attribute: NSLayoutAttribute) -> ProtoLayoutConstraint {
        return ProtoLayoutConstraint(view: self, attribute: attribute)
    }

    // Equivalent to NSLayoutAttribute.Left
    public var layoutLeft: ProtoLayoutConstraint {
        return layoutAttribute(.Left)
    }

    // Equivalent to NSLayoutAttribute.Right
    public var layoutRight: ProtoLayoutConstraint {
        return layoutAttribute(.Right)
    }

    // Equivalent to NSLayoutAttribute.Top
    public var layoutTop: ProtoLayoutConstraint {
        return layoutAttribute(.Top)
    }

    // Equivalent to NSLayoutAttribute.Bottom
    public var layoutBottom: ProtoLayoutConstraint {
        return layoutAttribute(.Bottom)
    }

    // Equivalent to NSLayoutAttribute.Leading
    public var layoutLeading: ProtoLayoutConstraint {
        return layoutAttribute(.Leading)
    }

    // Equivalent to NSLayoutAttribute.Trailing
    public var layoutTrailing: ProtoLayoutConstraint {
        return layoutAttribute(.Trailing)
    }

    // Equivalent to NSLayoutAttribute.Width
    public var layoutWidth: ProtoLayoutConstraint {
        return layoutAttribute(.Width)
    }

    // Equivalent to NSLayoutAttribute.Height
    public var layoutHeight: ProtoLayoutConstraint {
        return layoutAttribute(.Height)
    }

    // Equivalent to NSLayoutAttribute.CenterX
    public var layoutCenterX: ProtoLayoutConstraint {
        return layoutAttribute(.CenterX)
    }

    // Equivalent to NSLayoutAttribute.CenterY
    public var layoutCenterY: ProtoLayoutConstraint {
        return layoutAttribute(.CenterY)
    }

    // Equivalent to NSLayoutAttribute.Baseline
    public var layoutBaseline: ProtoLayoutConstraint {
        return layoutAttribute(.Baseline)
    }

}

// Current SDK gives a linker error when using UILayoutPriorityRequired and similar, so these are duplicate constants.

public let LayoutPriorityDefaultRequired: UILayoutPriority = 1000 // A required constraint.  Do not exceed this.
public let LayoutPriorityDefaultHigh: UILayoutPriority = 750 // This is the priority level with which a button resists compressing its content.
public let LayoutPriorityDefaultLow: UILayoutPriority = 250 // This is the priority level at which a button hugs its contents horizontally.
public let LayoutPriorityFittingSizeLevel: UILayoutPriority = 50 // When you send -[UIView systemLayoutSizeFittingSize:], the size fitting most closely to the target size (the argument) is computed.  UILayoutPriorityFittingSizeLevel is the priority level with which the view wants to conform to the target size in that computation.  It's quite low.  It is generally not appropriate to make a constraint at exactly this priority.  You want to be higher or lower.