//
//  AppCoordinator.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import UIKit

@MainActor
final class AppCoordinator {
    let container: DIContainer
    var childCoordinators = [Coordinator]()
    var rootCoordinator: Coordinator?
    let window: UIWindow

    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
        print("tady to ma printovat")

        start(container: container)
    }
}

extension AppCoordinator {
    func start(container: DIContainer) {
        let navigationController = UINavigationController()
        let coordinator = CrowTraderCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(coordinator)
        rootCoordinator = coordinator
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
