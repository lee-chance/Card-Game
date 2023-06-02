//
//  ROBModel.swift
//  CardGame
//
//  Created by 이창수 on 2023/06/02.
//

import Foundation

enum ROBResult {
    case win, lose, tie
}

struct ROBPlayerHand {
    let initalDeck: [Card]
    var useableCards: [Card]
    var card: Card?
    var score: Int = 0
    
    var leftCards: [Card] {
        useableCards.filter { $0 != card }
    }
    
    init(deck: [Card]) {
        self.initalDeck = deck
        self.useableCards = deck
    }
    
    mutating func nextGame() {
        useableCards = leftCards
        card = nil
    }
    
    static var empty: Self {
        ROBPlayerHand(deck: [])
    }
}
