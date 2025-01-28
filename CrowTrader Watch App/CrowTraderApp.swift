
import SwiftUI

@main
@MainActor
struct CrowTrader_Watch_AppApp: App {
    private let container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(mainViewModel: MainScreenViewModel(apiManager: container.apiManager)
            )
        }
    }
}
