//
//  ROBGameView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import SwiftUI

struct ROBGameView: View {
    @EnvironmentObject private var connection: ROBConnectionManager
    
    @State private var timeLeft = 10
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var myHand: ROBPlayerHand = .empty
    @State private var otherHand: ROBPlayerHand = .empty
    
    private var otherLeftCards: [Card] {
        let blackCards = otherHand.leftCards.filter { $0.suit.isBlack }
        let redCards = otherHand.leftCards.filter { $0.suit.isRed }
        
        let maximum = max(blackCards.count, redCards.count)
        var result = [Card]()
        for index in 0..<maximum {
            if index < blackCards.count {
                result.append(blackCards[index])
            }
            
            if index < redCards.count {
                result.append(redCards[index])
            }
        }
        return result
    }
    
    @State private var result: ROBResult?
    
    var body: some View {
        VStack(spacing: 0) {
            // 상대방 패
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                ForEach(otherLeftCards, id: \.description) { card in
                    CardBack(color: card.suit.color)
                        .contentShape(Rectangle())
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                VStack {
                    Text("My Card")
                    
                    if let card = myHand.card {
                        card
                            .shadow(radius: result == .win ? 10 : 0)
                    } else {
                        CardBack(color: .white)
                    }
                    
                    Text(String(myHand.score))
                }
                .frame(width: 80)
                
                VStack {
                    Text(String(timeLeft))
                        .font(.title)
                        .onReceive(timer) { input in
                            if (timeLeft > 0) {
                                timeLeft -= 1
                            } else {
                                timer.upstream.connect().cancel()
                                
                                result = score(myCard: myHand.card, otherCard: otherHand.card)
                                
                                if result == .win { myHand.score += 1 }
                                if result == .lose { otherHand.score += 1 }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.setNextGame()
                                }
                            }
                        }
                    
                    Button("Exit", role: .destructive) {
                        connection.exit()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Player's")
                    
                    if let card = otherHand.card {
                        CardBack(color: card.suit.color)
                            .shadow(radius: result == .lose ? 10 : 0)
                    } else {
                        CardBack(color: .white)
                    }
                    
                    Text(String(otherHand.score))
                }
                .frame(width: 80)
                .onReceive(connection.$receivedCard) { card in
                    otherHand.card = card
                }
            }
            
            // 내 패
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                ForEach(myHand.leftCards, id: \.description) { card in
                    card
                        .onTapGesture {
                            if result == nil {
                                myHand.card = card
                                connection.send(card)
                            }
                        }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding(.horizontal)
        .onAppear {
            if connection.isHostPlayer {
                myHand = ROBPlayerHand(deck: Card.robCardSet1())
                otherHand = ROBPlayerHand(deck: Card.robCardSet2())
            } else {
                myHand = ROBPlayerHand(deck: Card.robCardSet2())
                otherHand = ROBPlayerHand(deck: Card.robCardSet1())
            }
        }
    }
    
    func score(myCard: Card?, otherCard: Card?) -> ROBResult {
        if myCard == nil, otherCard == nil { return .tie }
        
        guard let myCard else { return .lose }
        guard let otherCard else { return .win }
        
        if myCard.rank == .ace, otherCard.rank == .ten { return .win }
        if myCard.rank == .ten, otherCard.rank == .ace { return .lose }
        
        if myCard.rank == otherCard.rank { return .tie }
        if myCard.rank > otherCard.rank { return .win }
        
        return .lose
    }
    
    func setNextGame() {
        if myHand.leftCards.isEmpty || otherHand.leftCards.isEmpty {
            gameOver()
        } else {
            timeLeft = 10
            result = nil
            myHand.nextGame()
            otherHand.nextGame()
            timer = timer.upstream.autoconnect()
        }
    }
    
    func gameOver() {
        
    }
}

struct ROBGameView_Previews: PreviewProvider {
    static var previews: some View {
        ROBGameView()
            .environmentObject(ROBConnectionManager(username: "Previewer"))
    }
}
