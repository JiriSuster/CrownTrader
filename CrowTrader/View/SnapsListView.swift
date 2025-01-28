//
//  SnapsListView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI
import Charts

struct SnapsListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    @ObservedObject var viewModel: SnapsViewModel
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var showAddMoneyAlert = false
    @State private var enteredAmount = ""
    
    var body: some View {
        @State var balance = viewModel.balance
        NavigationView{
            VStack{
                TextField("Search...", text: $searchText)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onSubmit {
                                    mainViewModel.send(.searchConfirmed(searchText))
                                }
                
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Profit").font(.title)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(String(format: "%0.2f",balance.total))$").font(.title)
                            Text("\(String(format: "%0.2f",balance.profit))%").font(.title3).foregroundStyle(.green)
                        }
                    }.padding(8)
                    HStack{
                        Text("Money to invest").font(.title2).foregroundStyle(.gray)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(String(format: "%0.2f",balance.moneyToInvest))$").font(.title2).foregroundStyle(.gray)
                        }
                    }.padding(8)
                    
                }.padding(4)
                    .background(.ultraThickMaterial)
                    .cornerRadius(16)
                
                HStack{
                    Button(action: { showAddMoneyAlert = true }){
                        Text("Add money")
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 180, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    }.alert("Add Money Amount", isPresented: $showAddMoneyAlert, actions: {
                        TextField("Enter amount of money:", text: $enteredAmount)
                            .keyboardType(.decimalPad)
                        Button("Add") {
                            print("Added amount \(enteredAmount)")
                            viewModel.send(.didTapAddBalance(Double(enteredAmount) ?? 5))
                            enteredAmount = ""
                        }
                        Button("Cancel", role: .cancel) {
                            enteredAmount = ""
                        }
                    })
                    Spacer()
                    Button(action: { showAlert = true}){
                        Text("Reset account")
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 180, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }.alert(
                        "Are you sure you want to reset your account?",
                        isPresented: $showAlert
                    ) {
                        Button("Delete", role: .destructive) {
                            viewModel.send(.didTapReset)
                            print("Account deleted")
                        }
                        Button("Cancel", role: .cancel) {
                            print("Deletion canceled")
                        }
                    }
                }.padding()
                
                HStack{
                    Text("Snaps").font(.title)
                    Spacer()
                }
                
                ScrollView{
                    VStack(spacing: 8) {
                        
                        ForEach(viewModel.snapsList) { stock in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(stock.title)
                                        .font(.headline)
                                    Text(stock.title)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                HStack{
                                    VStack(alignment: .trailing){
                                        Text("$\(String(format: "%.2f", stock.price))")
                                            .font(.headline)
                                        Text("\(String(format: "%.2f", stock.percentChange!))%")
                                            .font(.body)
                                            .foregroundColor(stock.color)
                                    }
                                    Button(action: {
                                        viewModel.send(.didTapSell(stock))
                                    }){
                                        Text("Sell")
                                    }.buttonStyle(.dismissCrownButtonStyle)
                                }
                                
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onTapGesture {
                                mainViewModel.send(.didTapStockPreview(stock))
                            }
                        }
                    }
                }
            }.onAppear(){
                viewModel.send(.appear)
            }
        }
        

        }
}

