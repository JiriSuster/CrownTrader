//
//  NewsDataRouter.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation

enum NewsDataRouter: Endpoint {
    case search
    
    var host: String {
            return "https://min-api.cryptocompare.com"
        }
    
    var path: String {
        switch self {
        case .search:
            return "/data/v2/news/"
        }
    }

    var urlParameters: [String: Any] {
        switch self {
        case .search:
            return ["lang": "EN", "api_key":ProcessInfo.processInfo.environment["NEWS_API_KEY"]!]
        }
    }
}
