//
//  ROBRobbyView.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import SwiftUI

struct ROBRobbyView: View {
    @EnvironmentObject private var connection: ROBConnectionManager
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isInvitingGame = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                
                Spacer()
                
                Text("Red or Black")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .opacity(0)
            }
            .padding(.horizontal)
            .frame(height: 48)
            
            List(connection.rooms, id: \.self) { room in
                Text(room.displayName)
                    .onTapGesture {
                        connection.invitePeer(room, to: .redOrBlack)
                    }
            }
        }
        .onAppear {
            connection.start()
        }
        .onDisappear {
            connection.stop()
        }
        .alert("Received an invite from \(connection.host?.displayName ?? "ERR")!", isPresented: $connection.receivedInvite) {
            Button("Accept", role: .destructive) {
                if (connection.invitationHandler != nil) {
                    connection.invitationHandler!(true, connection.session)
                }
            }
            
            Button("Cancel", role: .cancel) {
                if (connection.invitationHandler != nil) {
                    connection.invitationHandler!(false, nil)
                }
            }
        }
    }
}

struct ROBRobbyView_Previews: PreviewProvider {
    static var previews: some View {
        ROBRobbyView()
            .environmentObject(ROBConnectionManager())
    }
}
