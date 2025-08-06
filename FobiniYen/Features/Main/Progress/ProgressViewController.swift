//
//  ProgressViewController.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 4.08.2025.
//

import UIKit
import SwiftUI

final class ProgressViewController: UIViewController {
    
    // MARK: - UI Elements
    private var hostingController: UIHostingController<UserProgressView>?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // SwiftUI view'ını host et
        let progressView = UserProgressView()
        hostingController = UIHostingController(rootView: progressView)
        
        if let hostingController = hostingController {
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
}
