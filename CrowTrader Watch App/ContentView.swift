

import SwiftUI

struct ContentView: View {
    @StateObject var connector = PhoneConnector()
    @StateObject var mainViewModel: MainScreenViewModel
    @StateObject var watchViewModel: WatchViewModel
    
    var body: some View {
        MainListView(connector: connector, mainViewModel: mainViewModel, watchViewModel: watchViewModel)
    }
}
