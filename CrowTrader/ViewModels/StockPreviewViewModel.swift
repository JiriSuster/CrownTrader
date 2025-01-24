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
                    ),meta: MetaQuote(symbol: "",shortName: "")
                )
            ]
        )
    )
    @Published var latestPrice: Double = 0
    @Published var average: (thirty: Double, sixty: Double) = (0,0)
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
    }
}

// MARK: Action
extension StockPreviewViewModel{
    enum Action{
        case appear(String)
        case addToWatchlistClick(StockItem)
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
    
    private func getAverage(days: Int) -> Double {
            guard
                  let closePrices = chartData.close else {
                print("No data available for the given symbol.")
                return -1.0
            }
            
            let validPrices = closePrices.compactMap { $0 } // filter out nil vals
            let count = validPrices.count
            
            guard count >= days else {
                print("Not enough data points for the given number of days.")
                return -1.0
            }
            
            let recentPrices = validPrices.suffix(days)
            
            let averagePrice = recentPrices.reduce(0, +) / Double(recentPrices.count)
            return averagePrice
        }
    
    func setAverage(){
        self.average = (getAverage(days: 30), getAverage(days: 60))
    }
    
}
