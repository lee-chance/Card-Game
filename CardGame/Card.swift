//
//  Card.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/25.
//

import SwiftUI

struct Card {
    let suit: Suit
    let rank: Rank
    
    enum Suit: Character, CaseIterable {
        case spades = "♠︎", hearts = "♥", diamonds = "♦", clubs = "♣︎"
        
        var color: Color {
            switch self {
            case .spades, .clubs:
                return .black
            case .hearts, .diamonds:
                return .red
            }
        }
    }
    
    enum Rank: Int, CaseIterable {
        case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
        
        var symbol: String {
            switch self {
            case .ace:
                return "A"
            case .jack:
                return "J"
            case .queen:
                return "Q"
            case .king:
                return "K"
            default:
                return String(self.rawValue)
            }
        }
    }
    
    static func deck() -> [Card] {
        var deck = [Card]()
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                deck.append(Card(suit: suit, rank: rank))
            }
        }
        return deck
    }
}

extension Card: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(String(rank.symbol))
                    .bold()
                    .foregroundColor(suit.color)
                
                Text(String(suit.rawValue))
                    .foregroundColor(suit.color)
            }
            .padding()
        }
        .aspectRatio(CGSize(width: 5, height: 7), contentMode: .fit)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black)
        )
    }
}

struct CardBack: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Stripes(foreground: color)
                .padding(8)
        }
        .aspectRatio(CGSize(width: 5, height: 7), contentMode: .fit)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black)
        )
    }
}

struct CardBuilder: View {
    let suit: Card.Suit
    let rank: Card.Rank
    let color: Color
    
    @State private var flipped = false
    @State private var cardRotate: Double = 0
    @State private var contentRotate: Double = 0
    
    var body: some View {
        ZStack {
            if flipped {
                Card(suit: suit, rank: rank)
            } else {
                CardBack(color: color)
            }
        }
        .rotation3DEffect(.degrees(contentRotate), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            let animationDuration: Double = 0.4
            withAnimation(.linear(duration: animationDuration)) {
                cardRotate += 180
            }
            
            withAnimation(.linear(duration: 0.001).delay(animationDuration / 2)) {
                contentRotate += 180
                flipped.toggle()
            }
        }
        .rotation3DEffect(.degrees(cardRotate), axis: (x: 0, y: 1, z: 0))
    }
}

struct Card_Previews: PreviewProvider {
    struct Wrapper: View {
        var body: some View {
            VStack {
                Card(suit: .hearts, rank: .six)
                    .frame(width: 80)
                
                CardBuilder(suit: .diamonds, rank: .jack, color: .red)
                    .frame(width: 100)
                
                CardBack(color: .blue)
                    .frame(width: 100)
                
                Card(suit: .clubs, rank: .king)
                    .frame(width: 120)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}

struct StripesConfig {
    var background: Color
    var foreground: Color
    var degrees: Double
    var barWidth: CGFloat
    var barSpacing: CGFloat
    
    init(
        background: Color = Color.white,
        foreground: Color = Color.black,
        degrees: Double = 45,
        barWidth: CGFloat = 10,
        barSpacing: CGFloat = 10
    ) {
        self.background = background
        self.foreground = foreground
        self.degrees = degrees
        self.barWidth = barWidth
        self.barSpacing = barSpacing
    }
    
    static let `default` = StripesConfig()
}

struct Stripes: View {
    var config: StripesConfig
    
    init(config: StripesConfig = .default) {
        self.config = config
    }
    
    init(
        background: Color = Color.white,
        foreground: Color = Color.black,
        degrees: Double = 45,
        barWidth: CGFloat = 10,
        barSpacing: CGFloat = 10
    ) {
        self.config = StripesConfig(background: background, foreground: foreground, degrees: degrees, barWidth: barWidth, barSpacing: barSpacing)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let longSide = max(geometry.size.width, geometry.size.height)
            let itemWidth = config.barWidth + config.barSpacing
            let items = Int(2 * longSide / itemWidth)
            HStack(spacing: config.barSpacing) {
                ForEach(0..<items, id: \.self) { index in
                    config.foreground
                        .frame(width: config.barWidth, height: 2 * longSide)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(Angle(degrees: config.degrees), anchor: .center)
            .offset(x: -longSide / 2, y: -longSide / 2)
            .background(config.background)
        }
        .clipped()
    }
}
