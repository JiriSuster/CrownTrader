

import SwiftUI

struct ContentView: View {
    @StateObject var connector = PhoneConnector()
    @StateObject var mainViewModel: MainScreenViewModel
    
    var body: some View {
        MainListView(connector: connector, mainViewModel: mainViewModel)
    }
}
