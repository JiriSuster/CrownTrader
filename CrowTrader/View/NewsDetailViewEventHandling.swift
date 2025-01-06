//
//  NewsDetailViewEventHandling.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import Foundation
protocol NewsDetailViewEventHandling: AnyObject {
    func handle(event: NewsDetailView.Event)
}
