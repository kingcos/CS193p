//
//  MemoryGame.swift
//  Memorize
//
//  Created by kingcos on 2021/7/9.
//

import Foundation

// Model Layer

struct MemoryGame<CardContent> {
    struct Card: Identifiable {
        var id: Int
        
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
    }
    
    private(set) var cards: [Card] = []
    
    init(numberOfPairsOfCards: Int, _ createCardContent: (Int) -> CardContent) {
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let choseIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[choseIndex].isFaceUp.toggle()
        }
    }
}
