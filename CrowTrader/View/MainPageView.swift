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
    @State private var selectedTimeframe: String = "1M"
    @State private var selectedMarketIndex: Int = 0
    
    
    @State var marketList = [
        StockItem(title: "S$P500", price: 175.32, percentChange: 2.1, ammount: 17),
        StockItem(title: "NASDAQ100", price: 175.32,percentChange: -2.1, ammount: 17),
        StockItem(title: "DOW30", price: 175.32,percentChange: 2.1, ammount: 17),
        StockItem(title: "JAPAN 225", price: 175.32,percentChange: -2.1, ammount: 17),
        StockItem(title: "UK 100 index", price: 175.32,percentChange: 2.1, ammount: 17),
    ]
    
    let pastelColors: [Color] = [
        Color(red: 0.5, green: 0.6, blue: 0.7),
            Color(red: 0.7, green: 0.5, blue: 0.6),
            Color(red: 0.6, green: 0.7, blue: 0.5),
            Color(red: 0.7, green: 0.6, blue: 0.5),
            Color(red: 0.5, green: 0.7, blue: 0.6)
    ]
    
    
    let emptyChartData = ChartData(
        chart: ChartQuote(
            result: [
                ChartResult(
                    timestamp: [],
                    indicators: Indicators(
                        quote: [
                            Quote(
                                close: [],
                                high: [],
                                open: [],
                                low: [],
                                volume: []
                            )
                        ]
                    ),meta: MetaQuote(symbol: "")
                )
            ]
        )
    )
    
    var stockItem = StockItem(title: "remove this", price: 443, ammount: 10)

    var body: some View {
            
        VStack {
            
            TextField("Search...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
            
            StockChartView(data: emptyChartData)
                .frame(width: 370,height: 230)
                .foregroundStyle(.gray)
                .cornerRadius(15)

            HStack {
                                let timeframes = ["1W","1M", "3M", "6M", "1Y"]
                                ForEach(timeframes, id: \.self) { timeframe in
                                    Button(action: {
                                        selectedTimeframe = timeframe
                                    }) {
                                        Text(timeframe)
                                            .fontWeight(selectedTimeframe == timeframe ? .bold : .regular)
                                            .padding()
                                            .frame(width: 60, height: 40)
                                            .background(
                                                selectedTimeframe == timeframe ? Color.green : Color.gray.opacity(0.2)
                                            )
                                            .foregroundColor(
                                                selectedTimeframe == timeframe ? .white : .green
                                            )
                                            .cornerRadius(10)
                                    }.padding(.horizontal,4)

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
                            Text(market.title)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("$\(String(format: "%.2f", market.price))")
                                .font(.headline)
                            Text("$\(String(format: "%.2f", market.percentChange!))")
                                .font(.body)
                                .foregroundColor(market.color)
                        }
                    }
                    .padding()
                    .background(selectedMarketIndex == index ? Color.green.opacity(0.2) : Color(.systemGray6))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedMarketIndex = index
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
