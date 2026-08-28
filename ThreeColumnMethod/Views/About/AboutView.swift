import SwiftUI

struct AboutView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(t("about_technique_heading"))
                    .font(.headline)
                Text(t("about_technique_body"))
                    .font(.body)

                Text(t("about_journal_heading"))
                    .font(.headline)
                Text(t("about_journal_body", t("journal_topic")))
                    .font(.body)

                ThemePickerView()
                LanguagePickerView()
                PrivacySectionView()
                DataTransferSectionView()

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(t("about_author_label")): \(t("author_name"))")
                        .font(.caption)
                        .foregroundStyle(palette.inkFaded)
                    Button {
                        if let url = URL(string: t("license_url")) {
                            openURL(url)
                        }
                    } label: {
                        Text(t("about_license_label"))
                            .font(.caption)
                            .foregroundStyle(palette.penBlue)
                            .underline()
                    }
                    .buttonStyle(.plain)
                }

                Text(t("about_disclaimer"))
                    .font(.caption)
                    .foregroundStyle(palette.inkFaded)
            }
            .padding(16)
        }
        .background(palette.paper)
        .navigationTitle(t("about_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
