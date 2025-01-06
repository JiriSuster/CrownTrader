//
//  NewsDetailView.swift
//  CrowTrader
//
//  Created by Adéla Kulíšková on 02.01.2025.
//

import SwiftUI

struct NewsDetailView: View {
    enum Event {
            case close
        }
    weak var coordinator: NewsDetailViewEventHandling?
    var newsItem: NewsItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Title
                Text(newsItem.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                Divider()
                
                Image(uiImage: (UIImage(named: newsItem.imageName) ?? UIImage(named: "empty")) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(20)
                
                Divider()
                
                Text("Description")
                Text(newsItem.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                
                

            }
            .padding()
            
            
        }
    }
}
