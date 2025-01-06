//
//  DetailMarketView.swift
//  CrowTrader Watch App
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct MarketItem: Identifiable {
    var id = UUID()
    var price: String
    var title: String
    var grow: Float
}

struct DetailMarketView: View {
    @StateObject var connector: PhoneConnector
    @Binding var selectedTitle: Title?
    
    let mockData: [MarketItem] = [
        MarketItem(price: "125.08", title: "AAPL", grow: -1.2),
        MarketItem(price: "543.51", title: "BTC", grow: 2.3),
        MarketItem(price: "34.06", title: "EUR/USD", grow: 0.9)
    ]
    
    var body: some View {
        TabView(selection: $selectedTitle) {
            
            ForEach(mockData) { item in
                
                NavigationView{
                    VStack{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 220, height: 100)
                        
                        HStack{
                            VStack(alignment: .leading){
                                if(item.grow < 0){
                                    Text("\(item.title)").font(.system(size: 15)).foregroundStyle(.red)
                                    Text("\(item.price)").font(.subheadline).fontWeight(.semibold)
                                    Text("\(item.grow)").font(.system(size: 10)).foregroundStyle(.red)
                                }else{
                                    Text("\(item.title)").font(.system(size: 15)).foregroundStyle(.green)
                                    Text("\(item.price)").font(.subheadline).fontWeight(.semibold)
                                    Text("\(item.grow)").font(.system(size: 10)).foregroundStyle(.green)
                                }
                            }
                            Spacer()
                            Button(action: {
                                //TODO
                                
                                
                            }){
                                Image(systemName: "trash")
                            }.background(.red)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            
                        }.padding(.horizontal, 1)
                        Spacer()
                        Text(marketStatusText())
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        
                }
            }.padding(.top, 1).padding(.horizontal, 8)
                
        }

        }
        .tabViewStyle(.verticalPage)
        .navigationTitle(selectedTitle?.rawValue.uppercased() ?? "")
        .onAppear{
            //TODO
        }
    }
    
    
    
    func marketStatusText() -> String {
        // Get current time in New York time zone
        let timeZone = TimeZone(identifier: "America/New_York")!
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        let currentTime = formatter.string(from: currentDate)

        let marketOpenTime = "09:00"
        let marketCloseTime = "16:00"
        
        if currentTime >= marketOpenTime && currentTime <= marketCloseTime {
            return "Open"
        } else {
            return "Closed"
        }
    }
    
    
    
}
