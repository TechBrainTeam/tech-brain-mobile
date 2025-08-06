//
//  OnboardingCoordinator.swift
//  FobiniYen
//
//  Created by Serhat  Şimşek  on 1.08.2025.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingDidFinish()
}

final class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    weak var delegate: OnboardingCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.delegate = self
        navigationController?.setViewControllers([onboardingVC], animated: false)
    }
}

// MARK: - OnboardingViewControllerDelegate
extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func onboardingDidFinish() {
        delegate?.onboardingDidFinish()
    }
}