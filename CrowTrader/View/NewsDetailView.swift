
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
                
                AsyncImage(url: URL(string: newsItem.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .cornerRadius(20)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(20)
                    case .failure:
                        Image("empty")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(20)
                    @unknown default:
                        EmptyView()
                    }
                }
                
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
