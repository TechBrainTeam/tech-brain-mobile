//
//  OnboardingDetailViewController.swift
//  FobiniYen
//
//  Created by Serhat  Şimşek  on 1.08.2025.
//

import UIKit
import SnapKit

final class OnboardingDetailViewController: UIViewController {
    
    // MARK: - Properties
    let pageModel: OnboardingPageModel
    
    // MARK: - UI Elements
    private lazy var heroIconContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = pageModel.backgroundColor
        containerView.layer.cornerRadius = 60
        
        let iconImageView = UIImageView()
        iconImageView.image = pageModel.pageTopIcon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        return containerView
    }()
    
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = pageModel.pageTitle
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pageSubtitleContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .systemGray5
        container.layer.cornerRadius = 6
        return container
    }()
    
    private lazy var pageSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = pageModel.pageSubtitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = pageModel.pageDescription
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var featuresView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 16
        return stackview
    }()
    
    private lazy var bottomIconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Init
    init(pageModel: OnboardingPageModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white // Always white background
        setupUI()
        configureData()
        setupFeaturesContent()
        setupBottomIcons()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(heroIconContainer)
        view.addSubview(pageTitleLabel)
        view.addSubview(pageSubtitleContainer)
        pageSubtitleContainer.addSubview(pageSubtitleLabel)
        view.addSubview(pageDescriptionLabel)
        view.addSubview(featuresView)
        featuresView.addSubview(featuresStackView)
        view.addSubview(bottomIconsStackView)
        
        // Icon Container
        heroIconContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        // Title Label
        pageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(heroIconContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Subtitle Container
        pageSubtitleContainer.snp.makeConstraints { make in
            make.top.equalTo(pageTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // Subtitle Label
        pageSubtitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        }
        
        // Description Label
        pageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(pageSubtitleContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Features View
        featuresView.snp.makeConstraints { make in
            make.top.equalTo(pageDescriptionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(120) // Minimum height for 3 items
        }
        
        // Features Stack View
        featuresStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        // Bottom Icons
        bottomIconsStackView.snp.makeConstraints { make in
            make.top.equalTo(featuresView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(24)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setupFeaturesContent() {
        guard let features = pageModel.features else { return }
        
        features.forEach { featureText in
            let featureRow = createFeatureRow(text: featureText)
            featuresStackView.addArrangedSubview(featureRow)
        }
    }
    
    private func configureData() {
        // Configure hero icon
        if let heroIcon = pageModel.pageTopIcon {
            let iconImageView = heroIconContainer.subviews.first { $0 is UIImageView } as? UIImageView
            iconImageView?.image = heroIcon
            iconImageView?.tintColor = .white
        }
        
//        heroIconContainer.backgroundColor = pageModel.backgroundColor
        
        // Configure texts
        pageTitleLabel.text = pageModel.pageTitle
        pageTitleLabel.textColor = .black
        
        pageSubtitleLabel.text = pageModel.pageSubtitle
        pageSubtitleLabel.textColor = .black
        
        pageDescriptionLabel.text = pageModel.pageDescription
        pageDescriptionLabel.textColor = .black
        
        // Configure subtitle container background
        pageSubtitleContainer.backgroundColor = .systemGray5
        
        // Configure features view background
        featuresView.backgroundColor = .systemGray6
    }
    
    private func createFeatureRow(text: String) -> UIView {
        let containerView = UIView()
        
        // Bullet point
        let bulletView = UIView()
        bulletView.backgroundColor = .black
        bulletView.layer.cornerRadius = 4
        
        // Label
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        
        containerView.addSubview(bulletView)
        containerView.addSubview(label)
        
        bulletView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(8)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(bulletView.snp.trailing).offset(12)
            make.top.trailing.bottom.equalToSuperview()
        }
        
        return containerView
    }
    
    private func setupBottomIcons() {
        guard let icons = pageModel.pageBottomIcons else { return }
        let iconColors: [UIColor] = [.systemYellow, .systemBlue, .systemPink]
        
        icons.enumerated().forEach { index, icon in
            let iconImageView = UIImageView()
            iconImageView.image = icon
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.tintColor = iconColors[safe: index] ?? .systemGray
            
            iconImageView.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
            
            bottomIconsStackView.addArrangedSubview(iconImageView)
        }
    }
}

// MARK: - Array Extension
private extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
