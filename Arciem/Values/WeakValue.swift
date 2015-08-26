//
//  WeakValue.swift
//  Arciem
//
//  Created by Robert McNally on 10/16/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct WeakValue<🍒: AnyObject> /*: Valuable*/ {
    public typealias 🍋 = 🍒?
    weak public var value: 🍋
    
    init(_ value: 🍋) {
        self.value = value
    }
}
