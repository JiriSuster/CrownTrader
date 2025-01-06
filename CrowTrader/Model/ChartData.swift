//
//  ChartData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 02.01.2025.
//

import Foundation

// MARK: Chart data models
struct ChartData: Codable {
    let chart: Chart
    
    //computed for easier access
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

struct Chart: Codable {
    let result: [ChartResult]
}

struct ChartResult: Codable {
    let timestamp: [Int]?
    let indicators: Indicators
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
