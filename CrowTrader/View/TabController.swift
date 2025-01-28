

import SwiftUI

struct TabController: View {
    @State private var selection = 1
    @StateObject var connector : WatchConnector
    @StateObject var viewModel: MainScreenViewModel
    @StateObject var newsListScreenViewModel: NewsScreenViewModel
    @StateObject var snapsViewModel: SnapsViewModel
    @StateObject var watchListViewModel: WatchListViewModel
    
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
            WatchListView(mainViewModel: viewModel, viewModel: watchListViewModel)
                .tabItem {
                    Label("Watchlist", systemImage: "eye")
                }.tag(2)
            SnapsListView(mainViewModel: viewModel, viewModel: snapsViewModel)
                .tabItem {
                    Label("Snaps", systemImage: "chart.bar")
                }.tag(3)
            NewsListView(viewModel: newsListScreenViewModel)
                .tabItem {
                    Label("News", systemImage: "book")
                }.tag(4)
        }.tint(.green)
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


