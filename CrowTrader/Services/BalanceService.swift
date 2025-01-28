//
//  BalanceService.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 26.01.2025.
//

import CoreData
import Foundation
import UIKit

protocol BalanceServicing {
    func fetchBalanceItem() -> BalanceItem
    func addNewBalance(moneyToInvest: Double)
    func resetBalance()
    func buyStock(stock: StockItem)
    func sellStock(stock: StockItem)
}

final class BalanceService: BalanceServicing {
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchBalance() -> BalanceEntity {
        let request = NSFetchRequest<BalanceEntity>(entityName: "BalanceEntity")
        do {
            let results = try moc.fetch(request)
            if let existingBalance = results.first {
                return existingBalance
            } else {
                return createDefaultBalance()
            }
        } catch {
            print("Error fetching balance: \(error)")
            return createDefaultBalance()
        }
    }
    
    private func createDefaultBalance() -> BalanceEntity {
        let newBalance = BalanceEntity(context: moc)
        newBalance.total = 0
        newBalance.profit = 0
        newBalance.money_to_invest = 0
        newBalance.all_money_to_invest = 0
        save()
        return newBalance
    }
    
    
    func fetchBalanceItem() -> BalanceItem {
        let balance = fetchBalance()
        return BalanceItem(
            total: balance.total,
            profit: balance.profit,
            moneyToInvest: balance.money_to_invest,
            allMoneyToInvest: balance.all_money_to_invest
        )
    }
    
    func addNewBalance(moneyToInvest: Double) {
        let balance = fetchBalance()
        balance.money_to_invest += moneyToInvest
        balance.all_money_to_invest += moneyToInvest
        save()
    }
    

    func sellStock(stock: StockItem){
        let balance = fetchBalance()
        balance.money_to_invest += (stock.ammount * stock.price)
        balance.profit = ((balance.money_to_invest - balance.all_money_to_invest) / balance.all_money_to_invest ) * 100
        debugPrint(stock.ammount)
        debugPrint(stock.price)
        balance.total += (stock.ammount * stock.price) - (stock.ammount * (stock.priceWhenBought ?? 1))
        save()
    }
    
    func buyStock(stock: StockItem){
        let balace = fetchBalance()
        balace.money_to_invest -= stock.price * stock.ammount
        save()
        
    }
    
    func resetBalance() {
        let balance = fetchBalance()
        balance.total = 0
        balance.profit = 0
        balance.money_to_invest = 0
        balance.all_money_to_invest = 0
        save()
    }
    
    private func save() {
        if moc.hasChanges {
            do {
                try moc.save()
                debugPrint("Saved to CoreData successfully")
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}
