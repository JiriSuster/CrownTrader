//
//  MoversDataRouter.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation

enum MoversDataRouter: Endpoint {
    case search(top: Int)
    var headers: [String : String] {
        return ["APCA-API-KEY-ID":ProcessInfo.processInfo.environment["MARKET_MOVERS_API_KEY"]!,
                "APCA-API-SECRET-KEY":ProcessInfo.processInfo.environment["MARKET_MOVERS_SECRET"]!,
                "Accept":"application/json"]
    }
    
    var host: String {
            return "https://data.alpaca.markets"
        }
    
    
    var path: String {
        switch self {
        case .search:
            return "/v1beta1/screener/stocks/movers"
        }
    }

    var urlParameters: [String: Any] {
        switch self {
        case let .search(top):
            return ["top": String(top)]
        }
    }
}

