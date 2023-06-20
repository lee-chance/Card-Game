//
//  ROBConnectionManager.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import Foundation
import MultipeerConnectivity

final class ROBConnectionManager: NSObject, ObservableObject {
    let session: MCSession
    private let myPeerID: MCPeerID
    
    private static let service = "rob-service"
    private var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    private var nearbyServiceBrowser: MCNearbyServiceBrowser
    
    @Published var rooms: [MCPeerID] = []
    @Published var receivedCard: Card?
    @Published var paired = false
    @Published var receivedInvite = false
    @Published var host: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    var isHostPlayer: Bool {
        host == nil
    }
    
    init(username: String) {
        myPeerID = MCPeerID(displayName: username)
        
        session = MCSession(
            peer: myPeerID,
            securityIdentity: nil,
            encryptionPreference: .none
        )
        
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(
            peer: myPeerID,
            discoveryInfo: nil,
            serviceType: ROBConnectionManager.service
        )
        
        nearbyServiceBrowser = MCNearbyServiceBrowser(
            peer: myPeerID,
            serviceType: ROBConnectionManager.service
        )
        
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    func start() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stop() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
        nearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    func exit() {
        session.disconnect()
        host = nil
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        nearbyServiceBrowser.invitePeer(
            peerID,
            to: session,
            withContext: nil,
            timeout: TimeInterval(120)
        )
    }
    
    func send(_ card: Card) {
        guard !session.connectedPeers.isEmpty else { return }
        
        do {
            let cardData = try JSONEncoder().encode(card)
            let peers = session.connectedPeers
            try session.send(cardData, toPeers: peers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ROBConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //TODO: Inform the user something went wrong and try again
        print("didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        print("didReceiveInvitationFromPeer \(peerID)")
        
        DispatchQueue.main.async {
            self.receivedInvite = true
            self.host = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension ROBConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //TODO: Tell the user something went wrong and try again
        print("didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String : String]?
    ) {
        DispatchQueue.main.async {
            if !self.rooms.contains(peerID) {
                self.rooms.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let index = self.rooms.firstIndex(of: peerID) else { return }
            self.rooms.remove(at: index)
        }
    }
}

extension ROBConnectionManager: MCSessionDelegate {
    func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        switch state {
        case .connected:
            print("Connected")
            DispatchQueue.main.async {
                self.paired = true
            }
            nearbyServiceAdvertiser.stopAdvertisingPeer()
            break
            
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.paired = false
            }
            nearbyServiceAdvertiser.startAdvertisingPeer()
            break
            
        case .connecting:
            print("Connecting to: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown stat: \(state)")
        }
    }
    
    func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID
    ) {
        guard let card = try? JSONDecoder().decode(Card.self, from: data) else {
            return
        }
        
        DispatchQueue.main.async {
            self.receivedCard = card
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceive")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        print("didReceiveCertificate")
        certificateHandler(true)
    }
}
