//
//  StockData.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
// MARK: Weather data models
struct StockData: Codable {
    let daily: Daily
}

struct Daily: Codable {
    let time: [String]
    let maxTemperatures: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case maxTemperatures = "temperature_2m_max"
    }
}
