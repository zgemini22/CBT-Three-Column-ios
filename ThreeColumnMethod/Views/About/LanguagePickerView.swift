import SwiftUI

/// Lets the user override the app's display language, independent of the device's system language.
struct LanguagePickerView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(t("language_section_title"))
                .font(.headline)
            ForEach(AppLanguage.allCases) { language in
                SelectableOptionRow(
                    label: t(language.titleKey),
                    selected: localizationManager.selectedLanguage == language
                ) {
                    localizationManager.selectedLanguage = language
                }
            }
        }
    }
}
