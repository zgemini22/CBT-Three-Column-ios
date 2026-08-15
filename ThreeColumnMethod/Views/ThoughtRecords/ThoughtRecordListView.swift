import SwiftUI
import SwiftData

struct ThoughtRecordListView: View {
    @Environment(\.notebookPalette) private var palette
    @Query(sort: \ThoughtRecord.createdAt, order: .reverse) private var records: [ThoughtRecord]
    @State private var showingNewRecord = false

    var body: some View {
        Group {
            if records.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(records) { record in
                        NavigationLink(value: record) {
                            ThoughtRecordRow(record: record)
                        }
                        .listRowBackground(palette.paperAlt)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .background(palette.paper)
        .navigationTitle(t("nav_thought_records"))
        .navigationDestination(for: ThoughtRecord.self) { record in
            ThoughtRecordDetailView(record: record)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingNewRecord = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(t("new_thought_record_desc"))
            }
        }
        .sheet(isPresented: $showingNewRecord) {
            NavigationStack {
                ThoughtRecordEditView(record: nil)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text(t("thought_records_empty_title"))
                .font(.title3.weight(.semibold))
            Text(t("thought_records_empty_body"))
                .font(.body)
                .foregroundStyle(palette.inkFaded)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ThoughtRecordRow: View {
    @Environment(\.notebookPalette) private var palette
    let record: ThoughtRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
            Text(record.automaticThought)
                .font(.body.weight(.medium))
                .foregroundStyle(palette.ink)
                .lineLimit(3)
            if !record.distortions.isEmpty {
                Text(record.distortions.map(\.label).joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(palette.penBlue)
            }
            Text(t("belief_before_after", record.beliefBefore, record.beliefAfter))
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
        }
        .padding(.vertical, 6)
    }
}
