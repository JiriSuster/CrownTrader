//
//  StockPreviewViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 06.01.2025.
//

import Foundation

class StockPreviewViewModel: ObservableObject{
    @Published var chartData: ChartData? = nil
    @Published var latestPrice: Double = 0
    @Published var average: (thirty: Double, sixty: Double) = (0,0)
    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
}

//MARK: API
@MainActor
extension StockPreviewViewModel {
    func fetchChart(symbol: String) async {
        do {
            let chartDataResponse: ChartData = try await apiManager.request(
                StockDataRouter.chart(
                    symbol: symbol
                )
            )
            self.chartData = chartDataResponse
            self.getLatestPrice()
            self.setAverage()
        } catch {
            print(error)
        }
    }
}


//MARK: calculations
@MainActor
extension StockPreviewViewModel{
    func getLatestPrice() {
            guard let chartData = chartData,
                  let closePrices = chartData.close else {
                print("No data available for the given symbol.")
                return
            }
            
            for index in stride(from: closePrices.count - 1, through: 0, by: -1) {
                if let close = closePrices[index]{
                    self.latestPrice = close
                    return
                }
            }

            print("All data points are null for the given symbol.")
        }
    
    private func getAverage(days: Int) -> Double {
            guard let chartData = chartData,
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
