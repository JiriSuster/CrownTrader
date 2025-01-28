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
    private let balanceService: BalanceServicing
    private let connector: WatchConnector
    let apiManager: APIManaging
    @Published var snapsList: [StockItem] = [] //TODO: Use state
    @Published var balance: BalanceItem = BalanceItem(total: 0, profit: 0, moneyToInvest: 0, allMoneyToInvest: 0)
    
    init(apiManager: APIManaging, snapsService: StockItemServicing,balanceService: BalanceServicing, coordinator: SnapsListViewEventHandling? = nil, connector: WatchConnector) {
        self.coordinator = coordinator
        self.stockService = snapsService
        self.balanceService = balanceService
        self.apiManager = apiManager
        self.connector = connector
        
        Task{
            self.initSnapsList()
            self.initBalance()
            await self.fetchSnapsList()
            snapsList.forEach { stock in
                connector.sendToWatch(stock: stock, action: "ADD")
            }
        }
    }
    
    func send(_ action: SnapsAction){
        switch action{
            
        case .didTapStockPreview(let stockItem):
            coordinator?.handle(event: .detailStockPreview(stockItem))
            
        case .appear:
            coordinator?.handle(event: .initBalance)
            coordinator?.handle(event: .initSnapsList)
            coordinator?.handle(event: .fetchSnapsList)
            
        case .didTapAddBalance(let balance):
            coordinator?.handle(event: .addBalance(balance))
            coordinator?.handle(event: .initBalance)
            
        case .didTapSell(let stockItem):
            coordinator?.handle(event: .sellStockItem(stockItem))
            coordinator?.handle(event: .initBalance)
            coordinator?.handle(event: .fetchSnapsList)
        case .didTapReset:
            coordinator?.handle(event: .resetBalance)
            coordinator?.handle(event: .initBalance)
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
        case initBalance
        case fetchSnapsList
        case addBalance(Double)
        case sellStockItem(StockItem)
        case resetBalance
    }
}

// MARK: Action
extension SnapsViewModel {
    enum SnapsAction {
        case didTapStockPreview(StockItem)
        case appear
        case didTapAddBalance(Double)
        case didTapSell(StockItem)
        case didTapReset
    }
}

extension SnapsViewModel{
    
    func initSnapsList(){
        self.snapsList = stockService.fetchSnapsItems()
    }
    
    func deleteSnaps(){
        snapsList.forEach { stock in
            connector.sendToWatch(stock: stock, action: "DELETE")
            stockService.deleteStockItem(stockItem: stock)
        }
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
                        let profit = (((chartData.latestPrice ?? 1) - (stockItem.priceWhenBought ?? 1)) / (stockItem.priceWhenBought ?? 1))
                        newSnapsList.append(StockItem(symbol: stockItem.symbol, title: chartData.name, price: chartData.latestPrice ?? 0, percentChange: chartData.percentChange24Hours ?? 1,ammount: stockItem.ammount,priceWhenBought: stockItem.priceWhenBought, is_snaps: true,profit: profit))
                    }
                    snapsList = newSnapsList
                } catch {
                    print(error)
                }
            }
        }
    
    func addStockToSnapsList(stock: StockItem) { //buy
        if !isInSnapslist(stock: stock) {
            balanceService.buyStock(stock: stock)
            stockService.addNewStockItem(stockItem: stock)
        }
    }
    func isInSnapslist(stock: StockItem) -> Bool{
        return snapsList.contains(where: { $0.symbol == stock.symbol && $0.is_snaps == true })
    }
    
}

//MARK: Balance
extension SnapsViewModel{
    
    func addBalance(money: Double){
        balanceService.addNewBalance(moneyToInvest: money)
    }
    
    func initBalance(){
        self.balance = balanceService.fetchBalanceItem()
    }
    
    func sellStock(stock: StockItem){
        balanceService.sellStock(stock: stock)
        stockService.deleteStockItem(stockItem: stock)
    }
    
    func resetBalance(){
        balanceService.resetBalance()
    }
}
