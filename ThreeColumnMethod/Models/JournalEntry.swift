import Foundation
import SwiftData

/// A dated page in the single-topic journal (see Strings.journalTopic).
/// sortIndex drives manual drag-to-reorder position (higher sorts first);
/// it starts equal to createdAt's timestamp so a fresh page's default order is newest-first.
@Model
final class JournalEntry {
    var createdAt: Date
    var body: String
    var sortIndex: Double

    init(createdAt: Date = .now, body: String, sortIndex: Double? = nil) {
        self.createdAt = createdAt
        self.body = body
        self.sortIndex = sortIndex ?? createdAt.timeIntervalSince1970
    }
}
