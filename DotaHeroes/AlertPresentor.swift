
import UIKit

final class AlertPresenter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: { _ in
            alertModel.completion()
        })
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Alert"
        viewController?.present(alert, animated: true, completion: nil)
    }
}
