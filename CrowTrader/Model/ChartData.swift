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
}
