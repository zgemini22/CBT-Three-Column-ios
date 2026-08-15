import SwiftUI
import SwiftData

struct JournalEntryView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    /// nil means "creating a new page"; non-nil means "editing this existing one".
    let entry: JournalEntry?

    @State private var body_: String = ""
    private let newEntryCreatedAt = Date.now

    private var canSave: Bool {
        !body_.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var displayDate: Date {
        entry?.createdAt ?? newEntryCreatedAt
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(t("journal_topic"))
                    .font(.subheadline)
                    .italic()
                    .foregroundStyle(palette.inkFaded)

                ZStack(alignment: .topLeading) {
                    if body_.isEmpty {
                        Text(t("journal_write_placeholder"))
                            .font(.system(size: 17, design: .serif))
                            .foregroundStyle(palette.inkFaded)
                    }
                    TextEditor(text: $body_)
                        .font(.system(size: 17, design: .serif))
                        .foregroundStyle(palette.ink)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 300)
                        .padding(.horizontal, -5)
                }
            }
            .padding(EdgeInsets(top: 12, leading: 40, bottom: 40, trailing: 20))
            .notebookMargin(inset: 32)
        }
        .background(palette.paper)
        .navigationTitle(displayDate.formatted(date: .complete, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(!canSave)
                .accessibilityLabel(t("share_desc"))

                if entry != nil {
                    Button(role: .destructive) {
                        if let entry {
                            modelContext.delete(entry)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .accessibilityLabel(t("delete_desc"))
                }

                Button {
                    save()
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(!canSave)
                .accessibilityLabel(t("save_desc"))
            }
        }
        .onAppear {
            if let entry {
                body_ = entry.body
            }
        }
    }

    private var shareText: String {
        let dateText = displayDate.formatted(date: .complete, time: .omitted)
        return "\(dateText)\n\(t("journal_topic"))\n\n\(body_)"
    }

    private func save() {
        let trimmed = body_.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let entry {
            entry.body = trimmed
        } else {
            let newEntry = JournalEntry(createdAt: newEntryCreatedAt, body: trimmed)
            modelContext.insert(newEntry)
        }
        dismiss()
    }
}
