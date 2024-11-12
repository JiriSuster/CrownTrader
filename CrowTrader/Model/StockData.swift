//
//  StockData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

// MARK: - Stock data models
struct StockData: Codable {
    let chart: Chart
}

struct Chart: Codable {
    let result: [ChartResult]
    let error: String?
}

struct ChartResult: Codable {
    let meta: Meta
    let timestamp: [Int]
    let indicators: Indicators
}

struct Meta: Codable {
    let currency: String
    let symbol: String
    let exchangeName: String
    let fullExchangeName: String
    let instrumentType: String
    let firstTradeDate: Int
    let regularMarketTime: Int
    let hasPrePostMarketData: Bool
    let gmtoffset: Int
    let timezone: String
    let exchangeTimezoneName: String
    let regularMarketPrice: Float
    let fiftyTwoWeekHigh: Float
    let fiftyTwoWeekLow: Float
    let regularMarketDayHigh: Float
    let regularMarketDayLow: Float
    let regularMarketVolume: Int
    let longName: String?
    let shortName: String
    let chartPreviousClose: Float
    let previousClose: Float
    let scale: Int
    let priceHint: Int
    let currentTradingPeriod: CurrentTradingPeriod
    let tradingPeriods: [[TradingPeriod]]
    let dataGranularity: String
    let range: String
    let validRanges: [String]
}

struct CurrentTradingPeriod: Codable {
    let pre: TradingSession
    let regular: TradingSession
    let post: TradingSession
}

struct TradingSession: Codable {
    let timezone: String
    let end: Int
    let start: Int
    let gmtoffset: Int
}

struct TradingPeriod: Codable {
    let timezone: String
    let end: Int
    let start: Int
    let gmtoffset: Int
}

struct Indicators: Codable {
    let quote: [Quote]
}

struct Quote: Codable {
    let open: [Float?]
    let low: [Float?]
    let close: [Float?]
    let volume: [Int?]
}
