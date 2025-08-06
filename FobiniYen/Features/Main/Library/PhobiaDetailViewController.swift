import UIKit
import SnapKit
import SwiftUI

class PhobiaDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let phobia: Phobia
    private let userPhobiaId: String
    weak var coordinator: PhobiaDetailCoordinator?
    private var phobiaDetail: PhobiaDetail?
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Main Card Container
    private let mainCardView = UIView()
    
    // Header Elements
    private let categoryTag = UILabel()
    private let titleLabel = UILabel()
    private let scientificNameLabel = UILabel()
    private let prevalenceContainer = UIView()
    private let prevalenceIcon = UIImageView()
    private let prevalenceLabel = UILabel()
    
    // Content Sections
    private let descriptionSection = UIView()
    private let descriptionIcon = UIImageView()
    private let descriptionTitleLabel = UILabel()
    private let descriptionTextLabel = UILabel()
    
    private let symptomsSection = UIView()
    private let symptomsIcon = UIImageView()
    private let symptomsTitleLabel = UILabel()
    private let symptomsStackView = UIStackView()
    
    private let strategiesSection = UIView()
    private let strategiesTitleLabel = UILabel()
    private let strategiesStackView = UIStackView()
    
    private let startTherapyButton = UIButton(type: .system)
    private let arTherapyButton = UIButton(type: .system)
    private let chatButton = UIButton(type: .system)
    
    // MARK: - Initialization
    init(phobia: Phobia, userPhobiaId: String) {
        self.phobia = phobia
        self.userPhobiaId = userPhobiaId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithPhobia()
        loadPhobiaDetail()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Fobi Detayları"
        
        // Scroll View
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Main Card View
        mainCardView.backgroundColor = .white
        mainCardView.layer.cornerRadius = 20
        mainCardView.layer.shadowColor = UIColor.black.cgColor
        mainCardView.layer.shadowOpacity = 0.1
        mainCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainCardView.layer.shadowRadius = 8
        contentView.addSubview(mainCardView)
        
        // Category Tag
        categoryTag.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        categoryTag.textColor = .white
        categoryTag.backgroundColor = .systemGray
        categoryTag.layer.cornerRadius = 8
        categoryTag.layer.masksToBounds = true
        categoryTag.textAlignment = .center
        mainCardView.addSubview(categoryTag)
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        mainCardView.addSubview(titleLabel)
        
        // Scientific Name
        scientificNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        scientificNameLabel.textColor = .secondaryLabel
        scientificNameLabel.font = UIFont.italicSystemFont(ofSize: 16)
        scientificNameLabel.textAlignment = .center
        mainCardView.addSubview(scientificNameLabel)
        
        // Prevalence Container
        prevalenceContainer.backgroundColor = .systemGray6
        prevalenceContainer.layer.cornerRadius = 12
        mainCardView.addSubview(prevalenceContainer)
        
        prevalenceIcon.image = UIImage(systemName: "person.2.fill")
        prevalenceIcon.tintColor = .systemGray
        prevalenceContainer.addSubview(prevalenceIcon)
        
        prevalenceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        prevalenceLabel.textColor = .secondaryLabel
        prevalenceContainer.addSubview(prevalenceLabel)
        
        // Description Section
        setupDescriptionSection()
        
        // Symptoms Section
        setupSymptomsSection()
        
        // Strategies Section
        setupStrategiesSection()
        
        // Start Therapy Button
        startTherapyButton.setTitle("Maruz Kalma Terapisini Başlat", for: .normal)
        startTherapyButton.setTitleColor(.white, for: .normal)
        startTherapyButton.backgroundColor = .black
        startTherapyButton.layer.cornerRadius = 16
        startTherapyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        startTherapyButton.addTarget(self, action: #selector(startTherapyTapped), for: .touchUpInside)
        mainCardView.addSubview(startTherapyButton)
        
        // AR Therapy Button
        arTherapyButton.setTitle("AR Terapisi Başlat", for: .normal)
        arTherapyButton.setTitleColor(.white, for: .normal)
        arTherapyButton.backgroundColor = .systemPurple
        arTherapyButton.layer.cornerRadius = 16
        arTherapyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        arTherapyButton.addTarget(self, action: #selector(arTherapyTapped), for: .touchUpInside)
        mainCardView.addSubview(arTherapyButton)
        
        // Chat Button
        chatButton.setImage(UIImage(systemName: "message.circle.fill"), for: .normal)
        chatButton.tintColor = .white
        chatButton.backgroundColor = .systemBlue
        chatButton.layer.cornerRadius = 28
        chatButton.layer.shadowColor = UIColor.black.cgColor
        chatButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatButton.layer.shadowRadius = 4
        chatButton.layer.shadowOpacity = 0.2
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        view.addSubview(chatButton)
        
        // Constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mainCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        categoryTag.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTag.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        scientificNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        prevalenceContainer.snp.makeConstraints { make in
            make.top.equalTo(scientificNameLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        prevalenceIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        prevalenceLabel.snp.makeConstraints { make in
            make.leading.equalTo(prevalenceIcon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        descriptionSection.snp.makeConstraints { make in
            make.top.equalTo(prevalenceContainer.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        symptomsSection.snp.makeConstraints { make in
            make.top.equalTo(descriptionSection.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        strategiesSection.snp.makeConstraints { make in
            make.top.equalTo(symptomsSection.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        startTherapyButton.snp.makeConstraints { make in
            make.top.equalTo(strategiesSection.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        arTherapyButton.snp.makeConstraints { make in
            make.top.equalTo(startTherapyButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        chatButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(56)
        }
    }
    
    private func setupDescriptionSection() {
        descriptionSection.backgroundColor = .clear
        mainCardView.addSubview(descriptionSection)
        
        descriptionIcon.image = UIImage(systemName: "book.fill")
        descriptionIcon.tintColor = .systemBlue
        descriptionSection.addSubview(descriptionIcon)
        
        descriptionTitleLabel.text = "Açıklama"
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        descriptionTitleLabel.textColor = .label
        descriptionSection.addSubview(descriptionTitleLabel)
        
        descriptionTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextLabel.textColor = .label
        descriptionTextLabel.numberOfLines = 0
        descriptionSection.addSubview(descriptionTextLabel)
        
        // Constraints
        descriptionIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(descriptionIcon.snp.trailing).offset(12)
            make.centerY.equalTo(descriptionIcon)
        }
        
        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupSymptomsSection() {
        symptomsSection.backgroundColor = .clear
        mainCardView.addSubview(symptomsSection)
        
        symptomsIcon.image = UIImage(systemName: "waveform.path.ecg")
        symptomsIcon.tintColor = .systemRed
        symptomsSection.addSubview(symptomsIcon)
        
        symptomsTitleLabel.text = "Yaygın Belirtiler"
        symptomsTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        symptomsTitleLabel.textColor = .label
        symptomsSection.addSubview(symptomsTitleLabel)
        
        symptomsStackView.axis = .vertical
        symptomsStackView.spacing = 8
        symptomsSection.addSubview(symptomsStackView)
        
        // Constraints
        symptomsIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        symptomsTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(symptomsIcon.snp.trailing).offset(12)
            make.centerY.equalTo(symptomsIcon)
        }
        
        symptomsStackView.snp.makeConstraints { make in
            make.top.equalTo(symptomsTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupStrategiesSection() {
        strategiesSection.backgroundColor = .clear
        mainCardView.addSubview(strategiesSection)
        
        strategiesTitleLabel.text = "Başa Çıkma Stratejileri"
        strategiesTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        strategiesTitleLabel.textColor = .label
        strategiesSection.addSubview(strategiesTitleLabel)
        
        strategiesStackView.axis = .vertical
        strategiesStackView.spacing = 8
        strategiesSection.addSubview(strategiesStackView)
        
        // Constraints
        strategiesTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        strategiesStackView.snp.makeConstraints { make in
            make.top.equalTo(strategiesTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - API Loading
    private func loadPhobiaDetail() {
        Task {
            do {
                let endpoint = APIEndpoint.getPhobiaDetail(phobiaId: phobia.id)
                let response: PhobiaDetailResponse = try await NetworkService.shared.request(endpoint, responseType: PhobiaDetailResponse.self)
                
                await MainActor.run {
                    self.phobiaDetail = response.data
                    self.updateUIWithDetail()
                }
            } catch {
                print("❌ Failed to load phobia detail: \(error)")
            }
        }
    }
    
    private func updateUIWithDetail() {
        guard let phobiaDetail = phobiaDetail else { return }
        
        // Update symptoms
        symptomsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for symptom in phobiaDetail.commonSymptoms {
            let symptomTag = createTagView(text: symptom)
            symptomsStackView.addArrangedSubview(symptomTag)
        }
        
        // Update strategies
        strategiesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let firstTherapy = phobiaDetail.therapies.first {
            for strategy in firstTherapy.strategies {
                let strategyLabel = UILabel()
                strategyLabel.text = "• \(strategy.title)"
                strategyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                strategyLabel.textColor = .label
                strategiesStackView.addArrangedSubview(strategyLabel)
            }
        }
    }
    
    // MARK: - Configuration
    private func configureWithPhobia() {
        categoryTag.text = phobia.categories.first?.name ?? "Genel"
        titleLabel.text = phobia.name
        scientificNameLabel.text = phobia.englishName
        prevalenceLabel.text = "Nüfusun %\(Int(phobia.percentage))\(Int(phobia.percentage).yuzdelikEki())"
        descriptionTextLabel.text = phobia.description
        
        // Category color
        let categoryName = phobia.categories.first?.name ?? "Genel"
        switch categoryName {
        case "Sosyal":
            categoryTag.backgroundColor = .systemBlue
        case "Durumsal":
            categoryTag.backgroundColor = .systemOrange
        case "Hayvan":
            categoryTag.backgroundColor = .systemGreen
        default:
            categoryTag.backgroundColor = .systemGray
        }
        
        // Symptoms and strategies will be loaded from API in loadPhobiaDetail()
        // For now, show loading state
        let loadingLabel = UILabel()
        loadingLabel.text = "Yükleniyor..."
        loadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        loadingLabel.textColor = .secondaryLabel
        loadingLabel.textAlignment = .center
        symptomsStackView.addArrangedSubview(loadingLabel)
        
        let strategiesLoadingLabel = UILabel()
        strategiesLoadingLabel.text = "Yükleniyor..."
        strategiesLoadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        strategiesLoadingLabel.textColor = .secondaryLabel
        strategiesLoadingLabel.textAlignment = .center
        strategiesStackView.addArrangedSubview(strategiesLoadingLabel)
    }
    
    private func createTagView(text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func chatButtonTapped() {
        coordinator?.showChat()
    }
    
    @objc private func startTherapyTapped() {
        // SwiftUI Therapy List View'ını aç
        let therapyListView = TherapyListView(phobiaId: phobia.id, phobiaName: phobia.name)
        let hostingController = UIHostingController(rootView: therapyListView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    @objc private func arTherapyTapped() {
        coordinator?.showARTherapy()
    }
}


