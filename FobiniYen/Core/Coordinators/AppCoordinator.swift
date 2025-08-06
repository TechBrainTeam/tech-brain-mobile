//
//  AppCoordinator.swift
//  FobiniYen
//
//  Created by Serhat  Şimşek  on 1.08.2025.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    //MARK: Properties
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    //MARK: İnit
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Funcs
    func start() {
        // İlk açılış kontrolü
        if isFirstLaunch() {
            // İlk açılış - Onboarding göster
            startOnboarding()
        } else {
            // Sonraki açılışlar - Giriş durumuna göre yönlendir
            if AuthService.shared.isLoggedIn() {
                startMainApp()
            } else {
                startAuth()
            }
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        return !hasSeenOnboarding
    }
    
    private func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        UserDefaults.standard.synchronize()
    }
    
    // Debug için - onboarding'i sıfırla
    func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
        UserDefaults.standard.synchronize()
    }
    
    private func startOnboarding() {
        guard let navigationController = navigationController else { return }
        
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.parentCoordinator = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func startAuth() {
        guard let navigationController = navigationController else { return }
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        authCoordinator.parentCoordinator = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func startMainApp() {
        // TabBar Controller'ı başlat
        let mainTabBarController = MainTabBarController()
        navigationController?.setViewControllers([mainTabBarController], animated: true)
        print("🎉 Ana uygulama (TabBar) başlatıldı!")
    }
}
// MARK: - OnboardingCoordinatorDelegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingDidFinish() {
        childCoordinators.removeAll { $0 is OnboardingCoordinator }
        
        // Onboarding'i görüldü olarak işaretle
        markOnboardingAsSeen()
        
        // Kullanıcı giriş yapmış mı kontrol et
        if AuthService.shared.isLoggedIn() {
            startMainApp()
        } else {
            startAuth()
        }
    }
}

// MARK: - AuthCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func authDidComplete() {
        childCoordinators.removeAll { $0 is AuthCoordinator }
        startMainApp()
    }
}

