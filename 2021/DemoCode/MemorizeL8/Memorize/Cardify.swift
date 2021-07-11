//
//  Cardify.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/19/21.
//

import SwiftUI

// AnimatableModifier is just a combo of the Animatable and ViewModifier protocols
struct Cardify: AnimatableModifier {
    // views that use us only think of isFaceUp-ness
    // but we think in terms of rotation
    // (since we can animate our rotation)
    // so this init is a convenience for views that use us
    // (we just turn isFaceUp to the appropriate rotation)
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    // this is the var in the Animatable protocol
    // (which the protocol AnimatableModifier inherits)
    // in our case, it is computed to just set/get the value of our rotation var
    // (since our rotation is the thing we animate)
    // this will be called repeatedly as the animation system breaks
    // any animation of our rotation into little pieces
    // (and our body will get invalidated and recalculated)
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    // how far around we are (in degrees)
    // from 0 (fully face up) to 180 (fully face down)
    var rotation: Double // in degrees
    
    // our body
    // basically the same as our Memorize CardView's body was in previous lectures
    // the only difference is that what's on the card is the given content argument
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            // we don't put this inside the "if rotation < 90"
            // because we don't want our content being removed and put back into the UI all the time
            // we want it to stay in the UI, but be hidden from the user when we're face down
            // (i.e. opacity = 0 when rotation >= 90)
            // we do this so that any animations on content can be started even while we're face down
            // (even though we're hiding them until the card goes back face up)
            // otherwise, only changes to the content while we're face up can be animated
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        // above we are showing or hiding the front/back as rotation passes 90
        // here we are doing the actual 3D rotation effect for however many degrees we've rotated
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

// add the cardify(isFaceUp:) func to the View protocol
// purely syntactic sugar for views that want to use our Cardify view modifier
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
