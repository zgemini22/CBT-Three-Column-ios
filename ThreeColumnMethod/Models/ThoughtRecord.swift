import Foundation
import SwiftData

/// One three-column entry: automatic thought -> cognitive distortion(s) -> rational response.
@Model
final class ThoughtRecord {
    var createdAt: Date
    var situation: String
    var automaticThought: String
    var distortionKeys: [String]
    var rationalResponse: String
    var beliefBefore: Int
    var beliefAfter: Int

    init(
        createdAt: Date = .now,
        situation: String = "",
        automaticThought: String,
        distortionKeys: [String] = [],
        rationalResponse: String,
        beliefBefore: Int,
        beliefAfter: Int
    ) {
        self.createdAt = createdAt
        self.situation = situation
        self.automaticThought = automaticThought
        self.distortionKeys = distortionKeys
        self.rationalResponse = rationalResponse
        self.beliefBefore = beliefBefore
        self.beliefAfter = beliefAfter
    }

    var distortions: [CognitiveDistortion] {
        // A record saved while Mind Reading/Fortune Telling were still split could have both
        // legacy keys stored; resolve() maps both to .mindReading, so dedup to avoid showing it twice.
        var seen = Set<CognitiveDistortion>()
        return distortionKeys
            .compactMap { CognitiveDistortion.resolve(rawValue: $0) }
            .filter { seen.insert($0).inserted }
    }
}
