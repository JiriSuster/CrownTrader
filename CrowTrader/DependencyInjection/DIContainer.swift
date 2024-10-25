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

    init(){
        self.coreDataController = CoreDataController()
    }
}
