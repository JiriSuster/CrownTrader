//
//  ContentView.swift
//  CrowTrader Watch App
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connector = PhoneConnector()
    @StateObject var mainViewModel: MainScreenViewModel
    
    var body: some View {
        MainListView(connector: connector, mainViewModel: mainViewModel)
    }
}
