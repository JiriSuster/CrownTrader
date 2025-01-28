//
//  WatchConnector.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject{
    weak var delegate: WatchConnectorDelegate?
    private var session: WCSession
    @Published var messageText : String = ""
    @Published var messageDate : Date = .now
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    
    func sendToWatch(stock: StockItem, action: String){
        if(session.isReachable){
            
            let data : [String : Any] = [
                "amount" : stock.ammount,
                "price_when_bought" : stock.priceWhenBought ?? stock.price,
                "action": action,
                "symbol": stock.symbol,
                "name": stock.title,
                "price": stock.price,
                "is_watchlist": stock.is_watchlist ?? false,
                "is_snaps": stock.is_snaps ?? false,
                "percent_change": stock.percentChange ?? 0
                
            ]
            session.sendMessage(data, replyHandler: nil)
        }else{
            print("session not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //dosel mi slovnik a ja ho potrebuju rozparsovat
        print(message)
        DispatchQueue.main.async{
            let amount = message["amount"] as? Double ?? 0
            let action = message["action"] as? String ?? ""
            let price_when_bought = message["price_when_bought"] as? Double ?? 0
            let symbol = message["symbol"] as? String ?? ""
            let name = message["name"] as? String ?? ""
            let price = message["price"] as? Double ?? 0
            let is_watchlist = message["is_watchlist"] as? Bool ?? false
            let is_snaps = message["is_snaps"] as? Bool ?? false
            let percentChange = message["percent_change"] as? Double ?? 0
            
            let stock = StockItem(
                                symbol: symbol,
                                title: name,
                                price: price,
                                percentChange: percentChange,
                                ammount: amount,
                                priceWhenBought: price_when_bought,
                                is_watchlist: is_watchlist,
                                is_snaps: is_snaps
            )
            self.delegate?.didReceiveDeleteStock(stock, isWatchlist: is_watchlist)
            
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:WCSessionActivationState, error: (any Error)?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    
    
}

protocol WatchConnectorDelegate: AnyObject {
    func didReceiveDeleteStock(_ stock: StockItem, isWatchlist: Bool)
}
