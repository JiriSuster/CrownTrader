

import Foundation

protocol WatchListEventHandling: AnyObject {
    func handle(event: WatchListViewModel.Event)
}
