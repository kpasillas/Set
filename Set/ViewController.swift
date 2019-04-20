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
    
    @IBOutlet private var setCardButtons: [UIButton]! {
        didSet {
            for index in setCardButtons.indices {
                setCardButtons[index].layer.borderWidth = 3.0
                setCardButtons[index].layer.cornerRadius = 8.0
                setCardButtons[index].layer.borderColor = UIColor.darkGray.cgColor
                setCardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: .disabled)
            }
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel! {
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
            newGameButton.sizeToFit()
        }
    }
    
    @IBOutlet private var dealButton: UIButton! {
        didSet {
            dealButton.layer.borderWidth = 3.0
            dealButton.layer.cornerRadius = 8.0
            dealButton.layer.borderColor = UIColor.darkGray.cgColor
            dealButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            dealButton.setTitleColor(UIColor.lightGray, for: .disabled)
            dealButton.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                resetDeckOfCards()
                updateViewFromModel()
    }
    
    @IBAction private func touchSetCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.index(of: sender), cardNumber < game.dealtCards.count {
            game.selectCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Set()
        resetDeckOfCards()
        updateViewFromModel()
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        game.dealThreeCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in setCardButtons.indices {                                           // update all cards
            let button = setCardButtons[index]
            if index < game.dealtCards.count {                                          // test if card has been dealt
                button.isEnabled = true
                button.isSelected = game.selectedCardsIndices.contains(index)               // test if card is selected
                if let card = game.dealtCards[index] {                                      // if card is currently dealt, draw with attributes
                    let flippedCardAttributes = NSAttributedString(string: card.attributesSymbolNumber, attributes: card.attributesColorShade)
                    button.setAttributedTitle(flippedCardAttributes, for: .normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {                                                                    // if original deck of cards is empty, hide card
                    button.alpha = 0.0
                }
            } else {                                                                    // if card has not been dealt, leave unflipped
                button.isEnabled = false
            }
            updateSetButtonBorder(button)
        }
        updateDealLabel()
        updateScoreLabel()
    }
    
    private func resetDeckOfCards() {
        for index in setCardButtons.indices {
            let button = setCardButtons[index]
            button.isSelected = false
            button.alpha = 1.0
            button.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            button.setTitle("", for: .disabled)
        }
    }
    
    private func updateSetButtonBorder(_ button: UIButton) {
        if button.isSelected {                                                          // test if button has been selected
            if game.isSet {                                                                 // if 3 buttons are set, border = green
                button.layer.borderColor = UIColor.green.cgColor
            } else if game.selectedCardsIndices.count == 3 {                                // if 3 buttons are not set, border = red
                button.layer.borderColor = UIColor.red.cgColor
            } else {                                                                        // if < 3 buttons are selected, border = blue
                button.layer.borderColor = UIColor.blue.cgColor
            }
        } else {                                                                        // if button is not selected, border = gray
            button.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func updateDealLabel() {
        dealButton.isEnabled = !(game.originalDeckOfCards.isEmpty || (game.dealtCards.count >= setCardButtons.count && !game.isSet))
    }
    
    private func updateScoreLabel() {
        let scoreAttributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.06505490094, green: 0.5875003338, blue: 0.9998186231, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Score: \(game.score)", attributes: scoreAttributes)
        scoreLabel.attributedText = attributedString
    }
    
}

extension Card {
    var attributesColorShade: [NSAttributedString.Key : Any] {
        let foregroundColor: UIColor
        switch self.color {
        case .green: foregroundColor = UIColor.green
        case .purple: foregroundColor = UIColor.purple
        case .red: foregroundColor = UIColor.red
        }
        
        var alpha = CGFloat(1.0)
        var stroke = 0.0
        switch self.shading {
        case .solid: break
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
        switch self.number {
        case .one: return "\(self.symbol.rawValue)"
        case .two: return "\(self.symbol.rawValue)\n   \(self.symbol.rawValue)"
        case .three: return "\(self.symbol.rawValue)\n   \(self.symbol.rawValue)\n      \(self.symbol.rawValue)"
        }
    }
}
