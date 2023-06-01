//
//  ContentView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/25.
//

import SwiftUI

enum Game: Identifiable, CaseIterable {
    case redOrBlack
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .redOrBlack: return "Red or Black"
        }
    }
}

struct ContentView: View {
    @State private var game: Game?
    
    var body: some View {
        List(Game.allCases) { game in
            Button(game.name) {
                self.game = game
            }
        }
        .fullScreenCover(item: $game, content: openGame)
    }
    
    @ViewBuilder
    func openGame(_ game: Game) -> some View {
        switch game {
        case .redOrBlack:
            ROBContentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
