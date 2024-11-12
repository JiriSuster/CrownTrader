//
//  MainScreenViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
class MainScreenViewModel: ObservableObject{
    @Published var temperature: String = "empty"
    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
}

extension MainScreenViewModel{
    @MainActor
    func fetchWeatherData() {

        Task {
            do {
                let weatherData: StockData = try await apiManager.request(
                    StockDataRouter.cryptoPrice(
                        symbol: "BTC-USD"
                    )
                )
                let openValues = weatherData.chart.result[0].indicators.quote[0].open
                let firstFiveValues = openValues.prefix(5)
                
                self.temperature = firstFiveValues
                    .map { String($0 ?? 0) } // prevod na string
                    .joined(separator: "\n")
                
                print(self.temperature)


            } catch {
                print(error)
            }
        }
    }
}
