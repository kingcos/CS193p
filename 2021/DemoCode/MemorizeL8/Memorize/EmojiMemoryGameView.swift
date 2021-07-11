//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by CS193p Instructor on 3/29/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // our ViewModel
    @ObservedObject var game: EmojiMemoryGame
    
    // a token which provides a namespace for the id's used in matchGeometryEffect
    @Namespace private var dealingNamespace
    
    // our body
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    // private state used to temporary track
    //  whether a card has been dealt or not
    // contains id's of MemoryGame<String>.Cards
    @State private var dealt = Set<Int>()
    
    // marks the given card as having been dealt
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    // returns whether the given card has not been dealt yet
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    // an Animation used to deal the cards out "not all at the same time"
    // the Animation is delayed depending on the index of the given card
    //  in our ViewModel's (and thus our Model's) cards array
    // the further the card is into that array, the more the animation is delayed
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    // returns a Double which is a bigger number the closer a card is to the front of the cards array
    // used by both of our matchedGeometryEffect CardViews
    //  so that they order the cards in the "z" direction in the same way
    // (the "z" direction is the direction going up out of the device towards the user)
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    // the body of the game itself
    // (i.e. not include any of the control buttons or the deck)
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    // see other CardView below that has same matchedGeometryEffect
                    // if that one arrives/departs the UI
                    // at the same time that we are departing/arriving
                    // then the arriving one will fly across the screen (and resize)
                    // from where the departing one left
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    // removal: .scale makes matched cards shrink out of existence
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        // animate the user Intent function that chooses a card
                        // (using the default animation)
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    // the body of the deck from which we deal the cards out
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    // see other matchedGeometryEffect above
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    // removal: .identity here because removal of this CardView
                    // is actually going to be animated by the matchedGeometryEffect
                    // so we don't want it to ALSO fade or scale out
                    // (since transitions and matchedGeometryEffects are not mutually exclusive)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        // generally using magic numbers as arguments to frame(width:height:)
        // should be avoided
        // much better to let Views naturally lay themselves out if possible
        // but here, it's not clear what the "natural size" of a deck would be
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            // "deal" cards
            // note that this is not calling a user Intent function
            // (instead it is just setting some of our private @State)
            // that's because "dealing" is purely a temporary UI/animation thing
            // it has nothing to do with our Model
            // because "dealing" is not part of the Memorize game logic
            // (dealing IS part of some card games, for example, Set)
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            // animated user Intent function call
            // TODO: YOU MUST ADD THIS INTENT FUNC TO YOUR VIEWMODEL
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            // animated user Intent function call
            // and, at the same time, resetting our local "dealing" private State
            // TODO: YOU MUST ADD THIS INTENT FUNC TO YOUR VIEWMODEL
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Group is a "bag of Lego" container
                // it's useful for propagating view modifiers to multiple views
                // (as we are doing below, for example, with opacity)
                Group {
                    // card.isConsumingBonusTime is changed by the Model quite often
                    // it changes any time a card's isFaceUp changes (or isMatched)
                    // so the two Pies here are swapping back and forth as isFaceUp changes
                    // any time we are not consuming bonus time, the lower Pie appears
                    // (it is not animated and is just showing how much time is left)
                    // any time we ARE consuming bonus time, the upper Pie appears
                    // and when it appears (onAppear), it starts animating its own endAngle
                    // by first setting its animatedBonusRemaining to however much time is remaining
                    // then animating setting that to zero inside an explicit animation
                    // (and since this represents a change to animatedBonusRemaining, it will animate that change)
                    // if isConsumingBonusTime changes in the middle of the animation
                    // the top Pie below will simply be removed from the UI and the animation abandoned
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    // only view modifiers ABOVE this .animation call are animated by it
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .padding(5)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    // view modifications like this .scaleEffect are not affected by the call to .animation ABOVE it
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            // this is the same as .modifier(Cardify(isFaceUp: card.isFaceUp))
            // it turns our ZStack with a Pie and a Text in it into a "card" on screen
            // it does this by just returning its own ZStack with RoundedRectangles and such in it
            // see Cardify.swift
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    // the "scale factor" to scale our Text up so that it fits the geometry.size offered to us
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
        
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        // flip over the first card just so our Preview is always showing one face up card
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
