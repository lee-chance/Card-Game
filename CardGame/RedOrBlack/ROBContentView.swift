//
//  ROBContentView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import SwiftUI

struct ROBContentView: View {
    @StateObject private var connection: ROBConnectionManager
    
    init(username: String) {
        self._connection = StateObject(wrappedValue: ROBConnectionManager(username: username))
    }
    
    var body: some View {
        Group {
            if connection.paired {
                ROBGameView()
            } else {
                ROBRobbyView()
            }
        }
        .environmentObject(connection)
    }
}

struct ROBContentView_Previews: PreviewProvider {
    static var previews: some View {
        ROBContentView(username: "Previewer")
    }
}
