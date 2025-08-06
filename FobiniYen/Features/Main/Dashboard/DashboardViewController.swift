//
//  DashboardViewController.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 4.08.2025.
//

import UIKit
import SnapKit
import SwiftUI
import SwiftUI

final class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private let therapyService = TherapyService.shared
    private var userPhobias: [UserPhobiaListItem] = []
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerView = UIView()
    private let profileImageView = UIView()
    private let profileInitialLabel = UILabel()
    private let greetingLabel = UILabel()
    private let usernameLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    
    // Question Section
    private let questionLabel = UILabel()
    
    // Daily Control Card
    private let dailyControlCard = UIView()
    private let dailyControlTitleLabel = UILabel()
    private let dailyControlDateLabel = UILabel()
    private let dailyControlQuestionLabel = UILabel()
    private let moodStackView = UIStackView()
    private let continueSeriesButton = UIButton(type: .system)
    
    // Quick Access Section
    private let quickAccessTitleLabel = UILabel()
    private let quickAccessStackView = UIStackView()
    
    // Quote Section
    private let quoteContainerView = UIView()
    private let quoteEmojiLabel = UILabel()
    private let quoteTextLabel = UILabel()
    private let quoteAuthorLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
        updateDailyControlStreak()
        loadUserPhobias()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupScrollView()
        setupHeader()
        setupQuestionSection()
        setupDailyControlCard()
        setupQuickAccessSection()
        setupQuoteSection()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupHeader() {
        contentView.addSubview(headerView)
        
        // Profile Image
        profileImageView.backgroundColor = UIColor.black
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        headerView.addSubview(profileImageView)
        
        // Profile Initial Label
        profileInitialLabel.text = "U"
        profileInitialLabel.textColor = .white
        profileInitialLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        profileInitialLabel.textAlignment = .center
        profileImageView.addSubview(profileInitialLabel)
        
        // Greeting
        greetingLabel.text = "İyi günler!"
        greetingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        greetingLabel.textColor = UIColor.label
        headerView.addSubview(greetingLabel)
        
        // Username
        usernameLabel.text = "s"
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        usernameLabel.textColor = UIColor.secondaryLabel
        headerView.addSubview(usernameLabel)
        
        // Settings Button
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = UIColor.label
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        headerView.addSubview(settingsButton)
        
        // Profile Initial Label Constraints
        profileInitialLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupQuestionSection() {
        questionLabel.text = "Korkularınıza yüzleşmeye hazır mısınız?"
        questionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        questionLabel.textColor = UIColor.secondaryLabel
        questionLabel.numberOfLines = 0
        contentView.addSubview(questionLabel)
    }
    
    private func setupDailyControlCard() {
        dailyControlCard.backgroundColor = UIColor.systemGray6
        dailyControlCard.layer.cornerRadius = 20
        dailyControlCard.layer.shadowColor = UIColor.black.cgColor
        dailyControlCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        dailyControlCard.layer.shadowRadius = 12
        dailyControlCard.layer.shadowOpacity = 0.15
        contentView.addSubview(dailyControlCard)
        
        // Title and Date
        dailyControlTitleLabel.text = "Günlük Kontrol"
        dailyControlTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        dailyControlTitleLabel.textColor = UIColor.label
        dailyControlCard.addSubview(dailyControlTitleLabel)
        
        // Nefes serisini kullan
        let breathingStreak = BreathingProgressManager.shared.getCurrentStreak()
        dailyControlDateLabel.text = "\(breathingStreak). Gün"
        dailyControlDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dailyControlDateLabel.textColor = UIColor.secondaryLabel
        dailyControlCard.addSubview(dailyControlDateLabel)
        
        // Question
        dailyControlQuestionLabel.text = "Bugün nasıl hissediyorsunuz?"
        dailyControlQuestionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dailyControlQuestionLabel.textColor = UIColor.label
        dailyControlCard.addSubview(dailyControlQuestionLabel)
        
        // Mood Emojis
        setupMoodEmojis()
        
        // Continue Button
        continueSeriesButton.setTitle("Seriyi Devam Ettir", for: .normal)
        continueSeriesButton.setTitleColor(.white, for: .normal)
        continueSeriesButton.backgroundColor = UIColor.black
        continueSeriesButton.layer.cornerRadius = 12
        continueSeriesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        continueSeriesButton.addTarget(self, action: #selector(continueSeriesButtonTapped), for: .touchUpInside)
        dailyControlCard.addSubview(continueSeriesButton)
    }
    
    private func setupMoodEmojis() {
        moodStackView.axis = .horizontal
        moodStackView.distribution = .fillEqually
        moodStackView.spacing = 12
        dailyControlCard.addSubview(moodStackView)
        
        let emojis = ["😊", "😐", "😟", "😰", "😨"]
        
        for (index, emoji) in emojis.enumerated() {
            let moodButton = UIButton(type: .system)
            moodButton.setTitle(emoji, for: .normal)
            moodButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            moodButton.backgroundColor = UIColor.white
            moodButton.layer.cornerRadius = 35
            moodButton.layer.shadowColor = UIColor.black.cgColor
            moodButton.layer.shadowOffset = CGSize(width: 0, height: 3)
            moodButton.layer.shadowRadius = 6
            moodButton.layer.shadowOpacity = 0.15
            moodButton.layer.borderWidth = 1
            moodButton.layer.borderColor = UIColor.systemGray5.cgColor
            moodButton.tag = index
            
            // Add tap action
            moodButton.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
            
            moodButton.snp.makeConstraints { make in
                make.width.height.equalTo(70)
            }
            
            moodStackView.addArrangedSubview(moodButton)
        }
    }
    
    private func setupQuickAccessSection() {
        quickAccessTitleLabel.text = "Hızlı Erişim"
        quickAccessTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        quickAccessTitleLabel.textColor = UIColor.label
        contentView.addSubview(quickAccessTitleLabel)
        
        quickAccessStackView.axis = .vertical
        quickAccessStackView.spacing = 16
        contentView.addSubview(quickAccessStackView)
        
        // Quick Access Items
        let quickAccessItems = [
            QuickAccessItem(
                icon: "💙",
                title: "Nefes Egzersizi Başlat",
                subtitle: "5 dakikalık sakinlik seansı",
                iconColor: UIColor.systemBlue,
                action: { [weak self] in self?.openBreathingExercise() }
            ),
            QuickAccessItem(
                icon: "🛡️", 
                title: "Terapi Seansına Devam Et",
                subtitle: "Seviye 2 - Toplum Önünde Konuşma",
                iconColor: UIColor.systemGreen,
                action: { [weak self] in self?.continueTherapy() }
            ),
            QuickAccessItem(
                icon: "⭐",
                title: "Fobileri Keşfet", 
                subtitle: "Yaygın korkular hakkında öğren",
                iconColor: UIColor.systemPurple,
                action: { [weak self] in self?.explorePhobias() }
            )
        ]
        
        for item in quickAccessItems {
            let itemView = createQuickAccessItemView(item: item)
            quickAccessStackView.addArrangedSubview(itemView)
        }
    }
    
    private func createQuickAccessItemView(item: QuickAccessItem) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 18
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray6.cgColor
        
        // İkon background view
        let iconBackgroundView = UIView()
        iconBackgroundView.backgroundColor = item.iconColor
        iconBackgroundView.layer.cornerRadius = 20
        containerView.addSubview(iconBackgroundView)
        
        let iconLabel = UILabel()
        iconLabel.text = item.icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
        iconBackgroundView.addSubview(iconLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor.label
        containerView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor.secondaryLabel
        containerView.addSubview(subtitleLabel)
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = UIColor.systemGray
        containerView.addSubview(arrowImageView)
        
        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quickAccessItemTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = quickAccessStackView.arrangedSubviews.count
        
        // Constraints
        iconBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconBackgroundView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(16)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-12)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(80)
        }
        
        return containerView
    }
    
    private func setupQuoteSection() {
        quoteContainerView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        quoteContainerView.layer.cornerRadius = 16
        quoteContainerView.layer.borderWidth = 1
        quoteContainerView.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.2).cgColor
        contentView.addSubview(quoteContainerView)
        
        // Emoji
        quoteEmojiLabel.text = "💪"
        quoteEmojiLabel.font = UIFont.systemFont(ofSize: 32)
        quoteEmojiLabel.textAlignment = .center
        quoteContainerView.addSubview(quoteEmojiLabel)
        
        // Quote Text
        quoteTextLabel.text = "\"Cesaret, korkunun yokluğu değil, korkuya rağmen harekete geçmektir.\""
        quoteTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        quoteTextLabel.textColor = UIColor.label
        quoteTextLabel.textAlignment = .center
        quoteTextLabel.numberOfLines = 0
        quoteContainerView.addSubview(quoteTextLabel)
        
        // Author
        quoteAuthorLabel.text = "- Nelson Mandela"
        quoteAuthorLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        quoteAuthorLabel.textColor = UIColor.secondaryLabel
        quoteAuthorLabel.textAlignment = .center
        quoteContainerView.addSubview(quoteAuthorLabel)
        
        // Constraints
        quoteEmojiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        quoteTextLabel.snp.makeConstraints { make in
            make.top.equalTo(quoteEmojiLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        quoteAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(quoteTextLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
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
            make.height.equalTo(80)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(profileImageView.snp.top).offset(4)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(greetingLabel)
            make.top.equalTo(greetingLabel.snp.bottom).offset(2)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dailyControlCard.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dailyControlTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
        }
        
        dailyControlDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalTo(dailyControlTitleLabel)
        }
        
        dailyControlQuestionLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyControlTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        moodStackView.snp.makeConstraints { make in
            make.top.equalTo(dailyControlQuestionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        continueSeriesButton.snp.makeConstraints { make in
            make.top.equalTo(moodStackView.snp.bottom).offset(28)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        quickAccessTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyControlCard.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        quickAccessStackView.snp.makeConstraints { make in
            make.top.equalTo(quickAccessTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        quoteContainerView.snp.makeConstraints { make in
            make.top.equalTo(quickAccessStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func loadUserData() {
        // AuthService'den user bilgilerini al
        if let user = AuthService.shared.getCurrentUser() {
            // Dinamik selamlama
            let hour = Calendar.current.component(.hour, from: Date())
            let greeting: String
            switch hour {
            case 5..<12:
                greeting = "Günaydın \(user.firstName)!"
            case 12..<17:
                greeting = "İyi günler \(user.firstName)!"
            case 17..<22:
                greeting = "İyi akşamlar \(user.firstName)!"
            default:
                greeting = "İyi geceler \(user.firstName)!"
            }
            greetingLabel.text = greeting
            
            // Kullanıcının tam adını göster
            usernameLabel.text = "\(user.firstName) \(user.lastName)"
            
            // Profile image'da kullanıcının adının ilk harfini göster
            profileInitialLabel.text = String(user.firstName.prefix(1)).uppercased()
            
            // Profile image setup
            if let profileImage = user.profileImage, !profileImage.isEmpty {
                // Profile image yükleme logic'i eklenebilir
            }
        } else {
            // Fallback - eğer user data yok ise
            greetingLabel.text = "İyi günler!"
            usernameLabel.text = "Kullanıcı"
            profileInitialLabel.text = "U"
        }
    }
    

    
    // MARK: - Actions
    @objc private func quickAccessItemTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        
        switch tag {
        case 0: openBreathingExercise()
        case 1: continueTherapy()
        case 2: explorePhobias()
        default: break
        }
    }
    
    @objc private func moodButtonTapped(_ sender: UIButton) {
        // Önceki seçili mood'u resetle
        for subview in moodStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.backgroundColor = UIColor.white
                button.layer.borderColor = UIColor.systemGray5.cgColor
            }
        }
        
        // Seçili mood'u highlight et
        sender.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        
        let selectedMood = sender.tag
        UserDefaults.standard.set(selectedMood, forKey: "selectedMood")
        
        print("😊 Mood seçildi: \(selectedMood)")
    }
    
    @objc private func continueSeriesButtonTapped() {
        // Günlük kontrol tamamlandı mı kontrol et
        if BreathingProgressManager.shared.hasCompletedDailyCheckToday() {
            // Zaten bugün tamamlanmışsa alert göster
            let alert = UIAlertController(
                title: "Günlük Kontrol",
                message: "Bugünkü günlük kontrolünüz zaten tamamlandı. Yarın tekrar kontrol edebilirsiniz.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Günlük kontrolü tamamla
        BreathingProgressManager.shared.completeDailyCheck()
        
        // UI'ı güncelle
        updateDailyControlStreak()
        
        // Başarı mesajı göster
        let alert = UIAlertController(
            title: "Harika! 🎉",
            message: "Günlük kontrolünüz tamamlandı. Serinizi devam ettiriyorsunuz!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController!)
        settingsCoordinator.delegate = tabBarController as? SettingsCoordinatorDelegate
        settingsCoordinator.start()
    }
    
    private func openBreathingExercise() {
        tabBarController?.selectedIndex = 3 // Nefes tab'ına git
    }
    
    private func continueTherapy() {
        tabBarController?.selectedIndex = 2 // Terapi tab'ına git
    }
    
    private func explorePhobias() {
        tabBarController?.selectedIndex = 1 // Kütüphane tab'ına git
    }
    
    private func updateDailyControlStreak() {
        let breathingStreak = BreathingProgressManager.shared.getCurrentStreak()
        dailyControlDateLabel.text = "\(breathingStreak). Gün"
        
        // Günlük kontrol durumunu kontrol et
        let hasCompletedToday = BreathingProgressManager.shared.hasCompletedDailyCheckToday()
        continueSeriesButton.isEnabled = !hasCompletedToday
        
        if hasCompletedToday {
            continueSeriesButton.setTitle("Bugün Tamamlandı ✓", for: .normal)
            continueSeriesButton.backgroundColor = UIColor.systemGreen
        } else {
            continueSeriesButton.setTitle("Seriyi Devam Ettir", for: .normal)
            continueSeriesButton.backgroundColor = UIColor.black
        }
    }
    
    private func loadUserPhobias() {
        Task {
            do {
                let userPhobias = try await therapyService.getUserPhobias()
                await MainActor.run {
                    self.userPhobias = userPhobias
                    print("✅ Loaded \(userPhobias.count) user phobias")
                }
            } catch {
                print("❌ Failed to load user phobias: \(error)")
            }
        }
    }
}

// MARK: - Models
private struct QuickAccessItem {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: UIColor
    let action: () -> Void
}
