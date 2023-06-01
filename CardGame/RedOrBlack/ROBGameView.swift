//
//  ROBGameView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import SwiftUI

struct ROBGameView: View {
    @State private var myDeck: [Card] = Card.robCardSet1()
    @State private var otherDeck: [Card] = Card.robCardSet2()
    
    @State private var myCard: Card?
    @State private var opponentsCard: Card?
    
    var body: some View {
        VStack(spacing: 0) {
            // 상대방 패
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                ForEach(otherDeck, id: \.description) { card in
                    CardBack(color: card.suit.color)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            opponentsCard = card
                        }
                }
            }
            
            Spacer()
            
            HStack {
                VStack {
                    Text("My Card")
                    
                    if let myCard {
                        myCard
                    } else {
                        CardBack(color: .white)
                    }
                }
                .frame(width: 80)
                
                VStack {
                    Text("10")
                        .font(.title)
                    
                    Button("Exit", role: .destructive) {
                        // TODO: Connection 끊기
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Player's")
                    
                    
                    if let opponentsCard {
                        CardBack(color: opponentsCard.suit.color)
                    } else {
                        CardBack(color: .white)
                    }
                }
                .frame(width: 80)
            }
            
            Spacer()
            
            // 내 패
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                ForEach(myDeck, id: \.description) { card in
                    card
                        .onTapGesture {
                            myCard = card
                        }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ROBGameView_Previews: PreviewProvider {
    static var previews: some View {
        ROBGameView()
    }
}
