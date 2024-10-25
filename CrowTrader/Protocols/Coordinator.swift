//
//  Coordinator.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

protocol Coordinator: AnyObject {
    var container: DIContainer { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
