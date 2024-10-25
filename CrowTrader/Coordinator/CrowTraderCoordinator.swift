//
//  CrowTraderCoordinator.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
import SwiftUI

@MainActor
final class CrowTraderCoordinator{

    
    let container: DIContainer
    let connector = WatchConnector()
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.container = container
        self.navigationController = navigationController
        
        start()
    }
}

extension CrowTraderCoordinator: Coordinator {
    func start() {
        print("Starting CrowTraderCoordinator") 
        let signInViewController = makeHomeScreenView()
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}


private extension CrowTraderCoordinator {
    func makeHomeScreenView() -> UIViewController {
        let viewModel = MainScreenViewModel(apiManager: container.apiManager)
        let view = ContentView(
            connector: self.connector, viewModel: viewModel
        )
        return UIHostingController(rootView: view)
    }
}
