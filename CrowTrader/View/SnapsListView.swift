//
//  SnapsListView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI
import Charts

struct SnapsListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    @ObservedObject var viewModel: SnapsViewModel
    @State private var searchText = ""
    @State var watchList = [
        StockItem(title: "S$P500", price: 175.32, percentChange: 2.1, ammount: 17),
        StockItem(title: "NASDAQ100", price: 175.32,percentChange: -2.1, ammount: 17),
        StockItem(title: "DOW30", price: 175.32,percentChange: 2.1, ammount: 17),
        StockItem(title: "JAPAN 225", price: 175.32,percentChange: -2.1, ammount: 17),
        StockItem(title: "UK 100 index", price: 175.32,percentChange: 2.1, ammount: 17),
    ]
    
    var body: some View {
        
        NavigationView{
            VStack{
                TextField("Search...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                HStack{
                    Text("Snaps").font(.title)
                    Spacer()
                }.padding(.top, 20)
                
                ScrollView{
                    VStack(spacing: 8) {
                        
                        ForEach(viewModel.stockItems, id: \.title) { stock in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(stock.title)
                                        .font(.headline)
                                    Text(stock.title)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                HStack{
                                    VStack(alignment: .trailing){
                                        Text("$\(String(format: "%.2f", stock.price))")
                                            .font(.headline)
                                        Text("$\(String(format: "%.2f", stock.percentChange!))")
                                            .font(.body)
                                            .foregroundColor(stock.color)
                                    }
                                    Button(action: {}){
                                        Text("Sell")
                                    }.buttonStyle(.dismissCrownButtonStyle)
                                }
                                
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onTapGesture {
                                mainViewModel.send(.didTapStockPreview(stock))
                            }
                        }
                    }
                }
            }
        }
        

        }
}

