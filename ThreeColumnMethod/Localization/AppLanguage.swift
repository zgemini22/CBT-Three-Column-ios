import Foundation

/// Mirrors Android's in-app language picker (System / English / Chinese).
enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case english = "en"
    case chinese = "zh"

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .system: return "language_system_default"
        case .english: return "language_english"
        case .chinese: return "language_chinese"
        }
    }
}
