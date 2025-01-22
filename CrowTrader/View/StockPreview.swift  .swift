//
//  StockPreview.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 03.01.2025.
//

import SwiftUI

struct StockPreview: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: StockPreviewViewModel
    @State private var price = ""
    
    @State private var selectedTimeframe: String = "1M"
    
    enum Event {
            case close
        }
    weak var coordinator: StockPreviewEventHandling?
    

    
    var body: some View {
        let latestPrice = viewModel.latestPrice
        let average = viewModel.average
        let emptyChartData = ChartData(
            chart: ChartQuote(
                result: [
                    ChartResult(
                        timestamp: [],
                        indicators: Indicators(
                            quote: [
                                Quote(
                                    close: [],
                                    high: [],
                                    open: [],
                                    low: [],
                                    volume: []
                                )
                            ]
                        ),meta: MetaQuote(symbol: "")
                    )
                ]
            )
        )
        NavigationView{
            VStack{
                StockChartView(data: viewModel.chartData ?? emptyChartData)
                    .frame(width: 370,height: 230)
                    .foregroundStyle(.gray)
                    .cornerRadius(15)
                    .padding(.top, 25)
  
                Section{
                    HStack {
                                        let timeframes = ["1W","1M", "3M", "6M", "1Y"]
                                        ForEach(timeframes, id: \.self) { timeframe in
                                            Button(action: {
                                                selectedTimeframe = timeframe
                                            }) {
                                                Text(timeframe)
                                            }.buttonStyle(.timeframe(isSelected: selectedTimeframe == timeframe))

                                        }
                                    }
                                    .padding(.horizontal, 25)
                }
                
                Section{
                    HStack{
                        Text(viewModel.chartData?.symbol ?? "").font(.title)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text(String(format: "%.2f", latestPrice))
                            Text("+ 3.2%")
                        }
                    }.padding().background(.ultraThickMaterial)
                        .cornerRadius(16)
                }
                
                Section{
                    VStack{
                        HStack{
                            Text("Volume").font(.headline)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("180$")
                            }
                        }.padding(8)
                        HStack{
                            Text("average 30d").font(.headline)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(String(format: "%.2f", average.thirty))
                            }
                        }.padding(8)
                        HStack{
                            Text("average 60d").font(.headline)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(String(format: "%.2f", average.sixty))
                            }
                        }.padding(8)
                        
                    }.padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                }
                
                Section{
                    TextField("Enter price", text: $price)
                                .keyboardType(.decimalPad)
                                .padding(12) // Add padding inside the TextField
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.green, lineWidth: 2) // Green border
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                    
                    Button(action: {
                        //TODO
                    }){
                        Text("Buy")
                            .frame(width: 370,height: 50,alignment: .center)
                        
                    }
                    .background(.green)
                        .foregroundStyle(.white)
                        .cornerRadius(25)
                    
                    
                    
                }
                
            }.padding()
                .navigationTitle("AAPL")
                    .toolbar(){
                        ToolbarItem(placement: .topBarLeading){
                            Button(action: {
                                dismiss()
                            }){
                                Text("Cancel").foregroundStyle(.green)
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button(action: {
                                //todo add to watchlist
                                dismiss()
                                
                            }){
                                Text("Watch").foregroundStyle(.green)
                            }
                        }
                    }.onAppear(){
                        Task{
                            await viewModel.fetchChart(symbol: "aapl")
                        }
                    }
        }

    }
}

