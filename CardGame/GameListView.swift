//
//  GameListView.swift
//  CardGame
//
//  Created by 이창수 on 2023/06/15.
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

struct GameListView: View {
    @Binding var nickname: String
    @State private var game: Game?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Welcome, \(nickname)!")
                
                Spacer()
                
                Button("Logout") {
                    nickname = ""
                }
            }
            .padding()
            
            List(Game.allCases) { game in
                Button(game.name) {
                    self.game = game
                }
            }
        }
        .fullScreenCover(item: $game, content: openGame)
    }
    
    @ViewBuilder
    func openGame(_ game: Game) -> some View {
        switch game {
        case .redOrBlack:
            ROBContentView(username: nickname)
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(nickname: .constant(""))
    }
}
