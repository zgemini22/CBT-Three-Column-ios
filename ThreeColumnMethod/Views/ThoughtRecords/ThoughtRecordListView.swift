import SwiftUI
import SwiftData

struct ThoughtRecordListView: View {
    @Environment(\.notebookPalette) private var palette
    @Query(sort: \ThoughtRecord.createdAt, order: .reverse) private var records: [ThoughtRecord]
    @State private var showingNewRecord = false
    @State private var searchText = ""

    private var filteredRecords: [ThoughtRecord] {
        guard !searchText.isEmpty else { return records }
        return records.filter { matches($0, searchText) }
    }

    private var groups: [RecordGroup] {
        groupByRecency(filteredRecords)
    }

    var body: some View {
        Group {
            if records.isEmpty {
                emptyState
            } else if groups.isEmpty {
                noResultsState
            } else {
                List {
                    ForEach(groups) { group in
                        Section {
                            ForEach(group.records) { record in
                                NavigationLink(value: record) {
                                    ThoughtRecordRow(record: record)
                                }
                                .listRowBackground(palette.paperAlt)
                            }
                        } header: {
                            Text(group.label)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(palette.penBlue)
                                .textCase(nil)
                        }
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
        .searchable(text: $searchText, prompt: Text(t("search_hint")))
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

    private var noResultsState: some View {
        VStack(spacing: 8) {
            Text(t("search_no_results_title"))
                .font(.title3.weight(.semibold))
            Text(t("search_no_results_body"))
                .font(.body)
                .foregroundStyle(palette.inkFaded)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private func matches(_ record: ThoughtRecord, _ query: String) -> Bool {
    record.situation.localizedCaseInsensitiveContains(query) ||
        record.automaticThought.localizedCaseInsensitiveContains(query) ||
        record.rationalResponse.localizedCaseInsensitiveContains(query) ||
        record.distortions.contains { $0.label.localizedCaseInsensitiveContains(query) }
}

private struct RecordGroup: Identifiable {
    let id: String
    let label: String
    let records: [ThoughtRecord]
}

/// Buckets records (already sorted newest-first) into Today / Yesterday / This Week / This Month /
/// "Month Year" groups. Because the input is sorted and the bucket thresholds only get older,
/// a single pass preserves the right group order with no extra sorting.
private func groupByRecency(_ records: [ThoughtRecord]) -> [RecordGroup] {
    guard !records.isEmpty else { return [] }

    let calendar = Calendar.current
    let now = Date()
    let startOfToday = calendar.startOfDay(for: now)
    let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday) ?? startOfToday
    let startOfThisWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? startOfToday
    let startOfThisMonth = calendar.dateInterval(of: .month, for: now)?.start ?? startOfToday

    let monthYearFormatter = DateFormatter()
    monthYearFormatter.locale = Locale(identifier: LocalizationManager.shared.effectiveLanguage)
    monthYearFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")

    var order: [String] = []
    var buckets: [String: [ThoughtRecord]] = [:]

    for record in records {
        let label: String
        if record.createdAt >= startOfToday {
            label = t("group_today")
        } else if record.createdAt >= startOfYesterday {
            label = t("group_yesterday")
        } else if record.createdAt >= startOfThisWeek {
            label = t("group_this_week")
        } else if record.createdAt >= startOfThisMonth {
            label = t("group_this_month")
        } else {
            label = monthYearFormatter.string(from: record.createdAt)
        }

        if buckets[label] == nil {
            buckets[label] = []
            order.append(label)
        }
        buckets[label]?.append(record)
    }

    return order.map { label in
        RecordGroup(id: label, label: label, records: buckets[label] ?? [])
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
                .foregroundStyle(palette.penBlue)
        }
        .padding(.vertical, 6)
    }
}
