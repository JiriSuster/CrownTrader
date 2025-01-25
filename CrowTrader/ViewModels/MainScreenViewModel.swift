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
    @Published var marketList = [
        StockItem(symbol: "^GSPC",title: "", price: 0, percentChange: 0, ammount: 0),
        StockItem(symbol: "^NDX",title: "", price: 0,percentChange: 0, ammount: 0),
        StockItem(symbol: "^DJI",title: "", price: 0,percentChange: 0, ammount: 0),
        StockItem(symbol: "^N225",title: "", price: 0,percentChange: 0, ammount: 0),
        StockItem(symbol: "^FTSE",title: "", price: 0,percentChange: 0, ammount: 0),
    ]
    @Published var testSearch: String = "empty"
    @Published var testChart: String = "empty"
    @Published var testInfo: String = "empty"
    @Published var testNews: String = "empty"
    @Published var testMovers: String = "empty"
    
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
    
    private weak var coordinator: MainViewEventHandling?
    let apiManager: APIManaging
    
    init(apiManager: APIManaging, coordinator: MainViewEventHandling? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator
    }
    
    
    func send(_ action: Action) {
        switch action {
        case .didTapStockPreview(let stockItem):
            coordinator?.handle(event: .detailStockPreview(stockItem))

        case .didTapStock(let stock):
            coordinator?.handle(event: .fetchChart(stock.symbol))
        case .appear:
            coordinator?.handle(event: .fetchMarketList)
            coordinator?.handle(event: .initChart)
        case .searchConfirmed(let searchQuery):
            coordinator?.handle(event: .getStockItemFromSymbol(searchQuery))
        case .searchItemClicked:
            print("todo")
        case .timeframeSelected(let symbol, let timeframe):
            coordinator?.handle(event: .updateTimeFrame(symbol, timeframe))
        }
    }
    
    
    
}



// MARK: Event
extension MainScreenViewModel {
    enum Event {
        case detailStockPreview(StockItem)
        case initChart
        case fetchChart(String)
        case fetchMarketList
        case getStockItemFromSymbol(String)
        case updateTimeFrame(String, String)
    }
}

// MARK: Action
extension MainScreenViewModel {
    enum Action {
        case didTapStockPreview(StockItem)
        case didTapStock(StockItem)
        case appear
        case searchConfirmed(String)
        case searchItemClicked //TODO: implement
        case timeframeSelected(String, String)
    }
}

extension MainScreenViewModel{ //YAHOO
    
    @MainActor
    func fetchChart(symbol: String, timeframe: String? = "1d") {
            Task {
                do {
                    let chartData: ChartData = try await apiManager.request(
                        StockDataRouter.chart(
                            symbol: symbol, timeframe: timeframe
                        )
                    )
                    self.chartData = chartData
                } catch {
                    print(error)
                }
            }
        }
    
    @MainActor
        func fetchMarketList() {
            Task {
                do {
                    var newMarketList: [StockItem] = []
                    for stockItem in marketList{
                        let chartData: ChartData = try await apiManager.request(
                            StockDataRouter.chart(
                                symbol: stockItem.symbol, timeframe: "1d"
                            )
                        )
                        newMarketList.append(StockItem(symbol: stockItem.symbol, title: chartData.name, price: chartData.latestPrice ?? 0, percentChange: chartData.percentChange24Hours ?? 1,ammount: 0))
                    }
                    marketList = newMarketList
                } catch {
                    print(error)
                }
            }
        }
    
    @MainActor
    func getStockItemFromSymbol(symbol: String) async -> StockItem {
        do {
            let chartData: ChartData = try await apiManager.request(
                StockDataRouter.chart(
                    symbol: symbol, timeframe: "1d"
                )
            )

            let item = StockItem(symbol: chartData.symbol, title: chartData.name, price: chartData.latestPrice ?? 0,percentChange: chartData.percentChange24Hours, ammount: 0)
            return item
        } catch {
            print(error)
            return StockItem(symbol: "error", title: "error", price: 0, ammount: 0) //TODO: no item  found
        }
    }
    
    
    /*
     for stockItem in marketList{
         let searchData: SearchData = try await apiManager.request(
             StockDataRouter.search(
                 symbol: stockItem.title
             )
         )
     }
     */
    /*
    @MainActor
    func fetchSearch(symbol: String) {

        Task {
            do {
                let searchData: SearchData = try await apiManager.request(
                    StockDataRouter.search(
                        symbol: symbol
                    )
                )
                self.testSearch = searchData.quotes[0].symbol //example
                print(self.testSearch)


            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
        func fetchInfo(symbol: String) {
            Task {
                do {
                    let infoData: InfoData = try await apiManager.request(
                        StockDataRouter.info(
                            symbol: symbol
                        )
                    )
                    self.testInfo = infoData.longName ?? "?" //example
                    print(self.testInfo)
                } catch {
                    print(error)
                }
            }
        }
}

extension MainScreenViewModel{ //NEWS
    @MainActor
        func fetchNews() {
            Task {
                do {
                    let newsData: NewsData = try await apiManager.request(
                        NewsDataRouter.search
                    )
                    self.testNews = newsData.Data[0].title //example title of first article
                    print(self.testNews)
                } catch {
                    print(error)
                }
            }
        }
}

extension MainScreenViewModel{ //MOVERS
    @MainActor
    func fetchMarketMovers(top: Int) {
            Task {
                do {
                    let moversData: MoversData = try await apiManager.request(
                        MoversDataRouter.search(top: top)
                    )
                    self.testMovers = String(moversData.gainers[0].percent_change) //example
                    print(self.testMovers)
                } catch {
                    print(error)
                }
            }
        } */
}

