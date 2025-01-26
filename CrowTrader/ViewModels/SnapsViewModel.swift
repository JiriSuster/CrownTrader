//
//  SnapsViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 13.01.2025.
//

import Foundation

class SnapsViewModel: ObservableObject{
    private weak var coordinator: SnapsListViewEventHandling?
    private let stockService: StockItemServicing
    let apiManager: APIManaging
    @Published var snapsList: [StockItem] = [] //TODO: Use state
    
    init(apiManager: APIManaging, snapsService: StockItemServicing, coordinator: SnapsListViewEventHandling? = nil) {
        self.coordinator = coordinator
        self.stockService = snapsService
        self.apiManager = apiManager
        
        Task{
            self.initSnapsList()
            await self.fetchSnapsList()
        }
    }
    
    func send(_ action: SnapsAction){
        switch action{
            
        case .didTapStockPreview(let stockItem):
            coordinator?.handle(event: .detailStockPreview(stockItem))
        case .appear:
            coordinator?.handle(event: .initSnapsList)
            coordinator?.handle(event: .fetchSnapsList)
        }
    }

}

@MainActor
extension SnapsViewModel{
    func addSampleData(){
        self.stockService.addSampleData()
    }
    
    func getStockItems(){
        self.snapsList =  self.stockService.fetchStockItems()
        print("count of notes: \(self.snapsList.count)")
    }
}

// MARK: Event
extension SnapsViewModel {
    enum SnapsEvent {
        case detailStockPreview(StockItem)
        case initSnapsList
        case fetchSnapsList
    }
}

// MARK: Action
extension SnapsViewModel {
    enum SnapsAction {
        case didTapStockPreview(StockItem)
        case appear
    }
}

extension SnapsViewModel{
    
    func initSnapsList(){
        self.snapsList = stockService.fetchSnapsItems()
    }
    
    @MainActor
        func fetchSnapsList() {
            Task {
                do {
                    var newSnapsList: [StockItem] = []
                    for stockItem in snapsList{
                        let chartData: ChartData = try await apiManager.request(
                            StockDataRouter.chart(
                                symbol: stockItem.symbol, timeframe: "1d"
                            )
                        )
                        newSnapsList.append(StockItem(symbol: stockItem.symbol, title: chartData.name, price: chartData.latestPrice ?? 0, percentChange: chartData.percentChange24Hours ?? 1,ammount: stockItem.ammount, is_snaps: true))
                    }
                    snapsList = newSnapsList
                } catch {
                    print(error)
                }
            }
        }
    
    func addStockToSnapsList(stock: StockItem) {
        if !isInSnapslist(stock: stock) {
            stockService.addNewStockItem(stockItem: stock)
        }
    }
    func isInSnapslist(stock: StockItem) -> Bool{
        return snapsList.contains(where: { $0.symbol == stock.symbol && $0.is_snaps == true })
    }
    
}
