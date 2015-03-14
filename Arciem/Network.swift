//
//  Network.swift
//  Arciem
//
//  Created by Robert McNally on 10/21/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Foundation

public extension sockaddr_in {
    public init() {
        sin_len = __uint8_t(sizeof(sockaddr_in))
        sin_family = sa_family_t(AF_INET)
        sin_port = 0
        sin_addr = in_addr(s_addr: 0)
        sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)
    }
    
    public func to_sockaddr() -> sockaddr {
        var addr = sockaddr()
        var in_addr = self
        memcpy(&addr, &in_addr, sizeof(sockaddr))
        return addr
    }
}

public extension sockaddr {
    public init() {
        sa_len = __uint8_t(sizeof(sockaddr))
        sa_family = sa_family_t(AF_INET)
        sa_data = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    }
}