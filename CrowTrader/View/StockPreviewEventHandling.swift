//
//  StockPreviewEventHandling.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 03.01.2025.
//

import Foundation
protocol StockPreviewEventHandling: AnyObject {
    func handle(event: StockPreview.Event)
}
