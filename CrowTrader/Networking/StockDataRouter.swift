//
//  StockDataRouter.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

enum StockDataRouter: Endpoint {
    case cryptoPrice(symbol: String)

    var path: String {
        switch self {
        case .cryptoPrice(let symbol):
            return "/v8/finance/chart/\(symbol)" //symbol je soucasti cesty, neni argument...
        }
    }

    var urlParameters: [String : Any] {
        return [:]
    }
}
