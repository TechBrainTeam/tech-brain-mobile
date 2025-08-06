//
//  BreathingViewController.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 4.08.2025.
//

import UIKit
import SwiftUI

final class BreathingViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    // MARK: - Setup
    private func setupSwiftUIView() {
        let breathingView = BreathingView()
        let hostingController = UIHostingController(rootView: breathingView)
        
        // Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}