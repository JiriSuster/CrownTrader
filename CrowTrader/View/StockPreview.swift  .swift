

import SwiftUI

struct StockPreview: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var snapsViewModel: SnapsViewModel
    @StateObject var viewModel: StockPreviewViewModel
    @StateObject var watchlistViewModel: WatchListViewModel
    @State private var price = ""
    @StateObject var connector: WatchConnector
    @State private var selectedTimeframe: String = "1d"
    
    weak var coordinator: StockPreviewEventHandling?
    
    private var isValidPrice: Bool {
        if let priceValue = Double(price), priceValue > 0 {
            return snapsViewModel.balance.moneyToInvest >= priceValue
        }
        return false
    }
    
    var body: some View {
        var stock = viewModel.stockItem ?? StockItem(symbol: "", title: "", price: 1, ammount: 1)
        let latestPrice = viewModel.stockItem?.price ?? 0
        let average = viewModel.average

        NavigationView{
            VStack{
                StockChartView(data: viewModel.chartData)
                    .frame(width: 370,height: 230)
                    .foregroundStyle(.gray)
                    .cornerRadius(15)
                    .padding(.top, 25)
  
                Section{
                    HStack {
                                        let timeframes = ["1d", "3mo", "6mo", "1y"]
                                        ForEach(timeframes, id: \.self) { timeframe in
                                            Button(action: {
                                                selectedTimeframe = timeframe
                                                viewModel.send(.timeframeSelected(stock.symbol, selectedTimeframe))
                                            }) {
                                                Text(timeframe)
                                            }.buttonStyle(.timeframe(isSelected: selectedTimeframe == timeframe))

                                        }
                                    }
                                    .padding(.horizontal, 25)
                }
                
                Section{
                    HStack{
                        Text(viewModel.stockItem?.symbol ?? "").font(.title)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text(String(format: "%.2f", latestPrice)).font(.title).fontWeight(.bold)
                            Text(String(viewModel.stockItem?.percentChange ?? 0) + "%").foregroundStyle(viewModel.stockItem?.color ?? Color.white)
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
                                Text(String(viewModel.chartData.latestVolume ?? 0))
                            }
                        }.padding(8)
                        HStack{
                            Text("average 30d").font(.headline)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(String(format: "%.2f", average.thirty ?? "unknown"))
                            }
                        }.padding(8)
                        HStack{
                            Text("average 60d").font(.headline)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(String(format: "%.2f", average.sixty ?? "unknown"))
                            }
                        }.padding(8)
                        
                    }.padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                }
                
                Section{
                    TextField("Enter price", text: $price)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                    
                    Button(action: {
                        viewModel.send(.addToSnapslistClick(stock,price))
                        dismiss()
                    }){
                        Text("Buy")
                    }
                    .buttonStyle(.bottomButtonStyle)
                    .disabled(!isValidPrice)
                }
                
            }.padding()
                .navigationTitle(stock.title)
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
                                if(watchlistViewModel.isInWatchlist(stock: stock)){
                                    stock.is_watchlist = true
                                }
                                viewModel.send(.addToWatchlistClick(stock))
                                
                            }){
                                Text(watchlistViewModel.isInWatchlist(stock: stock) ? "Unwatch" : "Watch").foregroundStyle(.green)
                            }
                        }
                    }.onAppear(){
                        viewModel.send(.appear(stock.symbol))
                    }
        }

    }
}

