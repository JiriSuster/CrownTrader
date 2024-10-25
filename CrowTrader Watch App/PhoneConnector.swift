//
//  PhoneConnector.swift
//  CrowTrader Watch App
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
import WatchConnectivity

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject{
    private var session: WCSession
    
    @Published var messageText : String = ""
    @Published var messageDate : Date = .now
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:WCSessionActivationState, error: (any Error)?) {}
    
    func sendToPhone(){
        if(session.isReachable){
            let data : [String : Any] = [
                "text": messageText,
                "date": messageDate
            ]
            session.sendMessage(data, replyHandler: nil)
        }else{
            print("session not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        DispatchQueue.main.async{
            self.messageText = message["text"] as? String ?? ""
            self.messageDate = message["date"] as? Date ?? .now
        }
    }
    
    
}

