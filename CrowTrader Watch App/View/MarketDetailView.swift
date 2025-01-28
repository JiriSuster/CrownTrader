//
//  DetailMarketView.swift
//  CrowTrader Watch App
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct MarketDetailView: View {
    @StateObject var connector: PhoneConnector
    @Binding var selectedTitle: Title?
    @StateObject var mainViewModel: MainScreenViewModel
    
    var body: some View {
        var list: [StockItem]
        let emptyChartData = mainViewModel.chartData
        
        TabView(selection: $selectedTitle) {
            
            ForEach(mainViewModel.marketList) { item in
                
                NavigationView{
                    VStack{
                        VStack{
                            StockChartView(data: emptyChartData)
                                .frame(width: 180,height: 90)
                                .foregroundStyle(.gray)
                                .cornerRadius(15)
                                .onAppear {
                                    mainViewModel.fetchChart(symbol: item.symbol)
                                }
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text("\(item.title)").font(.system(size: 15))
                                    Text(String(format: "%.2f", item.price)).font(.subheadline).fontWeight(.semibold)
                                    if(item.percentChange! < 0){
                                        Text("\(String(format: "%.2f", item.percentChange ?? 0))%").font(.system(size: 10)).foregroundStyle(.red)
                                    }else{
                                        Text("\(String(format: "%.2f", item.percentChange ?? 0))%").font(.system(size: 10)).foregroundStyle(.green)
                                    }
                                }
                                Spacer()
                                
                            }.padding(.horizontal, 1)
                            Spacer()
                            Text(marketStatusText())
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                        }
                }
            }.padding(.top, 1).padding(.horizontal, 8)
                
        }

        }
        .tabViewStyle(.verticalPage)
        .navigationTitle(selectedTitle?.rawValue.uppercased() ?? "")
        .onAppear{
            mainViewModel.fetchMarketList()
        }
    }
    
    
    
    func marketStatusText() -> String {
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
