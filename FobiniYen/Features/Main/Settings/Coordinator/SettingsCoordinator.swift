import UIKit

protocol SettingsCoordinatorDelegate: AnyObject {
    func didLogout()
}

class SettingsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    weak var delegate: SettingsCoordinatorDelegate?
    weak var settingsViewController: SettingsViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsVC = SettingsViewController()
        let settingsViewModel = SettingsViewModel()
        settingsViewModel.coordinator = self
        settingsVC.viewModel = settingsViewModel
        
        self.settingsViewController = settingsVC
        navigationController?.present(settingsVC, animated: true)
    }
    
    func logout() {
        delegate?.didLogout()
    }
} 