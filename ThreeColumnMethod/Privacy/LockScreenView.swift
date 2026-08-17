import SwiftUI

/// Shown instead of the app's content whenever it's locked, or the app has resigned active
/// (covering the app-switcher snapshot the instant a privacy-lock user backgrounds the app).
struct LockScreenView: View {
    @Environment(\.notebookPalette) private var palette
    let showsUnlockButton: Bool
    let onUnlockRequested: () -> Void

    var body: some View {
        ZStack {
            palette.paper.ignoresSafeArea()

            if showsUnlockButton {
                VStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(palette.inkFaded)
                    Text(t("lock_screen_title"))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(palette.ink)
                        .padding(.top, 12)
                    Text(t("lock_screen_subtitle"))
                        .font(.body)
                        .foregroundStyle(palette.inkFaded)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                    Button(t("lock_screen_unlock_button"), action: onUnlockRequested)
                        .padding(.top, 20)
                }
                .padding(32)
                .onAppear(perform: onUnlockRequested)
            }
        }
    }
}
