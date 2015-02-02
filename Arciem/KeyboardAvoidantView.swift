//
//  KeyboardAvoidantView.swift
//  Arciem
//
//  Created by Robert McNally on 1/20/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public class KeyboardAvoidantView : CView {
    // Superview.bottom Equal KeyboardAvoidantView.bottom
    // A positive constant should move the bottom of the KeyboardAvoidantView up.
    @IBOutlet public weak var bottomConstraint: NSLayoutConstraint!
    
    var keyboardView: UIView? = nil

    public override func setup() {
        super.setup()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillMove:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        stopTrackingKeyboard()
    }
    
    func endKeyboardRectangleFromNotification(notification: NSNotification) -> CGRect {
        if let keyboardScreenFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            if let keyboardSuperviewFrame = superview?.convertRect(keyboardScreenFrame, fromView: nil) {
                return keyboardSuperviewFrame
            }
        }
        fatalError("Could not get keyboard rectangle from notification")
    }
    
    func keyboardWillMove(notification: NSNotification) {
        assert(bottomConstraint != nil, "bottomConstraint not set")
        if let superview = superview? {
            let endKeyboardRectangle = endKeyboardRectangleFromNotification(notification)
            updateBottomConstraintForKeyboardRectangle(endKeyboardRectangle)
            
            let duration = NSTimeInterval((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
            let animationCurveValue = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.integerValue ?? UIViewAnimationCurve.Linear.rawValue
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveValue & 3)!
            let options = UIViewAnimationOptions(rawValue: UInt(animationCurveValue) << 16)
            
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: {
                self.layoutIfNeeded()
                }, completion: { (Bool) in
                    self.startTrackingKeyboard()
            })
        }
    }
    
    func updateBottomConstraintForKeyboardRectangle(keyboardRectangle: CGRect) {
        if let superview = superview? {
            let intersects = keyboardRectangle.intersects(superview.bounds)
            let newMaxY = intersects ? keyboardRectangle.top : superview.bounds.bottom
//            println("\(self) updateBottomConstraintForKeyboardRectangle:\(keyboardRectangle) newMaxY:\(newMaxY)")
            bottomConstraint.constant = superview.bounds.bottom - newMaxY
            setNeedsUpdateConstraints()
        }
    }
    
    func startTrackingKeyboard() {
        if keyboardView == nil {
            if let kv = findKeyboardView() {
                keyboardView = kv
                //            println("startTrackingKeyboard: \(keyboardView)")
                kv.addObserver(self, forKeyPath: "center", options: .New, context: nil)
            }
        }
    }
    
    func stopTrackingKeyboard() {
        keyboardView?.removeObserver(self, forKeyPath: "center", context: nil)
        keyboardView = nil
    }
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let keyboardRectangle = keyboardView?.frame {
            updateBottomConstraintForKeyboardRectangle(keyboardRectangle)
        }
    }
    
    func findKeyboardView() -> UIView? {
        var result: UIView? = nil
        
        let windows = UIApplication.sharedApplication().windows as [UIWindow]
        for window in windows {
            if window.description.hasPrefix("<UITextEffectsWindow") {
                for subview in window.subviews as [UIView] {
                    if subview.description.hasPrefix("<UIInputSetContainerView") {
                        for sv in subview.subviews as [UIView] {
                            if sv.description.hasPrefix("<UIInputSetHostView") {
                                result = sv
                                break
                            }
                        }
                        break
                    }
                }
                break
            }
        }
        
        return result
    }
}