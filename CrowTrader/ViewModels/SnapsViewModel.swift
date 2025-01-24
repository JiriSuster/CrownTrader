//
//  SnapsViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 13.01.2025.
//

import Foundation

class SnapsViewModel: ObservableObject{
    private weak var coordinator: SnapsListViewEventHandling?
    private let snapsService: StockItemServicing
    let apiManager: APIManaging
    var stockItems: [StockItem] = [] //TODO: Use state
    
    init(apiManager: APIManaging, snapsService: StockItemServicing, coordinator: SnapsListViewEventHandling? = nil) {
        self.coordinator = coordinator
        self.snapsService = snapsService
        self.apiManager = apiManager
        
        Task { @MainActor in
            //self.addSampleData()
            self.getStockItems()
        }
    }

}

@MainActor
extension SnapsViewModel{
    func addSampleData(){
        self.snapsService.addSampleData()
    }
    
    func getStockItems(){
        self.stockItems =  self.snapsService.fetchStockItems()
        print("count of notes: \(self.stockItems.count)")
    }
}

// MARK: Event
extension SnapsViewModel {
    enum SnapsEvent {
        case addSampleData
    }
}

// MARK: Action
extension SnapsViewModel {
    enum SnapsAction {
        case didTapStockPreview(StockItem)
    }
}
