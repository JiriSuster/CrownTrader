//
//  TabController.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct TabController: View {
    @State private var selection = 1
    @StateObject var connector : WatchConnector
    @StateObject var viewModel: MainScreenViewModel
    
    enum Event {
            case close
        }
    weak var coordinator: TabControllerEventHandling?
    
    var body: some View {
        
        TabView(selection: $selection) {
            MainPageView(connector: connector, viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }.tag(1)
            WatchListView()
                .tabItem {
                    Label("Watchlist", systemImage: "eye")
                }.tag(2)
            SnapsListView()
                .tabItem {
                    Label("Snaps", systemImage: "chart.bar")
                }.tag(3)
            NewsListView(mainViewModel: viewModel)
                .tabItem {
                    Label("News", systemImage: "book")
                }.tag(4)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack{
                    Image(systemName: "crown")
                        .foregroundStyle(.green)
                    Text("Crown Trader")
                        .font(.headline)
                        .foregroundColor(.green)
                }.frame(maxWidth: .infinity)
            }
        }
        .onAppear(){

        }
        
        
    }
}


