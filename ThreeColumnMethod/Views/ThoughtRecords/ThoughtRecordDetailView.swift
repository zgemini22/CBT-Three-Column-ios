import SwiftUI
import SwiftData

struct ThoughtRecordDetailView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var record: ThoughtRecord

    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !record.situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(t("situation_display_label"))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(palette.penBlue)
                        Text(record.situation)
                            .font(.body)
                            .italic()
                        Divider()
                            .padding(.top, 12)
                    }
                }

                DetailSection(number: "1", title: t("section_automatic_thought")) {
                    Text(record.automaticThought)
                        .font(.body)
                    Text(t("belief_before_display", record.beliefBefore))
                        .font(.caption)
                        .foregroundStyle(palette.inkFaded)
                        .padding(.top, 4)
                }

                Divider()

                DetailSection(number: "2", title: t("section_distortions")) {
                    if record.distortions.isEmpty {
                        Text(t("distortions_none_selected"))
                            .font(.body)
                            .foregroundStyle(palette.inkFaded)
                    } else {
                        Text(record.distortions.map(\.label).joined(separator: " · "))
                            .font(.body)
                    }
                }

                Divider()

                DetailSection(number: "3", title: t("section_rational_response")) {
                    Text(record.rationalResponse)
                        .font(.body)
                    Text(t("belief_after_display", record.beliefAfter))
                        .font(.caption)
                        .foregroundStyle(palette.inkFaded)
                        .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .background(palette.paper)
        .navigationTitle(record.createdAt.formatted(date: .abbreviated, time: .shortened))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel(t("share_desc"))

                Button(role: .destructive) {
                    modelContext.delete(record)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel(t("delete_desc"))

                Button {
                    showingEdit = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel(t("edit_desc"))
            }
        }
        .sheet(isPresented: $showingEdit) {
            NavigationStack {
                ThoughtRecordEditView(record: record)
            }
        }
    }

    private var shareText: String {
        var lines: [String] = []
        let situation = record.situation.trimmingCharacters(in: .whitespacesAndNewlines)
        if !situation.isEmpty {
            lines.append("\(t("situation_display_label")): \(situation)")
            lines.append("")
        }
        lines.append("1. \(t("section_automatic_thought"))")
        lines.append(record.automaticThought)
        lines.append(t("belief_before_display", record.beliefBefore))
        lines.append("")
        lines.append("2. \(t("section_distortions"))")
        lines.append(record.distortions.isEmpty ? t("distortions_none_selected") : record.distortions.map(\.label).joined(separator: " · "))
        lines.append("")
        lines.append("3. \(t("section_rational_response"))")
        lines.append(record.rationalResponse)
        lines.append(t("belief_after_display", record.beliefAfter))
        return lines.joined(separator: "\n")
    }
}

private struct DetailSection<Content: View>: View {
    @Environment(\.notebookPalette) private var palette
    let number: String
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(number). \(title)")
                .font(.headline)
                .foregroundStyle(palette.penBlue)
            content
        }
    }
}
