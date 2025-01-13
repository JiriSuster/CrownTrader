//
//  MainPageView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 29.12.2024.
//

import SwiftUI
import Charts


struct MainPageView: View {
    @StateObject var connector : WatchConnector
    @StateObject var viewModel: MainScreenViewModel
    
    var stockItem = StockItem(title: "remove this", price: 443, ammount: 10)

    var body: some View {
            
        VStack {
            Button(action: {viewModel.send(.didTapStockPreview(stockItem))}){
                Text("try detail stock")
            }
            TextField("Message text", text: $connector.messageText)
            DatePicker("Date", selection: $connector.messageDate)
            Button("Send to watch"){
                connector.sendToWatch()
            }
            Button("test search"){
                viewModel.fetchSearch(symbol: "BTC-USD")
            }
            Text(viewModel.testSearch)
            
            Button("test chart"){
                viewModel.fetchChart(symbol: "BTC-USD")
            }
            Text(viewModel.testChart)
            
            Button("test info"){
                viewModel.fetchInfo(symbol: "BTC-USD")
            }
            Text(viewModel.testInfo)
            
            Divider()
            
            Button("test news"){
                viewModel.fetchNews()
            }
            Text(viewModel.testNews)
            
            Divider()
            
            Button("test movers"){
                viewModel.fetchMarketMovers(top: 5)
            }
            Text(viewModel.testMovers)
        }
        .padding()
        .ignoresSafeArea()
    }
}
