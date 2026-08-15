import SwiftUI
import SwiftData

@main
struct ThreeColumnMethodApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: ThoughtRecord.self, JournalEntry.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        seedJournalIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(modelContainer)
    }

    /// Gives the Journal a first, pre-written page on a fresh install, mirroring the
    /// Android app's Room `SeedJournalCallback`.
    private func seedJournalIfNeeded() {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<JournalEntry>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }
        let entry = JournalEntry(body: t("journal_seed_entry_body"))
        context.insert(entry)
        try? context.save()
    }
}
