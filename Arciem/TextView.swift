//
//  TextView.swift
//  Arciem
//
//  Created by Robert McNally on 1/24/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import UIKit

public extension UITextView {
    // Workaround for erratic bottom-scrolling as described in http://stackoverflow.com/questions/19124037/scroll-to-bottom-of-uitextview-erratic-in-ios-7
    public class func createFixedUITextView() -> UITextView {
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        let textView = ~UITextView(frame: .zero, textContainer: textContainer)
        return textView
    }
}