
import Foundation
protocol StockPreviewEventHandling: AnyObject {
    func handle(event: StockPreviewViewModel.Event)
}
