//
//  ContentView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var nickname: String = ""
    
    var body: some View {
        if nickname.isEmpty {
            LoginView(nickname: $nickname)
        } else {
            GameListView(nickname: $nickname)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
