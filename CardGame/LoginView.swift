//
//  LoginView.swift
//  CardGame
//
//  Created by 이창수 on 2023/06/15.
//

import SwiftUI

struct LoginView: View {
    @Binding var nickname: String
    @State private var internalNickname: String = ""
    
    var body: some View {
        VStack {
            TextField("nickname", text: $internalNickname)
                .textFieldStyle(.roundedBorder)
            
            Button("Join") {
                if !internalNickname.isEmpty {
                    nickname = internalNickname
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(nickname: .constant(""))
    }
}
