import SwiftUI

struct RootView: View {
    @Environment(\.colorScheme) private var systemColorScheme
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared

    private var effectiveColorScheme: ColorScheme {
        themeManager.preferredColorScheme ?? systemColorScheme
    }

    private var palette: NotebookPalette {
        NotebookPalette.forScheme(effectiveColorScheme)
    }

    var body: some View {
        TabView {
            NavigationStack {
                ThoughtRecordListView()
                    .toolbar { aboutToolbarItem }
            }
            .tabItem {
                Label(t("nav_thought_records"), systemImage: "brain.head.profile")
            }

            NavigationStack {
                JournalListView()
                    .toolbar { aboutToolbarItem }
            }
            .tabItem {
                Label(t("nav_journal"), systemImage: "book.closed")
            }
        }
        .environment(\.notebookPalette, palette)
        .tint(palette.penBlue)
        .preferredColorScheme(themeManager.preferredColorScheme)
    }

    @ToolbarContentBuilder
    private var aboutToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                AboutView()
            } label: {
                Image(systemName: "info.circle")
            }
            .accessibilityLabel(t("about_desc"))
        }
    }
}
