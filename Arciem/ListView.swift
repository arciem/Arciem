//
//  ListView.swift
//  Arciem
//
//  Created by Robert McNally on 2/13/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import UIKit

@objc public protocol ListView {
    var backgroundView: UIView? { get set }
    var backgroundColor: UIColor! { get set }
}

extension UITableView: ListView { }
extension UICollectionView: ListView { }

public func setNonScrollingBackgroundForListView<V: ListView>(view: V, toColorPatternNamed name: String) {
    view.backgroundView = UIView()
    view.backgroundView?.backgroundColor = colorWithPatternImageNamed(name)
}

public func setScrollingBackgroundForListView<V: ListView>(view: V, toColorPatternNamed name: String) {
    view.backgroundColor = colorWithPatternImageNamed(name)
}

public func setBackgroundForView(view: UIView, toColorPatternNamed name: String) {
    view.backgroundColor = colorWithPatternImageNamed(name)
}
