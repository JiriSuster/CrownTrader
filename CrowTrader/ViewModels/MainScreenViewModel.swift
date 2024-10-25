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
                    WeatherDataRouter.dailyMaxTemperature(
                        long: 10, lat: 10
                    )
                )
                self.temperature = weatherData.daily.time[0]
                print(self.temperature)


            } catch {
                print(error)
            }
        }
    }
}
