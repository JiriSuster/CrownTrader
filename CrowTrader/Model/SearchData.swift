//
//  StockQuotes.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

// MARK: Stock data models
struct SearchData: Codable {
    let quotes: [StockQuote]
}

struct StockQuote: Codable {
    let symbol: String
    let shortname: String
    let longname: String?

    enum CodingKeys: String, CodingKey {
        case symbol
        case shortname
        case longname
    }
}
