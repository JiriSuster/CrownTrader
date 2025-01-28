

import SwiftUI

enum Title: String, CaseIterable {
    case markets = "Markets"
    case watchlist = "Watchlist"
    case snaps = "Snaps"
}

struct MainListView: View {
    @StateObject var connector: PhoneConnector
    @State private var selectedTitle: Title? = .markets
    @StateObject var mainViewModel: MainScreenViewModel
    @StateObject var watchViewModel: WatchViewModel
    
    var body: some View {
        
        
        NavigationSplitView() {
            
            List(selection: $selectedTitle) {
                HStack{
                    Image(systemName: "chart.bar")
                    NavigationLink("MARKETS", value: Title.markets)
                }
                HStack{
                    Image(systemName: "eye")
                    NavigationLink("WATCHLIST", value: Title.watchlist)
                }
                HStack{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    NavigationLink("SNAPS", value: Title.snaps)
                }
                
            }
            .listStyle(.carousel)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack{
                        Image(systemName: "crown")
                            .foregroundStyle(.green)
                        Text("Crown Trader")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
            }
        } detail: {
            
            switch selectedTitle {
            case .markets:
                MarketDetailView(connector: connector, selectedTitle: $selectedTitle, mainViewModel: mainViewModel)
            case .watchlist:
                WatchlistView(connector: connector, selectedTitle: $selectedTitle, mainViewModel: mainViewModel, watchViewModel: watchViewModel)
            case .snaps:
                SnapslistView(connector: connector, selectedTitle: $selectedTitle, mainViewModel: mainViewModel,watchViewModel: watchViewModel)
            case nil:
                WatchlistView(connector: connector, selectedTitle: $selectedTitle, mainViewModel: mainViewModel,watchViewModel: watchViewModel)
            }
        }
    }
}
