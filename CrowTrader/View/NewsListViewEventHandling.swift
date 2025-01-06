//
//  NewsListViewEventHandling.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import Foundation
protocol NewsListViewEventHandling: AnyObject {
    func handle(event: NewsListView.Event)
}
