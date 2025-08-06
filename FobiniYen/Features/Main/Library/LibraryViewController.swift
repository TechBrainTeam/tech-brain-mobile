//
//  LibraryViewController.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 4.08.2025.
//

import UIKit
import SnapKit

class LibraryViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: LibraryViewModel
    weak var coordinator: LibraryCoordinator?
    
    // MARK: - UI Elements
    private let searchBar = UISearchBar()
    private let filterStackView = UIStackView()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initialization
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.loadPhobias()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Eğer navigation stack'te birden fazla view controller varsa, 
        // sadece library view controller'ı bırak
        if let navigationController = navigationController,
           navigationController.viewControllers.count > 1 {
            navigationController.viewControllers = [self]
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Kütüphane"
        
        setupSearchBar()
        setupFilterButtons()
        setupTableView()
        setupActivityIndicator()
        setupConstraints()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Fobilerde ara..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .systemGray6
        searchBar.layer.cornerRadius = 12
        searchBar.tintColor = .systemBlue
        view.addSubview(searchBar)
    }
    
    private func setupFilterButtons() {
        filterStackView.axis = .horizontal
        filterStackView.distribution = .fillEqually
        filterStackView.spacing = 12
        view.addSubview(filterStackView)
        
        let filterTitles = ["Tümü", "Sosyal", "Durumsal", "Hayvan"]
        
        for (index, title) in filterTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.tag = index
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            
            // İlk buton seçili olarak başlasın
            if index == 0 {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
                button.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.label, for: .normal)
                button.layer.borderColor = UIColor.systemGray4.cgColor
            }
            
            filterStackView.addArrangedSubview(button)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhobiaTableViewCell.self, forCellReuseIdentifier: "PhobiaCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemBlue
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped(_ sender: UIButton) {
        // Önceki seçili butonu resetle
        for subview in filterStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.backgroundColor = .clear
                button.setTitleColor(.label, for: .normal)
                button.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
        
        // Seçili butonu highlight et
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        
        // Filtreleme işlemi
        let selectedIndex = sender.tag
        let categories = ["", "Sosyal", "Durumsal", "Hayvan"]
        let selectedCategory = selectedIndex < categories.count ? categories[selectedIndex] : nil
        viewModel.filterByCategory(selectedCategory)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPhobiaCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhobiaCell", for: indexPath) as! PhobiaTableViewCell
        
        if let phobia = viewModel.getPhobia(at: indexPath.row) {
            cell.configure(with: phobia)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let phobia = viewModel.getPhobia(at: indexPath.row) {
            createUserPhobiaAndNavigate(phobia: phobia)
        }
    }
    
    private func createUserPhobiaAndNavigate(phobia: Phobia) {
        // Loading göster
        activityIndicator.startAnimating()
        
        Task {
            do {
                let response = try await PhobiaService.shared.createUserPhobia(phobiaId: phobia.id)
                
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    
                    if response.success {
                        let userPhobiaId = response.data.id
                        coordinator?.showPhobiaDetail(phobia: phobia, userPhobiaId: userPhobiaId)
                    } else {
                        self.showError("Fobi detayı açılamadı")
                    }
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.showError("Fobi detayı açılamadı: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Cell height reduced from 200 to 150
    }
}

// MARK: - UISearchBarDelegate
extension LibraryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchPhobias(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - LibraryViewModelDelegate
extension LibraryViewController: LibraryViewModelDelegate {
    func didLoadPhobias() {
        tableView.reloadData()
    }
    
    func didFailToLoadPhobias(error: Error) {
        showError("Fobiler yüklenirken hata oluştu: \(error)")
    }

    func didStartLoading() {
        activityIndicator.startAnimating()
    }

    func didFinishLoading() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - PhobiaTableViewCell
class PhobiaTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let englishNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryTag = UILabel()
    private let percentageIcon = UIImageView()
    private let percentageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.08
        contentView.addSubview(containerView)
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        
        // English Name
        englishNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        englishNameLabel.textColor = .secondaryLabel
        englishNameLabel.font = UIFont.italicSystemFont(ofSize: 15)
        containerView.addSubview(englishNameLabel)
        
        // Category Tag
        categoryTag.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        categoryTag.textColor = .label
        categoryTag.backgroundColor = .systemGray6
        categoryTag.layer.cornerRadius = 8
        categoryTag.layer.masksToBounds = true
        categoryTag.textAlignment = .center
        containerView.addSubview(categoryTag)
        
        // Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 3
        containerView.addSubview(descriptionLabel)
        
        // Percentage Icon
        percentageIcon.image = UIImage(systemName: "person.2")
        percentageIcon.tintColor = .systemBlue
        percentageIcon.contentMode = .scaleAspectFit
        containerView.addSubview(percentageIcon)
        
        // Percentage Label
        percentageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        percentageLabel.textColor = .systemBlue
        containerView.addSubview(percentageLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(categoryTag.snp.leading).offset(-12)
        }
        
        categoryTag.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
        englishNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
        
        // Yüzdelik değer İngilizce açıklamanın sağında ve kategori etiketinin altında
        percentageIcon.snp.makeConstraints { make in
            make.centerY.equalTo(englishNameLabel)
            make.leading.equalTo(englishNameLabel.snp.trailing).offset(8)
            make.top.greaterThanOrEqualTo(categoryTag.snp.bottom).offset(4)
            make.width.height.equalTo(16)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(englishNameLabel)
            make.leading.equalTo(percentageIcon.snp.trailing).offset(4)
            make.top.greaterThanOrEqualTo(categoryTag.snp.bottom).offset(4)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(englishNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with phobia: Phobia) {
        titleLabel.text = phobia.name
        englishNameLabel.text = phobia.englishName
        
        // Description'ı geri ekle
        descriptionLabel.text = phobia.description
        
        categoryTag.text = phobia.categories.first?.name ?? "Genel"
        
        // Türkçe sayı eki ile yüzde
        let percentage = Int(phobia.percentage)
        percentageLabel.text = "Nüfusun %\(percentage)\(percentage.yuzdelikEki())"
        
        // Category tag rengi
        let categoryName = phobia.categories.first?.name ?? "Genel"
        switch categoryName {
        case "Sosyal":
            categoryTag.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            categoryTag.textColor = .systemBlue
        case "Durumsal":
            categoryTag.backgroundColor = .systemOrange.withAlphaComponent(0.1)
            categoryTag.textColor = .systemOrange
        case "Hayvan":
            categoryTag.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            categoryTag.textColor = .systemGreen
        default:
            categoryTag.backgroundColor = .systemGray6
            categoryTag.textColor = .systemGray
        }
    }
    
    private func getTurkishNumberSuffix(_ number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "i"
        }
        
        switch lastDigit {
        case 1:
            return "i"
        case 2, 3, 4:
            return "ü"
        default:
            return "i"
        }
    }
}
