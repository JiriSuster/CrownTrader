//
//  ChartData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation

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
        guard let closePrices = close, !closePrices.isEmpty else { return nil }
        return closePrices.compactMap { $0 }.last
    }
    

    var percentChange24Hours: Double? {
            guard let timestamps = timestamp, !timestamps.isEmpty,
                  let closes = close, !closes.isEmpty else {
                return nil
            }
            
            let twentyFourHoursAgo = Date().addingTimeInterval(-86400).timeIntervalSince1970
            let fromTimestamp = Int(twentyFourHoursAgo)
            
            guard let startIndex = timestamps.firstIndex(where: { $0 >= fromTimestamp }) else {
                return nil
            }
            
            guard startIndex < closes.count,
                  let yesterdayClose = closes[startIndex],
                  let latestPrice = closes.last! else {
                return nil
            }
            
            guard yesterdayClose != 0 else {
                return nil // Prevent division by zero
            }
            
            let percentageChange = ((latestPrice - yesterdayClose) / yesterdayClose) * 100
            let roundedChange = (percentageChange * 100).rounded() / 100 // Rounds to two decimal places
            return roundedChange
        }
}
