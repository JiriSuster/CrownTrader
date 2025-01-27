//
//  StockPreviewViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 06.01.2025.
//

import Foundation

class StockPreviewViewModel: ObservableObject{
    @Published var stockItem: StockItem? = StockItem(symbol: "", title: "", price: 1,percentChange: 0, ammount: 1)
    @Published var chartData = ChartData(
        chart: ChartQuote(
            result: [
                ChartResult(
                    timestamp: [],
                    indicators: Indicators(
                        quote: [
                            Quote(
                                close: [],
                                high: [],
                                open: [],
                                low: [],
                                volume: []
                            )
                        ]
                    ),meta: MetaQuote(symbol: "",shortName: "",regularMarketPrice: 0,regularMarketVolume: 0)
                )
            ]
        )
    )
    @Published var latestPrice: Double = 0
    @Published var average: (thirty: Double?, sixty: Double?) = (0,0)
    let apiManager: APIManaging
    private weak var coordinator: StockPreviewEventHandling?
    
    init(apiManager: APIManaging, coordinator: StockPreviewEventHandling? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator 
    }
    
    func send(_ action: Action) {
        switch action{
            
        case .appear(let symbol):
            coordinator?.handle(event: .fetchChart(symbol))
            
        case .timeframeSelected(let symbol, let timeframe):
            coordinator?.handle(event: .updateTimeFrame(symbol, timeframe))
            
        case .addToWatchlistClick(let stock):
            coordinator?.handle(event: .addToWatchlist(stock))
            
        case .addToSnapslistClick(let stock, let amount):
            coordinator?.handle(event: .addToSnapslist(stock,amount))
        }
    }
    
    
}

// MARK: Event
extension StockPreviewViewModel{
    enum Event{
        case updateTimeFrame(String, String)
        case fetchChart(String)
        case close
        case addToWatchlist(StockItem)
        case addToSnapslist(StockItem, String)
    }
}

// MARK: Action
extension StockPreviewViewModel{
    enum Action{
        case appear(String)
        case addToWatchlistClick(StockItem)
        case addToSnapslistClick(StockItem, String)
        case timeframeSelected(String, String)
        
    }
}

//MARK: API
@MainActor
extension StockPreviewViewModel {
    @MainActor
    func fetchChart(symbol: String, timeframe: String? = "1d") {
        Task{
            do {
                let chartDataResponse: ChartData = try await apiManager.request(
                    StockDataRouter.chart(
                        symbol: symbol, timeframe: timeframe
                    )
                )
                self.chartData = chartDataResponse
                self.setAverage() //TODO: move out
            } catch {
                print(error)
            }
        }
    }
}


//MARK: calculations
@MainActor
extension StockPreviewViewModel{
    func getLatestPrice() {
        latestPrice = chartData.latestPrice ?? 0
    }
    
    private func getAverage(days: Int, chart: ChartData) -> Double? {
        guard let closePrices = chart.close, !closePrices.isEmpty else {
            print("No close prices available.")
            return nil
        }
        
        let validPrices = closePrices.compactMap { $0 }
        guard validPrices.count >= days else {
            print("Not enough data points.")
            return nil
        }
        
        let recentPrices = validPrices.suffix(days)
        return recentPrices.reduce(0, +) / Double(days)
    }
    
    func setAverage() {
        Task {
            do {
                let chartDataResponse: ChartData = try await apiManager.request(
                    StockDataRouter.chart(symbol: chartData.symbol, timeframe: "3mo")
                )
                let avg30 = getAverage(days: 30, chart: chartDataResponse)
                let avg60 = getAverage(days: 60, chart: chartDataResponse)
                self.average = (avg30, avg60)
            } catch {
                print("Error fetching chart: \(error)")
            }
        }
    }
}
