import SwiftUI
import SwiftData

struct ThoughtRecordDetailView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Bindable var record: ThoughtRecord

    @State private var showingEdit = false
    @State private var currentPage = 0

    /// Three side-by-side columns only make sense with room to breathe (iPad, or an iPhone in
    /// landscape with a Plus/Pro Max-class width); otherwise switch to three swipeable/tappable
    /// pages instead of squeezing sentences down to one word per line.
    private var isWideScreen: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        Group {
            if isWideScreen {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if !record.situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            situationBlock
                        }
                        HStack(alignment: .top, spacing: 16) {
                            automaticThoughtSection.frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                            distortionsSection.frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                            rationalResponseSection.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(16)
                }
            } else {
                VStack(spacing: 0) {
                    if !record.situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        situationBlock
                            .padding(16)
                    }
                    PageTabRow(pageCount: 3, currentPage: $currentPage)
                        .padding(.horizontal, 8)
                    Divider()
                    TabView(selection: $currentPage) {
                        ScrollView { automaticThoughtSection.padding(16) }.tag(0)
                        ScrollView { distortionsSection.padding(16) }.tag(1)
                        ScrollView { rationalResponseSection.padding(16) }.tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
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

    @ViewBuilder
    private var situationBlock: some View {
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

    @ViewBuilder
    private var automaticThoughtSection: some View {
        DetailSection(number: "1", title: t("section_automatic_thought")) {
            Text(record.automaticThought)
                .font(.body)
            Text(t("belief_before_display", record.beliefBefore))
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
                .padding(.top, 4)
        }
    }

    @ViewBuilder
    private var distortionsSection: some View {
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
    }

    @ViewBuilder
    private var rationalResponseSection: some View {
        DetailSection(number: "3", title: t("section_rational_response")) {
            Text(record.rationalResponse)
                .font(.body)
            Text(t("belief_after_display", record.beliefAfter))
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
                .padding(.top, 4)
        }
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
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
            content
        }
    }
}
