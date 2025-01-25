//
//  WatchListView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct WatchListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    @StateObject var viewModel: WatchListViewModel
    @State private var searchText = ""
    
    var body: some View {
        @State var watchList = viewModel.watchList
        NavigationView{
            VStack{
                TextField("Search...", text: $searchText)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onSubmit {
                                    mainViewModel.send(.searchConfirmed(searchText))
                                }
                
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
                                    Text(watchedStock.symbol)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing){
                                    Text("$\(String(format: "%.2f", watchedStock.price))")
                                        .font(.headline)
                                    Text("$\(String(format: "%.2f", watchedStock.percentChange ?? 0))")
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
            }.onAppear(){
                viewModel.send(.appear)
            }
        }
    }
}

