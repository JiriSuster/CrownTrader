//
//  StockDataRouter.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

enum WeatherDataRouter: Endpoint {
    case dailyMaxTemperature(long: Double, lat: Double)

    var path: String {
        "/v1/forecast"
    }

    var urlParameters: [String : Any] {
        switch self {
        case let .dailyMaxTemperature(long, lat):
            ["longitude": long, "latitude": lat, "daily": "temperature_2m_max"]
        }

    }
}
