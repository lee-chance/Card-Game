//
//  ContentView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Card(suit: .clubs, rank: .ace)
                .frame(width: 80)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                ForEach(Card.Rank.allCases, id: \.rawValue) { rank in
                    CardBuilder(suit: .clubs, rank: rank, color: .black)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
