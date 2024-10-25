//
//  DIContainer.swift
//  CrowTrader Watch App
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

@MainActor //cesta jak rict ze veskery kod uvnitr classy bude bezet na hlavnim vlakne - veeskere UI musi byt na hlavnim vlakne
final class DIContainer {
    let coreDataController: CoreDataController
    
    init() {
        self.coreDataController = CoreDataController()
    }
}
