//
//  NewsListView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct NewsItem: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageName: String
}

struct NewsListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    
    let newsItems: [NewsItem] = [
        NewsItem(title: "Breaking News", description: "This is a description for the breaking news.", imageName: "newspaper"),
        NewsItem(title: "Tech Update", description: "Latest advancements in technology.", imageName: "laptopcomputer"),
        NewsItem(title: "Stock Market Update", description: "Today's stock market performance.", imageName: "chart.bar"),
        NewsItem(title: "Weather Report", description: "A look at the weather forecast for the day.", imageName: "cloud.sun")
    ]
    
    enum Event {
            case close
        }
    weak var coordinator: NewsListViewEventHandling?

    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .leading){
                
                Text("News")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading)
                
                List(newsItems) { newsItem in
                    //NavigationLink(destination: NewsDetailView(newsItem: newsItem)){
                    Button(action: {
                                            // Send the action to the ViewModel and set the selected news item
                                            print("ffff")
                                            mainViewModel.send(.didTapNewsItem(newsItem))
                                            
                                        }) {
                                            HStack {
                                                
                                                Image(systemName: newsItem.imageName)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundColor(.blue)
                                                    .padding(.trailing,20)
                                                
                                                VStack(alignment: .leading) {
                                                    
                                                    Text(newsItem.title)
                                                        .font(.headline)
                                                        .foregroundColor(.primary)
                                                    
                                                    Text(newsItem.description)
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(1)
                                                }
                                            }
                        //}
                    }
                }
            }
            
        }
        
        
        
    }
}
