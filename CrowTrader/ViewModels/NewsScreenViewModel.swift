//
//  NewsScreenViewModel.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 06.01.2025.
//

import Foundation
class NewsScreenViewModel: ObservableObject{
    private weak var coordinator: NewsListViewEventHandling?
    @Published var newsItems: [NewsItem] = []
    let apiManager: APIManaging
    
    init(apiManager: APIManaging, coordinator: NewsListViewEventHandling? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator
    }
    
    func send(_ action: NewsListScreenAction) {
        switch action {
        case .didTapNewsItem(let newsItem):
            coordinator?.handle(event: .detailNews(newsItem))
        case .refetchNews:
            coordinator?.handle(event: .fetch)
        }
    }
    
    
}

// MARK: Event
extension NewsScreenViewModel {
    enum NewsListScreenEvent {
        case detailNews(NewsItem)
        case fetch
    }
}

// MARK: Action
extension NewsScreenViewModel {
    enum NewsListScreenAction {
        case didTapNewsItem(NewsItem)
        case refetchNews
    }
}

@MainActor
extension NewsScreenViewModel{
    func fetchNews() {
        Task {
            do {
                let newsData: NewsData = try await apiManager.request(
                    NewsDataRouter.search
                )
                let newsItems = newsData.Data.map { query in
                                    NewsItem(
                                        title: query.title,
                                        description: query.body,
                                        imageUrl: query.imageurl
                                    )
                                }
                self.newsItems = newsItems
            } catch {
                print(error)
            }
        }
    }
}
