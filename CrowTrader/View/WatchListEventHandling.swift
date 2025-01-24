//
//  WatchListEventHandling.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 24.01.2025.
//

import Foundation

protocol WatchListEventHandling: AnyObject {
    func handle(event: WatchListViewModel.Event)
}
