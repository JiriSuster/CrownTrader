import SwiftUI

struct NewsItem: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageUrl: String
}

struct NewsListView: View {
    @StateObject var viewModel: NewsScreenViewModel
    
    enum Event {
        case close
    }
    weak var coordinator: NewsListViewEventHandling?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("News")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading)

                List(viewModel.newsItems) { newsItem in
                    Button(action: {
                        viewModel.send(.didTapNewsItem(newsItem))
                    }) {
                        HStack {
                            AsyncImage(url: URL(string: newsItem.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .padding(.trailing, 20)

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
                    }
                }
            }
        }.onAppear(){
            viewModel.isLoading = true
            viewModel.send(.refetchNews)
            viewModel.isLoading = true
        }
        .overlay {
            if (viewModel.isLoading) {
                LoadingView()
            }}
        
    }
}
