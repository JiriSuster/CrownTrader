//
//  StockItem.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 13.01.2025.
//

import Foundation
import SwiftUI

struct StockItem: Identifiable {
    var id = UUID()
    var symbol: String
    var title: String
    var price: Double
    var percentChange: Double?
    var ammount: Double
    var priceWhenBought: Double?
    var is_watchlist: Bool?
    var is_snaps: Bool?
    var profit: Double?
    var color: Color {
        guard let percentChange = percentChange else {
            return Color.black //default
        }
        return percentChange > 0 ? Color.green : Color.red
    }
}
