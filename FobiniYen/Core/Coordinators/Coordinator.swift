//
//  Coordinator.swift
//  FobiniYen
//
//  Created by Serhat  Şimşek  on 1.08.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        coordinator.parentCoordinator = nil
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}