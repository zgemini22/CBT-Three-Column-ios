import SwiftUI

/// Lets the user require Face ID / Touch ID / passcode unlock before the app shows any content.
struct PrivacySectionView: View {
    @Environment(\.notebookPalette) private var palette
    @ObservedObject private var lockManager = AppLockManager.shared

    private var biometricAvailable: Bool {
        lockManager.isAuthenticationAvailable
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(t("privacy_section_title"))
                .font(.headline)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(t("privacy_lock_label"))
                        .font(.body)
                    Text(t(biometricAvailable ? "privacy_lock_description" : "privacy_lock_unavailable"))
                        .font(.caption)
                        .foregroundStyle(palette.inkFaded)
                }
                Spacer()
                Toggle("", isOn: Binding(
                    get: { lockManager.lockEnabled && biometricAvailable },
                    set: { lockManager.lockEnabled = $0 }
                ))
                .labelsHidden()
                .disabled(!biometricAvailable)
            }
        }
    }
}
