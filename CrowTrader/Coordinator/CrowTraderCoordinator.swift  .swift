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
    
    private lazy var viewModel = MainScreenViewModel(
        apiManager: container.apiManager,
        coordinator: self
    )
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.container = container
        self.navigationController = navigationController
        
        start()
    }
}

extension CrowTraderCoordinator: Coordinator {
    func start() {
        print("Starting CrowTraderCoordinator")
        let signInViewController = makeTabView()
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}

// MARK: Factories
private extension CrowTraderCoordinator {
    func makeTabView() -> UIViewController {
        let view = TabController(
            connector: self.connector,
            viewModel: self.viewModel
        )
        return UIHostingController(rootView: view)
    }
}

private extension CrowTraderCoordinator {
    func makeStockDetailView(stockItem: StockItem) -> UIViewController {
        let view = StockPreview(
            coordinator: self
        )
        return UIHostingController(rootView: view)
    }
}

private extension CrowTraderCoordinator {
    func makeNewsDetailView(newsItem: NewsItem) -> UIViewController {
        let view = NewsDetailView(
            coordinator: self, newsItem: newsItem
        )
        return UIHostingController(rootView: view)
    }
}

private extension CrowTraderCoordinator {
    func makeNewsListView() -> UIViewController {
        let view = NewsListView(
            mainViewModel: self.viewModel, coordinator: self
        )
        return UIHostingController(rootView: view)
    }

}


// MARK: Navigating
extension CrowTraderCoordinator: StockPreviewEventHandling {
    func handle(event: StockPreview.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}

extension CrowTraderCoordinator: TabControllerEventHandling {
    func handle(event: TabController.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}

extension CrowTraderCoordinator: MainViewEventHandling {
    func handle(event: MainScreenViewModel.Event) {
        switch event {
        case let .detailNews(newsItem):
            let viewController = makeNewsDetailView(newsItem: newsItem)
            navigationController.present(viewController, animated: true)
        case let .detailStockPreview(stockItem):
            let viewController = makeStockDetailView(stockItem: stockItem)
            navigationController.present(viewController, animated: true)
        }
    }}

extension CrowTraderCoordinator: NewsDetailViewEventHandling {
    func handle(event: NewsDetailView.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}

extension CrowTraderCoordinator: NewsListViewEventHandling {
    func handle(event: NewsListView.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}
