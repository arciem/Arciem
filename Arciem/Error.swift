//
//  Error.swift
//  Arciem
//
//  Created by Robert McNally on 10/21/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

extension NSError {
    public convenience init(domain: String, code: Int, localizedDescription: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}