//
//  ROBCardExtension.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import Foundation

extension Card {
    static func robCardSet1() -> [Card] {
        var result: [Card] = []
        
        for rank in Card.Rank.allCases[..<10] {
            switch rank.rawValue % 4 {
            case 1:
                result.append(Card(suit: .spades, rank: rank))
            case 2:
                result.append(Card(suit: .hearts, rank: rank))
            case 3:
                result.append(Card(suit: .clubs, rank: rank))
            default:
                result.append(Card(suit: .diamonds, rank: rank))
            }
        }
        
        return result
    }
    
    static func robCardSet2() -> [Card] {
        var result: [Card] = []
        
        for rank in Card.Rank.allCases[..<10] {
            switch rank.rawValue % 4 {
            case 1:
                result.append(Card(suit: .clubs, rank: rank))
            case 2:
                result.append(Card(suit: .diamonds, rank: rank))
            case 3:
                result.append(Card(suit: .spades, rank: rank))
            default:
                result.append(Card(suit: .hearts, rank: rank))
            }
        }
        
        return result
    }
}
