import UIKit
import SnapKit

class CopingStrategiesViewController: UIViewController {
    
    // MARK: - Properties
    private let titleText: String
    private let strategies: [CopingStrategy]
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let summaryStackView = UIStackView()
    
    // Strategies Grid
    private let strategiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Initialization
    init(titleText: String, strategies: [CopingStrategy]) {
        self.titleText = titleText
        self.strategies = strategies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Terapi"
        
        // Back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        setupScrollView()
        setupHeader()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupHeader() {
        contentView.addSubview(headerView)
        
        // Title
        titleLabel.text = titleText
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        headerView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Başa Çıkma Stratejileri"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        headerView.addSubview(subtitleLabel)
        
        // Summary
        setupSummarySection()
    }
    
    private func setupSummarySection() {
        summaryStackView.axis = .horizontal
        summaryStackView.distribution = .fillEqually
        summaryStackView.spacing = 20
        headerView.addSubview(summaryStackView)
        
        // Strateji sayısı
        let strategyCountView = createSummaryItem(
            icon: "list.bullet",
            text: "\(strategies.count) Strateji"
        )
        summaryStackView.addArrangedSubview(strategyCountView)
        
        // Toplam süre
        let totalDuration = strategies.reduce(0) { $0 + $1.durationInMinutes }
        let durationView = createSummaryItem(
            icon: "clock",
            text: "\(totalDuration) dk Toplam"
        )
        summaryStackView.addArrangedSubview(durationView)
    }
    
    private func createSummaryItem(icon: String, text: String) -> UIView {
        let containerView = UIView()
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .systemGray
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        containerView.addSubview(label)
        
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        return containerView
    }
    
    private func setupCollectionView() {
        contentView.addSubview(strategiesCollectionView)
        strategiesCollectionView.delegate = self
        strategiesCollectionView.dataSource = self
        strategiesCollectionView.register(StrategyCell.self, forCellWithReuseIdentifier: "StrategyCell")
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        summaryStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        strategiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CopingStrategiesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strategies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StrategyCell", for: indexPath) as! StrategyCell
        let strategy = strategies[indexPath.item]
        cell.configure(with: strategy)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CopingStrategiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 52) / 2 // 2 sütun, 16 spacing, 20 padding
        return CGSize(width: width, height: 200)
    }
}

// MARK: - UICollectionViewDelegate
extension CopingStrategiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strategy = strategies[indexPath.item]
        startStrategy(strategy)
    }
    
    private func startStrategy(_ strategy: CopingStrategy) {
        let alert = UIAlertController(title: "Strateji Başlat", message: "\(strategy.title) adımını başlatmak istiyor musunuz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Başlat", style: .default) { _ in
            // Burada strateji detay ekranına gidilebilir
            print("🎯 Strateji başlatıldı: \(strategy.title)")
        })
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - StrategyCell
class StrategyCell: UICollectionViewCell {
    private let containerView = UIView()
    private let playIconView = UIView()
    private let playImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let durationLabel = UILabel()
    private let startButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray6.cgColor
        contentView.addSubview(containerView)
        
        // Play Icon
        playIconView.backgroundColor = .systemBlue
        playIconView.layer.cornerRadius = 20
        containerView.addSubview(playIconView)
        
        playImageView.image = UIImage(systemName: "play.fill")
        playImageView.tintColor = .white
        playImageView.contentMode = .scaleAspectFit
        playIconView.addSubview(playImageView)
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        
        // Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 3
        containerView.addSubview(descriptionLabel)
        
        // Duration
        durationLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        durationLabel.textColor = .systemGray
        containerView.addSubview(durationLabel)
        
        // Start Button
        startButton.setTitle("Başla", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 8
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        containerView.addSubview(startButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        playIconView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        playImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(playIconView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        startButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.height.equalTo(28)
        }
    }
    
    func configure(with strategy: CopingStrategy) {
        titleLabel.text = "\(strategy.title) - Adım \(strategy.stepNumber)"
        descriptionLabel.text = strategy.content
        durationLabel.text = "\(strategy.durationInMinutes) dk"
    }
}
