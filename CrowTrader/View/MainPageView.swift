//
//  MainPageView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 29.12.2024.
//

import SwiftUI
import Charts

struct StockItem: Identifiable {
    var id = UUID()
    var title: String
    var price: String
}

struct MainPageView: View {
    @StateObject var connector : WatchConnector
    @StateObject var viewModel: MainScreenViewModel
    
    var stockItem = StockItem(title: "remove this", price: "443")

    var body: some View {
            
        VStack {
            Button(action: {viewModel.send(.didTapStockPreview(stockItem))}){
                Text("try detail stock")
            }
            TextField("Message text", text: $connector.messageText)
            DatePicker("Date", selection: $connector.messageDate)
            Button("Send"){
                connector.sendToWatch()
            }
            Button("Show last 5 open prices from yahoo API (btc-usd) bbb"){
                viewModel.fetchWeatherData()
            }
            Text(viewModel.temperature)
        }
        .padding()
        .ignoresSafeArea()
    }
}
