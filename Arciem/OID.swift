//
//  OID.swift
//  Arciem
//
//  Created by Robert McNally on 2/20/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

private var nextOID: Int = 1
private let oidSerializer = Serializer()

public struct OID {
    private let oid: Int
    
    public init() {
        oid = oidSerializer.dispatchWithReturn { return nextOID++ }
    }
}

extension OID: Printable {
    public var description: String { return "OID(\(oid))" }
}
