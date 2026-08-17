import Foundation
import LocalAuthentication
import Combine

/// Owns whether app-lock is turned on, and the app's current locked/unlocked state.
/// Authentication uses `.deviceOwnerAuthentication`, which accepts Face ID, Touch ID, or the
/// device passcode as a fallback — mirroring the Android app's biometric-or-device-credential prompt.
final class AppLockManager: ObservableObject {
    static let shared = AppLockManager()

    private static let storageKey = "app_lock_enabled"

    @Published var lockEnabled: Bool {
        didSet {
            UserDefaults.standard.set(lockEnabled, forKey: Self.storageKey)
            isLocked = lockEnabled
        }
    }

    /// True while the lock screen should be shown and content hidden.
    @Published var isLocked: Bool

    private init() {
        let enabled = UserDefaults.standard.bool(forKey: Self.storageKey)
        lockEnabled = enabled
        isLocked = enabled
    }

    var isAuthenticationAvailable: Bool {
        var error: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }

    /// Locks again after the app was backgrounded, if the user has app-lock turned on.
    func lockIfEnabled() {
        guard lockEnabled else { return }
        isLocked = true
    }

    func requestUnlock() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            // No usable Face ID / Touch ID / passcode enrolled: don't strand the user behind a lock they can't pass.
            isLocked = false
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: t("lock_screen_subtitle")) { [weak self] success, _ in
            guard success else { return }
            DispatchQueue.main.async {
                self?.isLocked = false
            }
        }
    }
}
