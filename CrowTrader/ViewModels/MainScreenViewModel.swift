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
    @Published var testSearch: String = "empty"
    @Published var testChart: String = "empty"
    @Published var testInfo: String = "empty"
    @Published var testNews: String = "empty"
    @Published var testMovers: String = "empty"
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

        }
    }
    
    
    
}



// MARK: Event
extension MainScreenViewModel {
    enum Event {
        case detailStockPreview(StockItem)
    }
}

// MARK: Action
extension MainScreenViewModel {
    enum Action {
        case didTapStockPreview(StockItem)
    }
}

extension MainScreenViewModel{ //YAHOO
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
        func fetchChart(symbol: String) {
            Task {
                do {
                    let chartData: ChartData = try await apiManager.request(
                        StockDataRouter.chart(
                            symbol: symbol
                        )
                    )
                    self.testChart = String(chartData.close?[0] ?? 0.0) //example first close price
                    print(self.testChart)
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
        }
}
