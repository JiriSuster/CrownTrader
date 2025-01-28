
import Foundation

protocol MainViewEventHandling: AnyObject {
    func handle(event: MainScreenViewModel.Event)
}
