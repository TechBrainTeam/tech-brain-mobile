//
//  OnboardingViewController.swift
//  FobiniYen
//
//  Created by Serhat  Şimşek  on 1.08.2025.
//

import UIKit
import SnapKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish()
}

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OnboardingViewControllerDelegate?
    private let pages = OnboardingPageModel.pages
    private var currentIndex = 0
    
    // MARK: - UI Elements
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Atla", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Devam Et", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageIndicatorLabel: UILabel = {
        let label = UILabel()
        label.text = "1 / \(pages.count)"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFirstPage()
    }
}

// MARK: - Setup
private extension OnboardingViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        // Add PageViewController as child
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        // Add controls
        [skipButton, pageControl, nextButton, pageIndicatorLabel].forEach {
            view.addSubview($0)
        }
        
        // Layout
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(skipButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(44)
        }
        
        pageControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(skipButton)
            $0.height.equalTo(8)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(pageIndicatorLabel.snp.top).offset(-16)
            $0.height.equalTo(50)
        }
        
        pageIndicatorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func setupFirstPage() {
        let firstPage = OnboardingDetailViewController(pageModel: pages[0])
        pageViewController.setViewControllers([firstPage], direction: .forward, animated: false)
        updateUI()
    }
}

// MARK: - Actions
private extension OnboardingViewController {
    @objc func nextButtonTapped() {
        if currentIndex < pages.count - 1 {
            // Sonraki sayfa
            currentIndex += 1
            let nextPage = OnboardingDetailViewController(pageModel: pages[currentIndex])
            pageViewController.setViewControllers([nextPage], direction: .forward, animated: true)
            updateUI()
        } else {
            // Son sayfa - bitir
            delegate?.onboardingDidFinish()
        }
    }
    
    @objc func skipButtonTapped() {
        delegate?.onboardingDidFinish()
    }
    
    func updateUI() {
        let currentPage = pages[currentIndex]
        
        // Keep background white (no animation needed)
        
        // Page control
        pageControl.currentPage = currentIndex
        
        // Button title
        nextButton.setTitle(currentPage.buttonTitle, for: .normal)
        
        // Page indicator
        pageIndicatorLabel.text = "\(currentIndex + 1) / \(pages.count)"
        
        // Skip button visibility
        skipButton.isHidden = (currentIndex == pages.count - 1)
    }
}

// MARK: - UIPageViewController DataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let detailVC = viewController as? OnboardingDetailViewController,
              let currentPageIndex = pages.firstIndex(where: { $0.pageTitle == detailVC.pageModel.pageTitle }),
              currentPageIndex > 0 else { return nil }
        
        return OnboardingDetailViewController(pageModel: pages[currentPageIndex - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let detailVC = viewController as? OnboardingDetailViewController,
              let currentPageIndex = pages.firstIndex(where: { $0.pageTitle == detailVC.pageModel.pageTitle }),
              currentPageIndex < pages.count - 1 else { return nil }
        
        return OnboardingDetailViewController(pageModel: pages[currentPageIndex + 1])
    }
}

// MARK: - UIPageViewController Delegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? OnboardingDetailViewController,
           let currentIndex = pages.firstIndex(where: { $0.pageTitle == currentVC.pageModel.pageTitle }) {
            self.currentIndex = currentIndex
            updateUI()
        }
    }
}
