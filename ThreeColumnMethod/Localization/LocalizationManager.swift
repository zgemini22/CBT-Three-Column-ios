import Foundation
import Combine

/// Resolves the app's active language: either the user's explicit choice or the
/// device's preferred language (falling back to English), mirroring Android's
/// per-app language picker built on `AppCompatDelegate.setApplicationLocales`.
final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    private static let storageKey = "app_language"

    @Published var selectedLanguage: AppLanguage {
        didSet { UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Self.storageKey) }
    }

    private init() {
        if let raw = UserDefaults.standard.string(forKey: Self.storageKey),
           let saved = AppLanguage(rawValue: raw) {
            selectedLanguage = saved
        } else {
            selectedLanguage = .system
        }
    }

    var effectiveLanguage: String {
        switch selectedLanguage {
        case .english: return "en"
        case .chinese: return "zh"
        case .system:
            let preferred = Locale.preferredLanguages.first ?? "en"
            return preferred.hasPrefix("zh") ? "zh" : "en"
        }
    }
}

/// Looks up `key` in the current effective language. Call sites re-evaluate on every
/// view redraw, so observing `LocalizationManager.shared` (e.g. via `@EnvironmentObject`)
/// is enough to make text update live when the user switches languages.
func t(_ key: String) -> String {
    Strings.lookup(key, language: LocalizationManager.shared.effectiveLanguage)
}

func t(_ key: String, _ args: CVarArg...) -> String {
    let format = Strings.lookup(key, language: LocalizationManager.shared.effectiveLanguage)
    return String(format: format, arguments: args)
}
