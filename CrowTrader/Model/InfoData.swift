//
//  InfoData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation

struct InfoData: Codable {
    let quoteType: QuoteType
    
    
    //computed for easier access
    var market: String? {
            quoteType.result.first?.market
        }
    var symbol: String? {
            quoteType.result.first?.symbol
        }
    var shortName: String? {
            quoteType.result.first?.shortName
        }
    var longName: String? {
            quoteType.result.first?.longName
        }
}

struct QuoteType: Codable {
    let result: [QuoteResult]
}

struct QuoteResult: Codable {
    let symbol: String
    let shortName: String?
    let longName: String?
    let market: String?

    enum CodingKeys: String, CodingKey {
        case symbol
        case shortName
        case longName
        case market
    }
}
