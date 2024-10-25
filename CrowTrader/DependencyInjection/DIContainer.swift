//
//  DIContainer.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

@MainActor
final class DIContainer {
    let coreDataController: CoreDataController
    let apiManager: APIManaging

    init(){
        self.coreDataController = CoreDataController()
        self.apiManager = APIManager()
    }
}
