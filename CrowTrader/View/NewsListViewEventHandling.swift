

import Foundation
protocol NewsListViewEventHandling: AnyObject {
    func handle(event: NewsScreenViewModel.NewsListScreenEvent)
}
