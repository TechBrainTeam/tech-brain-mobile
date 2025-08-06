import Foundation

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let icon: String
    let title: String
    let subtitle: String
    let action: SettingsAction
}

enum SettingsAction {
    case profile
    case notifications
    case privacy
    case help
    case rate
    case share
    case privacyPolicy
    case version
    case logout
} 
