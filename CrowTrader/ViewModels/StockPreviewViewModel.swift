//
//  StockPreviewViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 06.01.2025.
//

import Foundation

class StockPreviewViewModel: ObservableObject{
    @Published var chartData: ChartData? = nil
    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
}

extension StockPreviewViewModel{
    func fetchChart(symbol: String) {
        Task {
            do {
                let chartDataResponse: ChartData = try await apiManager.request(
                    StockDataRouter.chart(
                        symbol: symbol
                    )
                )
                self.chartData = chartDataResponse
            } catch {
                print(error)
            }
        }
    }
}
