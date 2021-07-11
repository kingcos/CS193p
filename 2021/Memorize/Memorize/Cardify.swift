//
//  Cardify.swift
//  Memorize
//
//  Created by kingcos on 2021/7/11.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        if isFaceUp {
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            content
        } else {
            shape
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
