import Foundation

class WatchViewModel: ObservableObject{
    let apiManager: APIManaging
    @Published var itemList: [StockItem] = []
    init(apiManager: APIManaging){
        self.apiManager = apiManager
    }
    
}

extension WatchViewModel{
    @MainActor
    func fetchList(list: [StockItem]) async -> [StockItem] {
        var newMarketList: [StockItem] = []
        
        do {
            for stockItem in list {
                let chartData: ChartData = try await apiManager.request(
                    StockDataRouter.chart(
                        symbol: stockItem.symbol, timeframe: "1d"
                    )
                )
                newMarketList.append(
                    StockItem(
                        symbol: stockItem.symbol,
                        title: chartData.name,
                        price: chartData.latestPrice ?? 0,
                        percentChange: chartData.percentChange24Hours ?? 1,
                        ammount: stockItem.ammount,
                        priceWhenBought: stockItem.priceWhenBought,
                        is_watchlist : stockItem.is_watchlist,
                        is_snaps: stockItem.is_snaps
                    )
                )
            }
        } catch {
            print("Error fetching chart data: \(error)")
        }
        
        return newMarketList
    }
}
