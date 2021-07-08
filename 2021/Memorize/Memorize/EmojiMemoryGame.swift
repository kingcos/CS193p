//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by kingcos on 2021/7/9.
//

import SwiftUI

// ViewModel Layer

class EmojiMemoryGame : ObservableObject {
    static let emojis = ["🚗", "✈️", "🛵", "🚢"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
    }
    
    // ---
    
    @Published var model = createMemoryGame()
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
