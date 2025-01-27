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
    @State private var searchText = ""
    @State private var selectedTimeframe: String = "1d"
    @State private var selectedMarketIndex: Int = 0
    
    
    
    let pastelColors: [Color] = [
        Color(red: 0.5, green: 0.6, blue: 0.7),
            Color(red: 0.7, green: 0.5, blue: 0.6),
            Color(red: 0.6, green: 0.7, blue: 0.5),
            Color(red: 0.7, green: 0.6, blue: 0.5),
            Color(red: 0.5, green: 0.7, blue: 0.6)
    ]
    

    

    var body: some View {
        @State var marketList = viewModel.marketList
        @State var emptyChartData = viewModel.chartData
            
        VStack {
            
            TextField("Search...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: searchText) { oldValue, newValue in
                                print(newValue)
                                viewModel.send(.searchTextChanged(newValue))
                            }
                            .onSubmit {
                                viewModel.send(.searchConfirmed(searchText))
                            }
            if(viewModel.search != nil){
                ForEach(viewModel.search!.quotes, id: \.self.symbol){ quote in
                    Text("\(quote.shortname)").onTapGesture {
                        Task{
                            let stock = await viewModel.getStockItemFromSymbol(symbol: quote.symbol)
                            viewModel.send(.didTapStockPreview(stock))
                            searchText = ""
                            viewModel.send(.searchTextChanged(""))
                        }
                    }
                }
            }
            
            StockChartView(data: emptyChartData)
                .frame(width: 370,height: 230)
                .foregroundStyle(.gray)
                .cornerRadius(15)

            HStack {
                                let timeframes = ["1d", "3mo", "6mo", "1y"]
                                ForEach(timeframes, id: \.self) { timeframe in
                                    Button(action: {
                                        selectedTimeframe = timeframe
                                        viewModel.send(.timeframeSelected(marketList[selectedMarketIndex].symbol, selectedTimeframe))
                                    }) {
                                        Text(timeframe)
                                    }.buttonStyle(.timeframe(isSelected: selectedTimeframe == timeframe))

                                }
                            }
                            .padding(.horizontal, 25)

            ScrollView{
            VStack(spacing: 8) {
                ForEach(marketList.indices, id: \.self) { index in
                    let market = marketList[index]
                    
                    HStack {
                        Circle()
                            .frame(width: 55, height: 55)
                            .foregroundColor(self.pastelColors[index])
                            .overlay(
                                Text(market.title.prefix(3))
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                        
                        VStack(alignment: .leading) {
                            Text(market.title)
                                .font(.headline)
                            Text(market.symbol)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("$\(String(format: "%.2f", market.price))")
                                .font(.headline)
                            Text("\(String(format: "%.2f", market.percentChange ?? 0))%")
                                .font(.body)
                                .foregroundColor(market.color)
                        }
                    }
                    .padding()
                    .background(selectedMarketIndex == index ? Color.green.opacity(0.2) : Color(.systemGray6))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedMarketIndex = index
                        viewModel.send(.didTapStock(marketList[selectedMarketIndex]))
                    }
                    .onAppear(){
                        viewModel.send(.appear)
                    }
                }
            }
        }
            .frame(maxHeight: 300)
   
        
//            Button(action: {viewModel.send(.didTapStockPreview(stockItem))}){
//                Text("try detail stock")
//            }
//            Button("test search"){
//                viewModel.fetchSearch(symbol: "BTC-USD")
//            }
//            Text(viewModel.testSearch)
//            
//            Button("test chart"){
//                viewModel.fetchChart(symbol: "BTC-USD")
//            }
//            Text(viewModel.testChart)
//            
//            Button("test info"){
//                viewModel.fetchInfo(symbol: "BTC-USD")
//            }
//            Text(viewModel.testInfo)
//            
//            Divider()
//            
//            Button("test news"){
//                viewModel.fetchNews()
//            }
//            Text(viewModel.testNews)
//            
//            Divider()
//            
//            Button("test movers"){
//                viewModel.fetchMarketMovers(top: 5)
//            }
//            Text(viewModel.testMovers)
        }
        .padding()
        .ignoresSafeArea()
    }
}
