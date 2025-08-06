import UIKit

protocol PhobiaDetailCoordinatorDelegate: AnyObject {
    func phobiaDetailDidFinish()
}

class PhobiaDetailCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    weak var delegate: PhobiaDetailCoordinatorDelegate?
    
    private let phobia: Phobia
    private let userPhobiaId: String
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, phobia: Phobia, userPhobiaId: String) {
        self.navigationController = navigationController
        self.phobia = phobia
        self.userPhobiaId = userPhobiaId
    }
    
    // MARK: - Coordinator
    func start() {
        let detailViewController = PhobiaDetailViewController(phobia: phobia, userPhobiaId: userPhobiaId)
        detailViewController.coordinator = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func showChat() {
        // Eğer zaten bir chat coordinator varsa, onu temizle
        childCoordinators.removeAll { $0 is ChatCoordinator }
        
        let chatCoordinator = ChatCoordinator(
            navigationController: navigationController!,
            userPhobiaId: userPhobiaId,
            phobiaName: phobia.name
        )
        chatCoordinator.delegate = self
        chatCoordinator.parentCoordinator = self
        addChildCoordinator(chatCoordinator)
        chatCoordinator.start()
    }
    
    func showARTherapy() {
        // Eğer zaten bir AR therapy coordinator varsa, onu temizle
        childCoordinators.removeAll { $0 is ARTherapyCoordinator }
        
        let arTherapyCoordinator = ARTherapyCoordinator(
            navigationController: navigationController!,
            phobiaName: phobia.name,
            userPhobiaId: userPhobiaId
        )
        arTherapyCoordinator.delegate = self
        arTherapyCoordinator.parentCoordinator = self
        addChildCoordinator(arTherapyCoordinator)
        arTherapyCoordinator.start()
    }
    
    func finish() {
        delegate?.phobiaDetailDidFinish()
        parentCoordinator?.removeChildCoordinator(self)
    }
}

// MARK: - ChatCoordinatorDelegate
extension PhobiaDetailCoordinator: ChatCoordinatorDelegate {
    func chatDidFinish() {
        // Chat coordinator tamamlandığında yapılacak işlemler
        print("Chat tamamlandı")
    }
}

// MARK: - ARTherapyCoordinatorDelegate
extension PhobiaDetailCoordinator: ARTherapyCoordinatorDelegate {
    func arTherapyDidFinish() {
        // AR therapy coordinator tamamlandığında yapılacak işlemler
        print("AR Therapy tamamlandı")
    }
} 