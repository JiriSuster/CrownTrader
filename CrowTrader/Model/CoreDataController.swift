//
//  CoreDataController.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject{
    let container = NSPersistentContainer(name: "CrowTrader")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }
}
