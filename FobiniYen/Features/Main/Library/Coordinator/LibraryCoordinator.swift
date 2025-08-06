import UIKit

protocol LibraryCoordinatorDelegate: AnyObject {
    func libraryDidFinish()
}

class LibraryCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    weak var delegate: LibraryCoordinatorDelegate?
    
    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    func start() {
        let libraryViewModel = LibraryViewModel()
        let libraryViewController = LibraryViewController(viewModel: libraryViewModel)
        libraryViewController.coordinator = self
        
        navigationController?.pushViewController(libraryViewController, animated: true)
    }
    
    func showPhobiaDetail(phobia: Phobia, userPhobiaId: String) {
        // Eğer zaten bir detail coordinator varsa, onu temizle
        childCoordinators.removeAll { $0 is PhobiaDetailCoordinator }
        
        let detailCoordinator = PhobiaDetailCoordinator(
            navigationController: navigationController!,
            phobia: phobia,
            userPhobiaId: userPhobiaId
        )
        detailCoordinator.delegate = self
        detailCoordinator.parentCoordinator = self
        addChildCoordinator(detailCoordinator)
        detailCoordinator.start()
    }
    
    func finish() {
        delegate?.libraryDidFinish()
        parentCoordinator?.removeChildCoordinator(self)
    }
}

// MARK: - PhobiaDetailCoordinatorDelegate
extension LibraryCoordinator: PhobiaDetailCoordinatorDelegate {
    func phobiaDetailDidFinish() {
        // Detail coordinator tamamlandığında yapılacak işlemler
        print("Phobia detail tamamlandı")
    }
} 