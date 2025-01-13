
//
//  SnapsService.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 13.01.2025.
//

import CoreData
import Foundation
import UIKit

protocol SnapsServicing {
    func fetchStocks() -> [StockEntity]
    func fetchStockItems() -> [StockItem]
    func addNewStockItem(stockItem: StockItem)
    func addSampleData()
}

final class SnapsService: SnapsServicing {
    private let moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func fetchStocks() -> [StockEntity] {
        let request = NSFetchRequest<StockEntity>(entityName: "StockEntity")
        var entities: [StockEntity] = []

        do {
            entities = try moc.fetch(request)
        } catch {
            print("Some error occured while fetching")
        }
        return entities
    }
    
    func fetchStockItems() -> [StockItem] {
        fetchStocks().map {

            return StockItem(
                id: $0.id ?? UUID(),
                title: $0.symbol ?? "Unknown",
                price: Double($0.value * $0.ammount),
                percentChange: 0, //TODO: Calculate
                ammount: Double($0.ammount)
            )
        }
    }
    
    func addNewStockItem(stockItem: StockItem) {
        let newStock = StockEntity(context: moc)
        newStock.id = stockItem.id
        newStock.ammount = Int16(stockItem.ammount)
        newStock.percent_change = Int16(stockItem.percentChange ?? 0)
        newStock.symbol = stockItem.title
        
        save()
    }
    
    func addSampleData() {
        let stock1 = StockItem(title: "AAPL", price: 15, ammount: 25)
        let stock2 = StockItem(title: "BTC-USD", price: 2000, ammount: 3)
        addNewStockItem(stockItem: stock1)
        addNewStockItem(stockItem: stock2)
    }
}

private extension SnapsService {
    func save() {
        if moc.hasChanges{
            do {
                try moc.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}


