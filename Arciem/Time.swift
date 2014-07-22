//
//  Time.swift
//  Arciem
//
//  Created by Robert McNally on 6/6/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public let millisecondsPerSecond = 1000
public let nanosecondsPerSecond = 1000000000
public let nanosecondsPerMillisecond = 1000000

public let microsecondsPerSecond = 1000000
public let nanosecondsPerMicrosecond = 1000

public let secondsPerMinute = 60
public let minutesPerHour = 60
public let hoursPerDay = 24
public let secondsPerHour = secondsPerMinute * minutesPerHour
public let minutesPerDay = minutesPerHour * hoursPerDay
public let secondsPerDay = secondsPerMinute * minutesPerDay
public let daysPerWeek = 7

public enum Tense: Int {
    case Past = -1
    case Present = 0
    case Future = 1
}