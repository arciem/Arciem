//
//  DataflowⓋ.swift
//  Arciem
//
//  Created by Robert McNally on 3/1/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public protocol DataflowⓋ: Any, Equatable {
    init()
}

extension Bool: DataflowⓋ {}
extension Float: DataflowⓋ {}
extension Double: DataflowⓋ {}
extension String: DataflowⓋ {}
