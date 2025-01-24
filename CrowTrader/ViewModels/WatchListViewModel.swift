//
//  WatchListViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 24.01.2025.
//

import Foundation
class WatchListViewModel: ObservableObject{
    private weak var coordinator: WatchListEventHandling?
    private let stockService: StockItemServicing
    let apiManager: APIManaging
    @Published var watchList: [StockItem] = []
    
    init(apiManager: APIManaging, stockService: StockItemServicing, coordinator: WatchListEventHandling? = nil) {
        self.coordinator = coordinator
        self.stockService = stockService
        self.apiManager = apiManager
        
        Task{
            self.initWatchList()
        }
    }
    
    func send(_ action: Action){
        switch action{
            
        case .didTapStockPreview(let stockItem):
            coordinator?.handle(event: .detailStockPreview(stockItem))
        case .appear:
            coordinator?.handle(event: .initWatchlist)
            coordinator?.handle(event: .fetchWatchlist)
        }
    }

}
extension WatchListViewModel{
    enum Event{
        case detailStockPreview(StockItem)
        case initWatchlist
        case fetchWatchlist
    }
}

extension WatchListViewModel{
    enum Action{
        case didTapStockPreview(StockItem)
        case appear
    }
}

extension WatchListViewModel{
    
    func initWatchList(){
        self.watchList = stockService.fetchStockItems()
    }
    
    func addStockToWatchList(stock: StockItem) {
        if !isInWatchlist(stock: stock) {
            stockService.addNewStockItem(stockItem: stock)
        }
    }
    
    func isInWatchlist(stock: StockItem) -> Bool{
        return watchList.contains(where: { $0.symbol == stock.symbol && $0.is_watchlist == true })
    }
    
    func unwatch(stock: StockItem) {
        stockService.deleteStockItem(stockItem: stock)
        initWatchList()
    }
    
    @MainActor
        func fetchWatchList() {
            Task {
                do {
                    var newMarketList: [StockItem] = []
                    for stockItem in watchList{
                        let chartData: ChartData = try await apiManager.request(
                            StockDataRouter.chart(
                                symbol: stockItem.symbol, timeframe: "1d"
                            )
                        )
                        newMarketList.append(StockItem(symbol: stockItem.symbol, title: chartData.name, price: chartData.latestPrice ?? 0, percentChange: chartData.percentChange24Hours ?? 1,ammount: 0))
                    }
                    watchList = newMarketList
                } catch {
                    print(error)
                }
            }
        }
}
