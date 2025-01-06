//
//  MainScreenViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class MainScreenViewModel: ObservableObject{
    @Published var temperature: String = "empty"
    private weak var coordinator: MainViewEventHandling?
    let apiManager: APIManaging
    
    init(apiManager: APIManaging, coordinator: MainViewEventHandling? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator
    }
    
    
    func send(_ action: Action) {
        switch action {
        case .didTapNewsItem(let newsItem):
            coordinator?.handle(event: .detailNews(newsItem))
        case .didTapStockPreview(let stockItem):
            coordinator?.handle(event: .detailStockPreview(stockItem))

        }
    }
    
    
}

extension MainScreenViewModel{
    @MainActor
    func fetchWeatherData() {

        Task {
            do {
                let weatherData: StockData = try await apiManager.request(
                    StockDataRouter.cryptoPrice(
                        symbol: "BTC-USD"
                    )
                )
                let openValues = weatherData.chart.result[0].indicators.quote[0].open
                let firstFiveValues = openValues.prefix(5)
                
                self.temperature = firstFiveValues
                    .map { String($0 ?? 0) } // prevod na string
                    .joined(separator: "\n")
                
                print(self.temperature)


            } catch {
                print(error)
            }
        }
    }
}


// MARK: Event
extension MainScreenViewModel {
    enum Event {
        case detailNews(NewsItem)
        case detailStockPreview(StockItem)
    }
}

// MARK: Action
extension MainScreenViewModel {
    enum Action {
        case didTapNewsItem(NewsItem)
        case didTapStockPreview(StockItem)
    }
}
