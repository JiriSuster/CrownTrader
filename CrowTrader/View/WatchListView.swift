//
//  WatchListView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct WatchListView: View {
    @StateObject var viewModel: MainScreenViewModel
    @State private var searchText = ""
    @State var watchList = [
        StockItem(symbol: "AAPL",title: "AAPL", price: 175.32, percentChange: 2.1, ammount: 17),
        StockItem(symbol: "watchlist",title: "NVDA", price: 175.32,percentChange: -2.1, ammount: 17),
        StockItem(symbol: "watchlist",title: "AMZN", price: 175.32,percentChange: 2.1, ammount: 17),
        StockItem(symbol: "watchlist",title: "CO", price: 175.32,percentChange: -2.1, ammount: 17),
        StockItem(symbol: "watchlist",title: "K", price: 175.32,percentChange: 2.1, ammount: 17),
    ]
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Search...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                HStack{
                    Text("Watchlist").font(.title)
                    Spacer()
                }.padding(.top, 20)
                
                ScrollView{
                    VStack(spacing: 8) {
                        
                        ForEach(watchList, id: \.title) { watchedStock in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(watchedStock.title)
                                        .font(.headline)
                                    Text(watchedStock.title)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing){
                                    Text("$\(String(format: "%.2f", watchedStock.price))")
                                        .font(.headline)
                                    Text("$\(String(format: "%.2f", watchedStock.percentChange!))")
                                        .font(.body)
                                        .foregroundColor(watchedStock.color)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onTapGesture {
                                self.viewModel.send(.didTapStockPreview(watchedStock))
                            }
                        }
                    }
                }
            }
        }
    }
}

