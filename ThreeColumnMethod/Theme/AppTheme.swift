import Foundation

/// Mirrors Android's theme picker (System / Light / Dark), persisted the same way
/// as the language choice.
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .system: return "theme_system_default"
        case .light: return "theme_light"
        case .dark: return "theme_dark"
        }
    }
}
