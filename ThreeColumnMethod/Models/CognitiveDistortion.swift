import Foundation

/// The cognitive distortions popularized by David Burns' "Feeling Good".
/// "Jumping to Conclusions" is split into its two named forms (Mind Reading
/// and Fortune Telling) so they can be chosen separately, matching the book.
/// Label/description text is original paraphrase, not quoted from the book.
enum CognitiveDistortion: String, CaseIterable, Codable, Identifiable, Hashable {
    case allOrNothing = "ALL_OR_NOTHING"
    case overgeneralization = "OVERGENERALIZATION"
    case mentalFilter = "MENTAL_FILTER"
    case discountingPositive = "DISCOUNTING_POSITIVE"
    case mindReading = "MIND_READING"
    case fortuneTelling = "FORTUNE_TELLING"
    case magnificationMinimization = "MAGNIFICATION_MINIMIZATION"
    case emotionalReasoning = "EMOTIONAL_REASONING"
    case shouldStatements = "SHOULD_STATEMENTS"
    case labeling = "LABELING"
    case personalization = "PERSONALIZATION"

    var id: String { rawValue }

    var labelKey: String {
        switch self {
        case .allOrNothing: return "distortion_all_or_nothing_label"
        case .overgeneralization: return "distortion_overgeneralization_label"
        case .mentalFilter: return "distortion_mental_filter_label"
        case .discountingPositive: return "distortion_discounting_positive_label"
        case .mindReading: return "distortion_mind_reading_label"
        case .fortuneTelling: return "distortion_fortune_telling_label"
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
        case .fortuneTelling: return "distortion_fortune_telling_desc"
        case .magnificationMinimization: return "distortion_magnification_minimization_desc"
        case .emotionalReasoning: return "distortion_emotional_reasoning_desc"
        case .shouldStatements: return "distortion_should_statements_desc"
        case .labeling: return "distortion_labeling_desc"
        case .personalization: return "distortion_personalization_desc"
        }
    }

    var label: String { t(labelKey) }
    var descriptionText: String { t(descriptionKey) }
}
