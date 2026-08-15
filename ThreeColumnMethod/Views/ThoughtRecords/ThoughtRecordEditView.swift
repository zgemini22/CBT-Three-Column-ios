import SwiftUI
import SwiftData

struct ThoughtRecordEditView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    /// nil means "creating a new record"; non-nil means "editing this existing one".
    let record: ThoughtRecord?

    @State private var situation: String = ""
    @State private var automaticThought: String = ""
    @State private var rationalResponse: String = ""
    @State private var beliefBefore: Double = 70
    @State private var beliefAfter: Double = 30
    @State private var selectedDistortions: Set<CognitiveDistortion> = []

    private var canSave: Bool {
        !automaticThought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !rationalResponse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(t("situation_label"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(palette.inkFaded)
                    TextField(t("situation_placeholder"), text: $situation, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                }

                SectionHeader(number: "1", title: t("section_automatic_thought"))
                TextField(t("automatic_thought_placeholder"), text: $automaticThought, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...6)
                BeliefSlider(label: t("belief_before_label"), value: $beliefBefore)

                SectionHeader(number: "2", title: t("section_distortions"))
                Text(t("distortions_hint"))
                    .font(.caption)
                    .foregroundStyle(palette.inkFaded)
                FlowLayout(spacing: 8) {
                    ForEach(CognitiveDistortion.allCases) { distortion in
                        DistortionChip(
                            distortion: distortion,
                            selected: selectedDistortions.contains(distortion)
                        ) {
                            if selectedDistortions.contains(distortion) {
                                selectedDistortions.remove(distortion)
                            } else {
                                selectedDistortions.insert(distortion)
                            }
                        }
                    }
                }
                ForEach(CognitiveDistortion.allCases.filter { selectedDistortions.contains($0) }) { distortion in
                    Text("\(distortion.label): \(distortion.descriptionText)")
                        .font(.caption)
                        .foregroundStyle(palette.inkFaded)
                }

                SectionHeader(number: "3", title: t("section_rational_response"))
                TextField(t("rational_response_placeholder"), text: $rationalResponse, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...6)
                BeliefSlider(label: t("belief_after_label"), value: $beliefAfter)
            }
            .padding(16)
        }
        .background(palette.paper)
        .navigationTitle(record == nil ? t("new_thought_record_title") : t("edit_thought_record_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(t("back_desc")) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Image(systemName: "checkmark")
                }
                .accessibilityLabel(t("save_desc"))
                .disabled(!canSave)
            }
        }
        .onAppear(perform: loadExisting)
    }

    private func loadExisting() {
        guard let record else { return }
        situation = record.situation
        automaticThought = record.automaticThought
        rationalResponse = record.rationalResponse
        beliefBefore = Double(record.beliefBefore)
        beliefAfter = Double(record.beliefAfter)
        selectedDistortions = Set(record.distortions)
    }

    private func save() {
        let trimmedSituation = situation.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedThought = automaticThought.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedResponse = rationalResponse.trimmingCharacters(in: .whitespacesAndNewlines)
        let distortionKeys = selectedDistortions.map(\.rawValue)

        if let record {
            record.situation = trimmedSituation
            record.automaticThought = trimmedThought
            record.rationalResponse = trimmedResponse
            record.beliefBefore = Int(beliefBefore)
            record.beliefAfter = Int(beliefAfter)
            record.distortionKeys = distortionKeys
        } else {
            let newRecord = ThoughtRecord(
                situation: trimmedSituation,
                automaticThought: trimmedThought,
                distortionKeys: distortionKeys,
                rationalResponse: trimmedResponse,
                beliefBefore: Int(beliefBefore),
                beliefAfter: Int(beliefAfter)
            )
            modelContext.insert(newRecord)
        }
        dismiss()
    }
}

private struct SectionHeader: View {
    @Environment(\.notebookPalette) private var palette
    let number: String
    let title: String

    var body: some View {
        Text("\(number). \(title)")
            .font(.headline)
            .foregroundStyle(palette.penBlue)
    }
}

private struct BeliefSlider: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(label) \(Int(value))%")
                .font(.body)
            Slider(value: $value, in: 0...100, step: 5)
        }
    }
}

private struct DistortionChip: View {
    @Environment(\.notebookPalette) private var palette
    let distortion: CognitiveDistortion
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(distortion.label)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selected ? palette.penBlue : palette.paperAlt)
                .foregroundStyle(selected ? palette.onPenBlue : palette.ink)
                .clipShape(Capsule())
                .overlay(Capsule().strokeBorder(palette.inkFaded.opacity(selected ? 0 : 0.4)))
        }
        .buttonStyle(.plain)
    }
}
