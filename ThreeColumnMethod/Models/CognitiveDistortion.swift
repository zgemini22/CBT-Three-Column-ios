import Foundation

/// The cognitive distortions popularized by David Burns' "Feeling Good".
/// Label/description text is original paraphrase, not quoted from the book.
///
/// Mind Reading and Fortune Telling were briefly split into separate cases; they're merged
/// back into a single "Jumping to Conclusions" case (still named `mindReading` for storage
/// continuity). Records saved while they were split may still have a lone "FORTUNE_TELLING"
/// key on disk, so `resolve(rawValue:)` keeps mapping that string to `.mindReading`.
enum CognitiveDistortion: String, CaseIterable, Codable, Identifiable, Hashable {
    case allOrNothing = "ALL_OR_NOTHING"
    case overgeneralization = "OVERGENERALIZATION"
    case mentalFilter = "MENTAL_FILTER"
    case discountingPositive = "DISCOUNTING_POSITIVE"
    case mindReading = "MIND_READING"
    case magnificationMinimization = "MAGNIFICATION_MINIMIZATION"
    case emotionalReasoning = "EMOTIONAL_REASONING"
    case shouldStatements = "SHOULD_STATEMENTS"
    case labeling = "LABELING"
    case personalization = "PERSONALIZATION"

    var id: String { rawValue }

    private static let legacyFortuneTellingKey = "FORTUNE_TELLING"

    /// Use this instead of `init(rawValue:)` when resolving a stored key, so the retired
    /// "FORTUNE_TELLING" key keeps resolving to `.mindReading` instead of silently vanishing.
    static func resolve(rawValue: String) -> CognitiveDistortion? {
        rawValue == legacyFortuneTellingKey ? .mindReading : CognitiveDistortion(rawValue: rawValue)
    }

    var labelKey: String {
        switch self {
        case .allOrNothing: return "distortion_all_or_nothing_label"
        case .overgeneralization: return "distortion_overgeneralization_label"
        case .mentalFilter: return "distortion_mental_filter_label"
        case .discountingPositive: return "distortion_discounting_positive_label"
        case .mindReading: return "distortion_mind_reading_label"
        case .magnificationMinimization: return "distortion_magnification_minimization_label"
        case .emotionalReasoning: return "distortion_emotional_reasoning_label"
        case .shouldStatements: return "distortion_should_statements_label"
        case .labeling: return "distortion_labeling_label"
        case .personalization: return "distortion_personalization_label"
        }
    }

    var descriptionKey: String {
        switch self {
        case .allOrNothing: return "distortion_all_or_nothing_desc"
        case .overgeneralization: return "distortion_overgeneralization_desc"
        case .mentalFilter: return "distortion_mental_filter_desc"
        case .discountingPositive: return "distortion_discounting_positive_desc"
        case .mindReading: return "distortion_mind_reading_desc"
        case .magnificationMinimization: return "distortion_magnification_minimization_desc"
        case .emotionalReasoning: return "distortion_emotional_reasoning_desc"
        case .shouldStatements: return "distortion_should_statements_desc"
        case .labeling: return "distortion_labeling_desc"
        case .personalization: return "distortion_personalization_desc"
        }
    }

    var label: String { t(labelKey) }
    var descriptionText: String { t(descriptionKey) }

    /// This distortion's fixed position (1-10) in the list, e.g. "5. Jumping to Conclusions" —
    /// mirroring how "Feeling Good" itself presents the distortions as a numbered list.
    var number: Int { Self.allCases.firstIndex(of: self)! + 1 }
    var numberedLabel: String { "\(number). \(label)" }
}
