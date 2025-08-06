import UIKit

protocol ChatCoordinatorDelegate: AnyObject {
    func chatDidFinish()
}

class ChatCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    weak var delegate: ChatCoordinatorDelegate?
    
    private let userPhobiaId: String
    private let phobiaName: String
    
    // MARK: - Initialization
    init(navigationController: UINavigationController, userPhobiaId: String, phobiaName: String) {
        self.navigationController = navigationController
        self.userPhobiaId = userPhobiaId
        self.phobiaName = phobiaName
    }
    
    // MARK: - Coordinator
    func start() {
        let chatViewModel = ChatViewModel(userPhobiaId: userPhobiaId, phobiaName: phobiaName)
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        chatViewController.coordinator = self
        
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func finish() {
        delegate?.chatDidFinish()
        parentCoordinator?.removeChildCoordinator(self)
    }
} 