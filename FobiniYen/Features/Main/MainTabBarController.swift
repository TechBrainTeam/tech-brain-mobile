//
//  MainTabBarController.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 4.08.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    private var tabCoordinators: [Coordinator] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    // MARK: - Setup
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.systemBackground
        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.systemGray
        
        // Tab bar item font
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ], for: .normal)
    }
    
    private func setupViewControllers() {
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let libraryViewModel = LibraryViewModel()
        let libraryVC = LibraryViewController(viewModel: libraryViewModel)
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        // Library Coordinator'ı başlat
        let libraryCoordinator = LibraryCoordinator(navigationController: libraryNav)
        libraryCoordinator.delegate = self
        tabCoordinators.append(libraryCoordinator)
        libraryCoordinator.start()
        libraryNav.tabBarItem = UITabBarItem(
            title: "Kütüphane",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        let therapyVC = TherapyViewController()
        let therapyNav = UINavigationController(rootViewController: therapyVC)
        therapyNav.tabBarItem = UITabBarItem(
            title: "Terapi",
            image: UIImage(systemName: "heart.text.square"),
            selectedImage: UIImage(systemName: "heart.text.square.fill")
        )
        
        let breathingVC = BreathingViewController()
        let breathingNav = UINavigationController(rootViewController: breathingVC)
        breathingNav.tabBarItem = UITabBarItem(
            title: "Nefes",
            image: UIImage(systemName: "wind"),
            selectedImage: UIImage(systemName: "wind")
        )
        
        let progressVC = ProgressViewController()
        let progressNav = UINavigationController(rootViewController: progressVC)
        progressNav.tabBarItem = UITabBarItem(
            title: "İlerleme",
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis")
        )
        
        viewControllers = [
            dashboardNav,
            libraryNav,
            therapyNav,
            breathingNav,
            progressNav
        ]
        
        selectedIndex = 0 // Ana Sayfa seçili başlasın
    }
}



// MARK: - LibraryCoordinatorDelegate
extension MainTabBarController: LibraryCoordinatorDelegate {
    func libraryDidFinish() {
        // Library coordinator tamamlandığında yapılacak işlemler
        print("Library tamamlandı")
    }
}

// MARK: - SettingsCoordinatorDelegate
extension MainTabBarController: SettingsCoordinatorDelegate {
    func didLogout() {
        // Kullanıcı çıkış yaptığında giriş ekranına yönlendir
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
