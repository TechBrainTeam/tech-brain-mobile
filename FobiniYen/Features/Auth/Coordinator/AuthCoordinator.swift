//
//  AuthCoordinator.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import UIKit

// MARK: - Auth Coordinator Delegate
protocol AuthCoordinatorDelegate: AnyObject {
    func authDidComplete()
}

// MARK: - Auth Coordinator
final class AuthCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    weak var delegate: AuthCoordinatorDelegate?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Methods
    func start() {
        showLoginScreen()
    }
    
    // MARK: - Navigation Methods
    private func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController?.setViewControllers([loginVC], animated: false)
    }
    
    func showRegisterScreen() {
        let registerVC = RegisterViewController()
        registerVC.coordinator = self
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func showForgotPasswordScreen() {
        // TODO: Şifremi unuttum ekranı
        let alert = UIAlertController(
            title: "Şifremi Unuttum",
            message: "Bu özellik yakında eklenecek.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        navigationController?.present(alert, animated: true)
    }
    
    func authDidComplete() {
        print("🚀 AuthCoordinator authDidComplete called")
        // Ana ekrana yönlendir
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            print("✅ Setting MainTabBarController as root")
            let mainTabBarController = MainTabBarController()
            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
            print("✅ MainTabBarController set successfully")
        } else {
            print("❌ Failed to get window scene or window")
        }
        
        delegate?.authDidComplete()
    }
    
    func popToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }
}