//
//  MoversData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation

// MARK: Movers data models
struct MoversData: Codable {
    let gainers: [MarketItemQuery]
    let losers: [MarketItemQuery]
    let last_updated: String
    let market_type: String
}

struct MarketItemQuery: Codable {
    let change: Double
    let percent_change: Double
    let price: Double
    let symbol: String
}
