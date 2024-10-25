//
//  ContentView.swift
//  CrowTrader Watch App
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connector = PhoneConnector()
    var body: some View {
        VStack {
            TextField("Message text", text: $connector.messageText)
            DatePicker("Date", selection: $connector.messageDate)
            Button("Send"){
                connector.sendToPhone()
            }
        }
        .padding()
        .ignoresSafeArea()
    }
}
#Preview {
    ContentView()
}
