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
    private(set) var originalDeckOfCards = [Card]()
    private(set) var dealtCards = [Card?]()
    private(set) var selectedCardsIndices = [Int]()
    private(set) var matchedCards = [Card]()
    private(set) var score = 0
//    private(set) var numberOfSelectedCards = 0
    
    init() {
        originalDeckOfCards = [Card]()
        for symbol in Card.Symbol.allCases {
            for number in Card.Number.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        let card = Card(symbol: symbol, number: number, shading: shading, color: color)
                        originalDeckOfCards += [card]
                    }
                }
            }
        }
        dealCards(number: 12)
        
//        for _ in 0..<57 {
//            _ = originalDeckOfCards.remove(at: originalDeckOfCards.count.arc4random)
//        }
    }
    
    mutating func selectCard(at index: Int) {
        if selectedCardsIndices.count < 3 {
            if let deselectIndex = selectedCardsIndices.firstIndex(of: index) {
                selectedCardsIndices.remove(at: deselectIndex)
            } else {
                selectedCardsIndices += [index]
            }
        } else {
//            if originalDeckOfCards.count >= 3 && isSet() {
            if isSet() {
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
    
    mutating func dealCards(number: Int) {
        if originalDeckOfCards.count >= number {
            if isSet() {
                replaceSet()
                selectedCardsIndices.removeAll()
            } else {
                for _ in 1...number {
                    dealtCards += [originalDeckOfCards.remove(at: originalDeckOfCards.count.arc4random)]
                    //            dealtCards += [originalDeckOfCards.remove(at: index)]
                }
            }
        }
    }
    
    func isSet() -> Bool {
        if selectedCardsIndices.count < 3 {
            return false
//        } else {
//            return true
//        }
        } else if ((dealtCards[selectedCardsIndices[0]]?.symbol == dealtCards[selectedCardsIndices[1]]?.symbol && dealtCards[selectedCardsIndices[0]]?.symbol == dealtCards[selectedCardsIndices[2]]?.symbol) || (dealtCards[selectedCardsIndices[0]]?.symbol != dealtCards[selectedCardsIndices[1]]?.symbol && dealtCards[selectedCardsIndices[0]]?.symbol != dealtCards[selectedCardsIndices[2]]?.symbol && dealtCards[selectedCardsIndices[1]]?.symbol != dealtCards[selectedCardsIndices[2]]?.symbol)) && ((dealtCards[selectedCardsIndices[0]]?.number == dealtCards[selectedCardsIndices[1]]?.number && dealtCards[selectedCardsIndices[0]]?.number == dealtCards[selectedCardsIndices[2]]?.number) || (dealtCards[selectedCardsIndices[0]]?.number != dealtCards[selectedCardsIndices[1]]?.number && dealtCards[selectedCardsIndices[0]]?.number != dealtCards[selectedCardsIndices[2]]?.number && dealtCards[selectedCardsIndices[1]]?.number != dealtCards[selectedCardsIndices[2]]?.number)) && ((dealtCards[selectedCardsIndices[0]]?.shading == dealtCards[selectedCardsIndices[1]]?.shading && dealtCards[selectedCardsIndices[0]]?.shading == dealtCards[selectedCardsIndices[2]]?.shading) || (dealtCards[selectedCardsIndices[0]]?.shading != dealtCards[selectedCardsIndices[1]]?.shading && dealtCards[selectedCardsIndices[0]]?.shading != dealtCards[selectedCardsIndices[2]]?.shading && dealtCards[selectedCardsIndices[1]]?.shading != dealtCards[selectedCardsIndices[2]]?.shading)) && ((dealtCards[selectedCardsIndices[0]]?.color == dealtCards[selectedCardsIndices[1]]?.color && dealtCards[selectedCardsIndices[0]]?.color == dealtCards[selectedCardsIndices[2]]?.color) || (dealtCards[selectedCardsIndices[0]]?.color != dealtCards[selectedCardsIndices[1]]?.color && dealtCards[selectedCardsIndices[0]]?.color != dealtCards[selectedCardsIndices[2]]?.color && dealtCards[selectedCardsIndices[1]]?.color != dealtCards[selectedCardsIndices[2]]?.color)) {
            return true
        } else {
            return false
        }
    }
    
    mutating func replaceSet() {
        for index in selectedCardsIndices.indices {
            matchedCards += [dealtCards.remove(at: selectedCardsIndices[index])!]
            if originalDeckOfCards.count >= 1 {
                dealtCards.insert(originalDeckOfCards.remove(at: originalDeckOfCards.count.arc4random), at: selectedCardsIndices[index])
            } else {
                dealtCards.insert(nil, at: selectedCardsIndices[index])
            }
        }
    }
}
