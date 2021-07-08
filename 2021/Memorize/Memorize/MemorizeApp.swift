//
//  MemorizeApp.swift
//  Memorize
//
//  Created by kingcos on 2021/7/4.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
