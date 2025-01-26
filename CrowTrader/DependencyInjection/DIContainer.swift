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
    let stockService: StockItemService
    let balanceService: BalanceService

    init(){
        self.coreDataController = CoreDataController()
        self.apiManager = APIManager()
        self.stockService = StockItemService(moc: coreDataController.container.viewContext)
        self.balanceService = BalanceService(moc: coreDataController.container.viewContext)
    }
}
