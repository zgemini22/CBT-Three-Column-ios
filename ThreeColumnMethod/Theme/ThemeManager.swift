import SwiftUI
import Combine

/// Owns the user's theme choice and exposes the `ColorScheme?` to feed into
/// `.preferredColorScheme()` (nil lets the app follow the system).
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    private static let storageKey = "app_theme"

    @Published var selectedTheme: AppTheme {
        didSet { UserDefaults.standard.set(selectedTheme.rawValue, forKey: Self.storageKey) }
    }

    private init() {
        if let raw = UserDefaults.standard.string(forKey: Self.storageKey),
           let saved = AppTheme(rawValue: raw) {
            selectedTheme = saved
        } else {
            selectedTheme = .system
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch selectedTheme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
