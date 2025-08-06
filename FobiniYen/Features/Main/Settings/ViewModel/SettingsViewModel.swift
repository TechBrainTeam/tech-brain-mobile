import Foundation
import UIKit

protocol SettingsViewModelDelegate: AnyObject {
    func didLogout()
}

class SettingsViewModel {
    weak var coordinator: SettingsCoordinator?
    weak var delegate: SettingsViewModelDelegate?
    
    let settingsSections = [
        SettingsSection(
            title: "Hesap",
            items: [
                SettingsItem(icon: "person.circle", title: "Profil", subtitle: "Kişisel bilgilerinizi düzenleyin", action: .profile),
                SettingsItem(icon: "bell", title: "Bildirimler", subtitle: "Bildirim ayarlarınızı yönetin", action: .notifications),
                SettingsItem(icon: "lock", title: "Gizlilik", subtitle: "Gizlilik ayarlarınızı düzenleyin", action: .privacy)
            ]
        ),
        SettingsSection(
            title: "Uygulama",
            items: [
                SettingsItem(icon: "questionmark.circle", title: "Yardım", subtitle: "Sık sorulan sorular", action: .help),
                SettingsItem(icon: "star", title: "Değerlendir", subtitle: "App Store'da değerlendirin", action: .rate),
                SettingsItem(icon: "square.and.arrow.up", title: "Paylaş", subtitle: "Arkadaşlarınızla paylaşın", action: .share),
                SettingsItem(icon: "doc.text", title: "Gizlilik Politikası", subtitle: "Gizlilik politikamızı okuyun", action: .privacyPolicy)
            ]
        ),
        SettingsSection(
            title: "Hakkında",
            items: [
                SettingsItem(icon: "info.circle", title: "Sürüm", subtitle: "1.0.0", action: .version)
            ]
        ),
        SettingsSection(
            title: "Hesap",
            items: [
                SettingsItem(icon: "rectangle.portrait.and.arrow.right", title: "Çıkış Yap", subtitle: "Hesabınızdan çıkış yapın", action: .logout)
            ]
        )
    ]
    
    func handleAction(_ action: SettingsAction) {
        print("🔄 SettingsViewModel handleAction called: \(action)")
        switch action {
        case .profile:
            showProfileSettings()
        case .notifications:
            showNotificationSettings()
        case .privacy:
            showPrivacySettings()
        case .help:
            showHelp()
        case .rate:
            rateApp()
        case .share:
            shareApp()
        case .privacyPolicy:
            showPrivacyPolicy()
        case .version:
            showVersionInfo()
        case .logout:
            // Logout işlemi ViewController'da yapılıyor
            break
        }
    }
    
    private func showProfileSettings() {
        let alert = UIAlertController(title: "Profil", message: "Profil ayarları yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
    
    private func showNotificationSettings() {
        let alert = UIAlertController(title: "Bildirimler", message: "Bildirim ayarları yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
    
    private func showPrivacySettings() {
        let alert = UIAlertController(title: "Gizlilik", message: "Gizlilik ayarları yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
    
    private func showHelp() {
        let alert = UIAlertController(title: "Yardım", message: "Yardım sayfası yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
    
    private func rateApp() {
        let alert = UIAlertController(title: "Değerlendir", message: "App Store'da değerlendirme yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
    
    private func shareApp() {
        let text = "FobiniYen - Fobilerinizle yüzleşin ve üstesinden gelin!"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        coordinator?.navigationController?.present(activityVC, animated: true)
    }
    
    private func showPrivacyPolicy() {
        let alert = UIAlertController(title: "Gizlilik Politikası", message: "Gizlilik politikası yakında eklenecek", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
    
    private func showVersionInfo() {
        let alert = UIAlertController(title: "Sürüm", message: "FobiniYen v1.0.0", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        coordinator?.navigationController?.present(alert, animated: true)
    }
} 