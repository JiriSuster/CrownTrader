//
//  ContentView.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connector : WatchConnector
    @ObservedObject var viewModel: MainScreenViewModel
    var body: some View {
        VStack {
            TextField("Message text", text: $connector.messageText)
            DatePicker("Date", selection: $connector.messageDate)
            Button("Send"){
                connector.sendToWatch()
            }
            Button("Show last 5 open prices from yahoo API (btc-usd)"){
                viewModel.fetchWeatherData()
            }
            Text(viewModel.temperature)
        }
        .padding()
        .ignoresSafeArea()
    }
}

/*
#Preview {
    ContentView()
}
*/
