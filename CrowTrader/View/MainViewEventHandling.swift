//
//  MainViewEventHandling.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import Foundation

protocol MainViewEventHandling: AnyObject {
    func handle(event: MainScreenViewModel.Event)
}
