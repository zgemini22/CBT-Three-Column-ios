import SwiftUI

/// Lets the user pin the app's light/dark appearance, or leave it following the system setting.
struct ThemePickerView: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(t("theme_section_title"))
                .font(.headline)
            ForEach(AppTheme.allCases) { theme in
                SelectableOptionRow(
                    label: t(theme.titleKey),
                    selected: themeManager.selectedTheme == theme
                ) {
                    themeManager.selectedTheme = theme
                }
            }
        }
    }
}
