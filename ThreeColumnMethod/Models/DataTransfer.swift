import Foundation

/// JSON export/import for backup and batch-add. See `parseImport`'s format below —
/// the same shape is shown to the user before they pick an import file.
enum DataTransfer {
    private static let keyThoughtRecords = "thoughtRecords"
    private static let keyJournalEntries = "journalEntries"

    struct ImportError: LocalizedError {
        let message: String
        var errorDescription: String? { message }
    }

    struct ImportResult {
        let thoughtRecords: [ThoughtRecord]
        let journalEntries: [JournalEntry]
    }

    static func export(thoughtRecords: [ThoughtRecord], journalEntries: [JournalEntry]) -> String {
        var recordsArray: [[String: Any]] = []
        for record in thoughtRecords {
            recordsArray.append([
                "createdAt": Int64(record.createdAt.timeIntervalSince1970 * 1000),
                "situation": record.situation,
                "automaticThought": record.automaticThought,
                "distortions": record.distortionKeys,
                "rationalResponse": record.rationalResponse,
                "beliefBefore": record.beliefBefore,
                "beliefAfter": record.beliefAfter
            ])
        }

        var entriesArray: [[String: Any]] = []
        for entry in journalEntries {
            entriesArray.append([
                "createdAt": Int64(entry.createdAt.timeIntervalSince1970 * 1000),
                "body": entry.body
            ])
        }

        let root: [String: Any] = [
            keyThoughtRecords: recordsArray,
            keyJournalEntries: entriesArray
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: root, options: [.prettyPrinted, .sortedKeys]),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }

    static func parseImport(_ json: String) throws -> ImportResult {
        guard let data = json.data(using: .utf8),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ImportError(message: "Not valid JSON.")
        }

        var records: [ThoughtRecord] = []
        if let array = root[keyThoughtRecords] as? [[String: Any]] {
            for obj in array {
                guard let automaticThought = obj["automaticThought"] as? String, !automaticThought.isEmpty else { continue }
                let situation = obj["situation"] as? String ?? ""
                let rationalResponse = obj["rationalResponse"] as? String ?? ""
                let beliefBefore = (obj["beliefBefore"] as? Int) ?? 0
                let beliefAfter = (obj["beliefAfter"] as? Int) ?? 0
                let distortionCodes = obj["distortions"] as? [String] ?? []
                var seenDistortions = Set<CognitiveDistortion>()
                let distortions = distortionCodes
                    .compactMap { CognitiveDistortion.resolve(rawValue: $0) }
                    .filter { seenDistortions.insert($0).inserted }
                let createdAt: Date
                if let millis = obj["createdAt"] as? Int64 {
                    createdAt = Date(timeIntervalSince1970: Double(millis) / 1000)
                } else if let millisNumber = obj["createdAt"] as? NSNumber {
                    createdAt = Date(timeIntervalSince1970: millisNumber.doubleValue / 1000)
                } else {
                    createdAt = .now
                }
                records.append(ThoughtRecord(
                    createdAt: createdAt,
                    situation: situation,
                    automaticThought: automaticThought,
                    distortionKeys: distortions.map { $0.rawValue },
                    rationalResponse: rationalResponse,
                    beliefBefore: beliefBefore,
                    beliefAfter: beliefAfter
                ))
            }
        }

        var entries: [JournalEntry] = []
        if let array = root[keyJournalEntries] as? [[String: Any]] {
            for obj in array {
                guard let body = obj["body"] as? String, !body.isEmpty else { continue }
                let createdAt: Date
                if let millis = obj["createdAt"] as? Int64 {
                    createdAt = Date(timeIntervalSince1970: Double(millis) / 1000)
                } else if let millisNumber = obj["createdAt"] as? NSNumber {
                    createdAt = Date(timeIntervalSince1970: millisNumber.doubleValue / 1000)
                } else {
                    createdAt = .now
                }
                entries.append(JournalEntry(createdAt: createdAt, body: body))
            }
        }

        if records.isEmpty && entries.isEmpty {
            throw ImportError(message: "No usable records found in this file.")
        }

        return ImportResult(thoughtRecords: records, journalEntries: entries)
    }
}
