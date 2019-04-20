//
//  Set.swift
//  Set
//
//  Created by Work Kris on 12/16/18.
//  Copyright © 2018 Kris P. All rights reserved.
//

import Foundation
import UIKit

struct Set
{
    private(set) var originalDeckOfCards: [Card] = {
        var CardsArray = [Card]()
        for symbol in Card.Symbol.allCases {
            for number in Card.Number.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        CardsArray += [Card(symbol: symbol, number: number, shading: shading, color: color)]
                    }
                }
            }
        }
        return CardsArray
    }()
    
    private(set) var dealtCards = [Card?]()
    private(set) var selectedCardsIndices = [Int]()
    private(set) var matchedCards = [Card]()
    private(set) var score = 0
    
    var isSet: Bool {
        get {
            return testIfSet(testEnums)
        }
    }
    
    init() {
                for _ in 1...12 {
                    dealtCards += [dealCard()]
                }
        
        //        for _ in 0..<57 {
        //            _ = originalDeckOfCards.remove(at: originalDeckOfCards.count.arc4random)
        //        }
    }
    
    mutating func dealCard() -> Card? {
        return (originalDeckOfCards.count > 0 ? originalDeckOfCards.remove(at: originalDeckOfCards.count.arc4random) : nil)
    }
    
    mutating func dealThreeCards() {
        if isSet {
            replaceSet()
            selectedCardsIndices.removeAll()
        } else {
            for _ in 1...3 {
                dealtCards += [dealCard()]
                //            dealtCards += [originalDeckOfCards.remove(at: index)]
            }
        }
    }
    
    mutating func selectCard(at index: Int) {
        if selectedCardsIndices.count < 3 {
            if let deselectIndex = selectedCardsIndices.firstIndex(of: index) {
                selectedCardsIndices.remove(at: deselectIndex)
            } else {
                selectedCardsIndices += [index]
            }
        } else {
            if isSet {
                replaceSet()
                score += 3
            } else {
                score -= 5
            }
            if selectedCardsIndices.contains(index) {
                selectedCardsIndices.removeAll()
            } else {
                selectedCardsIndices.removeAll()
                selectedCardsIndices += [index]
            }
        }
    }
    
    mutating func replaceSet() {
        for index in selectedCardsIndices.indices {
            matchedCards += [dealtCards.remove(at: selectedCardsIndices[index])!]
            dealtCards.insert(dealCard(), at: selectedCardsIndices[index])
        }
    }
    
    func testIfSet(_ aClosure: (Card, Card, Card) -> Bool) -> Bool {
        return (selectedCardsIndices.count == 3 && aClosure(dealtCards[selectedCardsIndices[0]]!, dealtCards[selectedCardsIndices[1]]!, dealtCards[selectedCardsIndices[2]]!))
    }
    
    var testEnums: (Card, Card, Card) -> Bool = {
        return ((($0.symbol == $1.symbol && $0.symbol == $2.symbol) || ($0.symbol != $1.symbol && $0.symbol != $2.symbol && $1.symbol != $2.symbol)) && (($0.number == $1.number && $0.number == $2.number) || ($0.number != $1.number && $0.number != $2.number && $1.number != $2.number)) && (($0.shading == $1.shading && $0.shading == $2.shading) || ($0.shading != $1.shading && $0.shading != $2.shading && $1.shading != $2.shading)) && (($0.color == $1.color && $0.color == $2.color) || ($0.color != $1.color && $0.color != $2.color && $1.color != $2.color)))
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
