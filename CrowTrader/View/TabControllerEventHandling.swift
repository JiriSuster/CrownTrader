//
//  TabControllerEventHandling.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import Foundation
protocol TabControllerEventHandling: AnyObject {
    func handle(event: TabController.Event)
}
