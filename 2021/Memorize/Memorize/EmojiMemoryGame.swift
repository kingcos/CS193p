//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by kingcos on 2021/7/9.
//

import SwiftUI

// ViewModel Layer

class EmojiMemoryGame : ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚗", "✈️", "🛵", "🚢"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
    }
    
    // ---
    
    @Published private var model = createMemoryGame()
    
    var cards: [Card] {
        model.cards
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
