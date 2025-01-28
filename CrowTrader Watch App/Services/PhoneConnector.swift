

import Foundation
import WatchConnectivity

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject{
    private var session: WCSession
    
    @Published var messageText : String = ""
    @Published var messageDate : Date = .now
    @Published var watchList: [StockItem] = []
    @Published var snapsList: [StockItem] = []
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:WCSessionActivationState, error: (any Error)?) {}
    
    func sendToPhone(stock: StockItem){
        if(stock.is_snaps ?? false){
            self.snapsList.removeAll { $0.symbol == stock.symbol }
        }
        else if (stock.is_watchlist ?? false){
            self.watchList.removeAll { $0.symbol == stock.symbol }
        }
        if(session.isReachable){
            let data : [String : Any] = [
                "amount" : stock.ammount,
                "price_when_bought" : stock.priceWhenBought ?? stock.price,
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
        print(message)
        DispatchQueue.main.async{
            let amount = message["amount"] as? Double ?? 0
            let price_when_bought = message["price_when_bought"] as? Double ?? 0
            let action = message["action"] as? String ?? ""
            let symbol = message["symbol"] as? String ?? ""
            let name = message["name"] as? String ?? ""
            let price = message["price"] as? Double ?? 0
            let is_watchlist = message["is_watchlist"] as? Bool ?? false
            let is_snaps = message["is_snaps"] as? Bool ?? false
            let percentChange = message["percent_change"] as? Double ?? 0
            
            if action == "ADD" {
                if is_watchlist {
                    self.watchList.append(StockItem(symbol: symbol, title: name, price: price, percentChange: percentChange, ammount: amount,priceWhenBought: price_when_bought,is_watchlist: is_watchlist, is_snaps: is_snaps))
                }
                if is_snaps {
                    self.snapsList.append(StockItem(symbol: symbol, title: name, price: price, percentChange: percentChange, ammount: amount,priceWhenBought: price_when_bought,is_watchlist: is_watchlist, is_snaps: is_snaps))
                }
            } else if action == "DELETE" {
                if is_watchlist {
                    self.watchList.removeAll { $0.symbol == symbol }
                }
                if is_snaps {
                    self.snapsList.removeAll { $0.symbol == symbol }
                }
            }
            
        }
    }
    
    
}

