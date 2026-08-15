import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.notebookPalette) private var palette
    @Query(sort: \JournalEntry.sortIndex, order: .reverse) private var entries: [JournalEntry]
    @State private var showingNewEntry = false

    var body: some View {
        VStack(spacing: 0) {
            TopicHeader()
            if entries.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(entries) { entry in
                        NavigationLink(value: entry) {
                            JournalEntryRow(entry: entry)
                        }
                        .listRowBackground(palette.paper)
                    }
                    .onMove(perform: move)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .background(palette.paper)
        .navigationDestination(for: JournalEntry.self) { entry in
            JournalEntryView(entry: entry)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !entries.isEmpty {
                    EditButton()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingNewEntry = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(t("journal_new_page_desc"))
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NavigationStack {
                JournalEntryView(entry: nil)
            }
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var reordered = entries
        reordered.move(fromOffsets: source, toOffset: destination)
        let count = reordered.count
        for (index, entry) in reordered.enumerated() {
            entry.sortIndex = Double(count - index)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text(t("journal_empty_title"))
                .font(.title3.weight(.semibold))
            Text(t("journal_empty_body"))
                .font(.body)
                .foregroundStyle(palette.inkFaded)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct TopicHeader: View {
    @Environment(\.notebookPalette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(t("journal_topic_header"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(palette.inkFaded)
            Text(t("journal_topic"))
                .font(.headline)
                .foregroundStyle(palette.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
    }
}

private struct JournalEntryRow: View {
    @Environment(\.notebookPalette) private var palette
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.createdAt.formatted(date: .complete, time: .omitted))
                .font(.caption)
                .foregroundStyle(palette.inkFaded)
            Text(entry.body)
                .font(.body)
                .foregroundStyle(palette.ink)
                .lineLimit(4)
        }
        .padding(.vertical, 6)
    }
}
