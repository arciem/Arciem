//
//  Range.swift
//  Arciem
//
//  Created by Robert McNally on 1/20/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import Foundation

public extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = advance(string.startIndex, self.location)
        let endIndex = advance(startIndex, self.length)
        return startIndex..<endIndex
    }
}