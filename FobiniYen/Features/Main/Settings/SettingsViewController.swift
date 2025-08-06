import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - ViewModel
    var viewModel: SettingsViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Ayarlar"
        
        // Navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Kapat",
            style: .plain,
            target: self,
            action: #selector(dismissTapped)
        )
        
        // Table view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.backgroundColor = .clear
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        let item = viewModel.settingsSections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.settingsSections[section].title
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.settingsSections[indexPath.section].items[indexPath.row]
        print("🎯 Settings item tapped: \(item.title) - Action: \(item.action)")
        
        // Logout işlemini direkt ViewController'da yap
        if item.action == .logout {
            showLogoutConfirmation()
        } else {
            viewModel.handleAction(item.action)
        }
    }
    
    // MARK: - UI Actions
    func showLogoutConfirmation() {
        print("🚨 SettingsViewController showLogoutConfirmation called")
        let alert = UIAlertController(
            title: "Çıkış Yap",
            message: "Hesabınızdan çıkış yapmak istediğinizden emin misiniz?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive) { _ in
            print("🚨 User confirmed logout")
            self.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        print("🚨 performLogout called")
        // AuthService'den çıkış yap
        AuthService.shared.logout()
        print("✅ AuthService logout completed")
        
        // Settings'i kapat
        dismiss(animated: true) {
            print("🚨 Settings dismissed, showing login screen")
            // Ana ekrana dön ve giriş ekranını göster
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                window.rootViewController = navController
                window.makeKeyAndVisible()
                print("✅ Login screen shown")
            }
        }
    }
}

// MARK: - Settings Table View Cell
class SettingsTableViewCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        contentView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        contentView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        contentView.addSubview(subtitleLabel)
        
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray3
        contentView.addSubview(chevronImageView)
        
        // Constraints
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
    
    func configure(with item: SettingsItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
} 
