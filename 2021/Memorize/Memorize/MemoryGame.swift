//
//  MemoryGame.swift
//  Memorize
//
//  Created by kingcos on 2021/7/9.
//

import Foundation

// Model Layer

struct MemoryGame<CardContent> where CardContent: Equatable {
    struct Card: Identifiable {
        let id: Int
        
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
    }
    
    private(set) var cards: [Card] = []
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, _ createCardContent: (Int) -> CardContent) {
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // 当前已经有一张被选中
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                // 刚选择第一张（归位其他）
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
}
