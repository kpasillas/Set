//
//  Card.swift
//  Set
//
//  Created by Work Kris on 12/16/18.
//  Copyright © 2018 Kris P. All rights reserved.
//

import Foundation

struct Card
{
    enum Symbol: Character, CaseIterable {
        case triangle = "▲", circle = "●", square = "■"
    }
    
    enum Number: Int, CaseIterable {
        case one = 1, two, three
    }
    
    enum Shading: CaseIterable {
        case solid, striped, open
    }
    
    enum Color: CaseIterable {
        case red, green, purple
    }
    
    let symbol: Symbol, number: Number, shading: Shading, color: Color
}
