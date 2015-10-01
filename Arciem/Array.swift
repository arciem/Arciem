//
//  Array.swift
//  Arciem
//
//  Created by Robert McNally on 6/8/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public func randomIndex<🍒>(array: Array<🍒>, random: Random = Random.sharedInstance) -> Int {
    return random.randomInt(0..<array.count)
}

public func randomElement<🍒>(array: Array<🍒>, random: Random = Random.sharedInstance) -> 🍒 {
    return array[randomIndex(array)]
}

// Fisher–Yates shuffle
// http://datagenetics.com/blog/november42014/index.html
public func shuffled<🍒>(array: Array<🍒>, random: Random = Random.sharedInstance) -> Array<🍒> {
    var result = array
    let hi = result.count - 1
    for var a = 0; a < hi; ++a {
        let b = random.randomInt((a+1)..<array.count)
        swap(&result[a], &result[b])
    }
    return result
}

public func shuffledTest() {
    let suits = ["♠️", "♥️", "♣️", "♦️"]
    let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    var deck = [String]()
    for suit in suits {
        for rank in ranks {
            deck.append("\(rank)\(suit)")
        }
    }
    let shuffledDeck = shuffled(deck)
    print(shuffledDeck)
}

public func hasElement<🍒: Equatable>(array: Array<🍒>, _ obj: 🍒) -> Bool {
    return array.filter { $0 == obj }.count > 0
}

public func hasObject<🍒: AnyObject>(array: Array<🍒>, _ obj: 🍒) -> Bool {
    return array.filter { $0 === obj }.count > 0
}
