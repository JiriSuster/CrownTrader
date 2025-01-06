//
//  StockDataRouter.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

enum StockDataRouter: Endpoint {
    case search(symbol: String) //can be typed by user with mistakes
    case chart(symbol: String) //has to be correct
    case info(symbol: String)
    
    var host: String {
            return "https://query2.finance.yahoo.com"
        }
    
    
    var path: String {
        switch self {
        case .search:
            return "/v1/finance/search"
        case let .chart(symbol):
            return "/v8/finance/chart/\(symbol)"
        case .info(symbol: let symbol):
            return "/v1/finance/quoteType/\(symbol)"
        }
    }

    var urlParameters: [String: Any] {
        switch self {
        case let .search(symbol):
            return ["q": symbol]
        case .chart:
            return [:]
        case .info:
            return [:]
        }
    }
}
