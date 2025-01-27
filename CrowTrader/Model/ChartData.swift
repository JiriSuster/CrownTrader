//
//  ChartData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation
import SwiftUI

struct ChartPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

// MARK: Chart data models
struct ChartData: Codable {
    let chart: ChartQuote
    
}

struct ChartQuote: Codable {
    let result: [ChartResult]
}

struct ChartResult: Codable {
    let timestamp: [Int]?
    let indicators: Indicators
    let meta: MetaQuote
}

struct Indicators: Codable {
    let quote: [Quote]
}

struct Quote: Codable {
    let close: [Double?]?
    let high: [Double?]?
    let open: [Double?]?
    let low: [Double?]?
    let volume: [Int?]?

    enum CodingKeys: String, CodingKey {
        case close, high, open, low, volume
    }
}
struct MetaQuote: Codable {
    let symbol: String
    let shortName: String
    let regularMarketPrice: Double
    let regularMarketVolume: Double
}


extension ChartData {
    //computed for chart
    var chartPoints: [ChartPoint] {
        guard let timestamps = timestamp,
              let prices = close else { return [] }
        
        return zip(timestamps, prices).compactMap { timestamp, price in
            guard let price = price else { return nil }
            return ChartPoint(
                date: Date(timeIntervalSince1970: TimeInterval(timestamp)),
                price: price
            )
        }
    }
    
    var priceRange: (min: Double, max: Double) {
        let prices = chartPoints.map { $0.price }
        return (
            min: prices.min() ?? 0,
            max: prices.max() ?? 0
        )
    }
}


extension ChartData{
    //computed for easier access
    var name: String {
        chart.result[0].meta.shortName
        }
    
    var symbol: String {
        chart.result[0].meta.symbol
        }
    
    var timestamp: [Int]? {
        chart.result[0].timestamp
        }
    
    var close: [Double?]? {
        chart.result[0].indicators.quote[0].close
        }
    
    var high: [Double?]? {
        chart.result[0].indicators.quote[0].high
        }
    
    var open: [Double?]? {
        chart.result[0].indicators.quote[0].open
        }
    
    var low: [Double?]? {
        chart.result[0].indicators.quote[0].low
        }
    
    var volume: [Int?]? {
        chart.result[0].indicators.quote[0].volume
        }
    var latestPrice: Double? {
        chart.result[0].meta.regularMarketPrice
    }
    
    var latestVolume: Double? {
        chart.result[0].meta.regularMarketVolume
    }
    

    var percentChange24Hours: Double? {
        
        guard let timestamps = timestamp, !timestamps.isEmpty else {
            print("timestamps is nil or empty")
            return nil
        }

        guard let closes = close, !closes.isEmpty else {
            print("closes is nil or empty")
            return nil
        }

        guard timestamps.count == closes.count else {
            print("timestamps and closes count do not match")
            return nil
        }

        guard let latestTimestamp = timestamps.compactMap({$0}).last else {
            print("timestamps.last is nil")
            return nil
        }

        guard let latestClose = closes.compactMap({ $0 }).last else {
            print("No non-nil values in closes")
            return nil
        }

        
        let latestDate = Date(timeIntervalSince1970: TimeInterval(latestTimestamp))
        let twentyFourHoursAgo = latestDate.addingTimeInterval(-86400)
        let fromTimestamp = Int(twentyFourHoursAgo.timeIntervalSince1970)
        
        let startIndex = timestamps.firstIndex(where: { $0 >= fromTimestamp }) ?? 0
        
        guard startIndex < closes.count,
              let startClose = closes[startIndex] else {
            debugPrint(2)
            return nil
        }
        
        guard startClose != 0 else {
            debugPrint(3)
            return nil
        }
        
        let percentageChange = ((latestClose - startClose) / startClose) * 100
        return (percentageChange * 100).rounded() / 100
    }
}
