
import SwiftUI

struct WatchListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    @StateObject var viewModel: WatchListViewModel
    @State private var searchText = ""
    
    var body: some View {
        @State var watchList = viewModel.watchList
        NavigationView{
            ZStack{
                VStack{
                    
                    VStack{
                        TextField("Search...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: searchText) { oldValue, newValue in
                                print(newValue)
                                mainViewModel.send(.searchTextChanged(newValue))
                            }
                            .onSubmit {
                                mainViewModel.send(.searchConfirmed(searchText))
                                searchText = ""
                                mainViewModel.send(.searchTextChanged(searchText))
                            }
                    }.padding(.horizontal)
                    
                    
                    HStack{
                        Text("Watchlist").font(.title)
                        Spacer()
                    }.padding(.top, 20)
                    
                    ScrollView{
                        VStack(spacing: 8) {
                            
                            ForEach(watchList, id: \.title) { watchedStock in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(watchedStock.title)
                                            .font(.headline)
                                        Text(watchedStock.symbol)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Text("$\(String(format: "%.2f", watchedStock.price))")
                                            .font(.headline)
                                        Text("\(String(format: "%.2f", watchedStock.percentChange ?? 0))%")
                                            .font(.body)
                                            .foregroundColor(watchedStock.color)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .onTapGesture {
                                    self.viewModel.send(.didTapStockPreview(watchedStock))
                                }
                            }
                        }
                    }
                }.onAppear(){
                    searchText = ""
                    mainViewModel.send(.searchTextChanged(""))
                    viewModel.send(.appear)
                }
                
                
                VStack{
                    if(mainViewModel.search != nil){
                        ForEach(mainViewModel.search!.quotes, id: \.self.symbol){ quote in
                            Text("\(quote.shortname)").onTapGesture {
                                Task{
                                    let stock = await mainViewModel.getStockItemFromSymbol(symbol: quote.symbol)
                                    mainViewModel.send(.didTapStockPreview(stock))
                                    searchText = ""
                                    mainViewModel.send(.searchTextChanged(""))
                                }
                            }.padding()
                        }
                    }
                }.background(.ultraThickMaterial)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.bottom, 120)
                    .onTapGesture(perform: {
                        searchText = ""
                        mainViewModel.send(.searchTextChanged(""))
                    })
                
            }
            .onTapGesture(perform: {
                searchText = ""
                mainViewModel.send(.searchTextChanged(""))
            })
        }
    }
}

