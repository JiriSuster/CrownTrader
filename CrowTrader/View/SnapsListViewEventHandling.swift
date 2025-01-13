//
//  SnapsListViewEventHandling.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 13.01.2025.
//

import Foundation

protocol SnapsListViewEventHandling: AnyObject {
    func handle(event: SnapsViewModel.SnapsEvent)
}
