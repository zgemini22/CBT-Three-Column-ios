import SwiftUI
import SwiftData

struct ThoughtRecordEditView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// nil means "creating a new record"; non-nil means "editing this existing one".
    let record: ThoughtRecord?

    @State private var situation: String = ""
    @State private var automaticThought: String = ""
    @State private var rationalResponse: String = ""
    @State private var beliefBefore: Double = 70
    @State private var beliefAfter: Double = 30
    @State private var selectedDistortions: Set<CognitiveDistortion> = []
    @State private var currentPage = 0
    @State private var summaryExpanded = false

    private var canSave: Bool {
        !automaticThought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !rationalResponse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Three side-by-side columns only make sense with room to breathe (iPad, or an iPhone in
    /// landscape with a Plus/Pro Max-class width); otherwise switch to three swipeable/tappable
    /// pages so text fields aren't squeezed too narrow to use.
    private var isWideScreen: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        Group {
            if isWideScreen {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if summaryExpanded {
                            summaryCard
                        }
                        HStack(alignment: .top, spacing: 16) {
                            automaticThoughtColumn.frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                            distortionsColumn.frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                            rationalResponseColumn.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(16)
                }
            } else {
                VStack(spacing: 0) {
                    if summaryExpanded {
                        summaryCard
                            .padding(16)
                    }
                    PageTabRow(pageCount: 3, currentPage: $currentPage)
                        .padding(.horizontal, 8)
                    Divider()
                    TabView(selection: $currentPage) {
                        ScrollView { automaticThoughtColumn.padding(16) }.tag(0)
                        ScrollView { distortionsColumn.padding(16) }.tag(1)
                        ScrollView { rationalResponseColumn.padding(16) }.tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }
        .background(palette.paper)
        .navigationTitle(record == nil ? t("new_thought_record_title") : t("edit_thought_record_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(t("back_desc")) { dismiss() }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation { summaryExpanded.toggle() }
                } label: {
                    Image(systemName: "info.circle")
                }
                .accessibilityLabel(t(summaryExpanded ? "summary_hide" : "summary_show"))
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

    /// Situation, the three section titles, and the before/after belief sliders once, in one place.
    /// Shown only when toggled on via the info icon in the toolbar.
    @ViewBuilder
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(t("situation_label"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(palette.inkFaded)
                TextField(t("situation_placeholder"), text: $situation, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
            }
            Divider()
            Text("1. \(t("section_automatic_thought"))")
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
            Text("2. \(t("section_distortions"))")
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
            Text("3. \(t("section_rational_response"))")
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
            BeliefSlider(label: t("belief_before_label"), value: $beliefBefore)
            BeliefSlider(label: t("belief_after_label"), value: $beliefAfter)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(palette.paperAlt)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var automaticThoughtColumn: some View {
        TextField("", text: $automaticThought, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(2...6)
            .accessibilityLabel(t("section_automatic_thought"))
    }

    @ViewBuilder
    private var distortionsColumn: some View {
        VStack(alignment: .leading, spacing: 8) {
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
        }
    }

    @ViewBuilder
    private var rationalResponseColumn: some View {
        TextField("", text: $rationalResponse, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(2...6)
            .accessibilityLabel(t("section_rational_response"))
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
