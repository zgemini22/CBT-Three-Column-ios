import SwiftUI

struct RootView: View {
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @ObservedObject private var lockManager = AppLockManager.shared

    private var effectiveColorScheme: ColorScheme {
        themeManager.preferredColorScheme ?? systemColorScheme
    }

    private var palette: NotebookPalette {
        NotebookPalette.forScheme(effectiveColorScheme)
    }

    /// True the instant the app resigns active (covers the app-switcher snapshot, mirroring the
    /// Android app's FLAG_SECURE) as well as while it's actually locked pending unlock.
    private var showsLockCurtain: Bool {
        lockManager.lockEnabled && (scenePhase != .active || lockManager.isLocked)
    }

    var body: some View {
        ZStack {
            mainTabView
            if showsLockCurtain {
                LockScreenView(showsUnlockButton: lockManager.isLocked, onUnlockRequested: lockManager.requestUnlock)
            }
        }
        .environment(\.notebookPalette, palette)
        .tint(palette.penBlue)
        .preferredColorScheme(themeManager.preferredColorScheme)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                lockManager.lockIfEnabled()
            }
        }
    }

    private var mainTabView: some View {
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
