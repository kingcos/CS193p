//
//  MemorizeApp.swift
//  Memorize
//
//  Created by kingcos on 2021/7/4.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
