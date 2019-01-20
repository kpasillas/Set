//
//  ViewController.swift
//  Set
//
//  Created by Work Kris on 12/16/18.
//  Copyright © 2018 Kris P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var game = Set()
    
    @IBOutlet private var setCardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    @IBOutlet private var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.borderWidth = 3.0
            newGameButton.layer.cornerRadius = 8.0
            newGameButton.layer.borderColor = UIColor.darkGray.cgColor
            newGameButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    @IBOutlet private var dealButton: UIButton! {
        didSet {
            dealButton.layer.borderWidth = 3.0
            dealButton.layer.cornerRadius = 8.0
            dealButton.layer.borderColor = UIColor.darkGray.cgColor
            dealButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            dealButton.setTitleColor(UIColor.lightGray, for: .disabled)
        }
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }

//    private(set) var numberOfSelectedCards = 0 {
//        didSet {
//            if numberOfSelectedCards == 3 {
//                var potentialSet = [Card]()
//                for index in setCardButtons.indices {
//                    if setCardButtons[index].isSelected {
//                        potentialSet += game.dealtCards[index]
//                    }
//
//                }
//            } else if numberOfSelectedCards > 3 {
//                for index in setCardButtons.indices {
//                    setCardButtons[index].isSelected = false
//                }
//                numberOfSelectedCards = 1
//            }
//            updateScoreLabel()
//        }
//    }
    
    override func viewDidLoad() {
        resetDeckOfCards()
        updateViewFromModel()
    }
    
    @IBAction private func touchSetCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.index(of: sender) {
//            let button = setCardButtons[cardNumber]
            if cardNumber < game.dealtCards.count {
//                if game.isSet() {
//                    game.replaceSet()
//                }
                game.selectCard(at: cardNumber)
                flipCount += 1
//                if button.isSelected {
//                    numberOfSelectedCards -= 1
//                } else {
//                    numberOfSelectedCards += 1
//                }
//                button.isSelected = !button.isSelected
                updateViewFromModel()
            }
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Set()
        flipCount = 0
        dealButton.isEnabled = true
//        numberOfSelectedCards = 0
        resetDeckOfCards()
        updateViewFromModel()
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        if dealButton.isEnabled {
            game.dealCards(number: 3)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in setCardButtons.indices {
            let button = setCardButtons[index]
            if index < game.dealtCards.count {
                button.isSelected = game.selectedCardsIndices.contains(index)
                if let card = game.dealtCards[index] {
                    let cardAttributes = NSAttributedString(string: card.attributesSymbolNumber, attributes: card.attributesColorShade)
                    button.setAttributedTitle(cardAttributes, for: .normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    button.isEnabled = false
                    let nilAttributes: [NSAttributedString.Key : Any] = [
                        .foregroundColor : UIColor.black.withAlphaComponent(0.0),
                        .strokeColor : UIColor.black.withAlphaComponent(0.0),
                        .strokeWidth : UIColor.black.withAlphaComponent(0.0)
                    ]
                    let cardAttributes = NSAttributedString(string: "\n\n", attributes: nilAttributes)
                    button.setAttributedTitle(cardAttributes, for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }
            } else {
                let cardAttributes = NSAttributedString(string: "")
                button.setAttributedTitle(cardAttributes, for: .normal)
            }
            if button.isSelected && button.isEnabled {
                if game.isSet() {
                    button.layer.borderColor = UIColor.green.cgColor
                } else if game.selectedCardsIndices.count == 3 {
                    button.layer.borderColor = UIColor.red.cgColor
                } else {
                    button.layer.borderColor = UIColor.blue.cgColor
                }
            } else if !button.isEnabled {
                button.layer.borderColor = UIColor.clear.cgColor
            } else {
                button.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
        if game.originalDeckOfCards.isEmpty || (game.dealtCards.count >= setCardButtons.count && !game.isSet()) {
            dealButton.isEnabled = false
        } else {
            dealButton.isEnabled = true
        }
    }
    
    private func resetDeckOfCards() {
        for index in setCardButtons.indices {
            let button = setCardButtons[index]
            button.isSelected = false
            button.isEnabled = true
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 8.0
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            button.setTitle("", for: .normal)
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.06505490094, green: 0.5875003338, blue: 0.9998186231, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.06505490094, green: 0.5875003338, blue: 0.9998186231, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Score: \(game.selectedCardsIndices.count)", attributes: attributes)
        scoreLabel.attributedText = attributedString
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

extension Card {
    var attributesColorShade: [NSAttributedString.Key : Any] {
        let foregroundColor: UIColor
        let color = self.color
        switch color {
        case .green: foregroundColor = UIColor.green
        case .purple: foregroundColor = UIColor.purple
        case .red: foregroundColor = UIColor.red
        }
        
        var alpha = CGFloat(1.0)
        var stroke = 0.0
        let shading = self.shading
        switch shading {
        case .solid: stroke = 0.0
        case .striped: alpha = 0.15
        case .open: stroke = 3.0
        }
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : foregroundColor.withAlphaComponent(alpha),
            .strokeColor : foregroundColor,
            .strokeWidth : stroke
        ]
        return attributes
    }
    
    var attributesSymbolNumber: String {
        var text = String()
        
        switch self.number {
            case .one: text = "\(self.symbol.rawValue)"
            case .two: text = "\(self.symbol.rawValue)\n   \(self.symbol.rawValue)"
            case .three: text = "\(self.symbol.rawValue)\n   \(self.symbol.rawValue)\n      \(self.symbol.rawValue)"
        }
        return text
    }
}
