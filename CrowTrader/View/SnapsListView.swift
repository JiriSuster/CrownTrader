//
//  SnapsListView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI
import Charts

struct SnapsListView: View {
    @ObservedObject var viewModel: SnapsViewModel
    
    var body: some View {
            VStack {
                if viewModel.stockItems.isEmpty {
                    Text("No stock items available")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.stockItems) { stockItem in
                                Text(stockItem.title)
                                Divider()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stock Items")
        }
}

