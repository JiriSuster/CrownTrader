

import Foundation

protocol SnapsListViewEventHandling: AnyObject {
    func handle(event: SnapsViewModel.SnapsEvent)
}
