import SwiftUI
import SwiftData
import UniformTypeIdentifiers

private let importFormatExample = """
{
  "thoughtRecords": [
    {
      "situation": "Optional context",
      "automaticThought": "The upsetting thought",
      "distortions": ["ALL_OR_NOTHING", "LABELING"],
      "rationalResponse": "A fairer response",
      "beliefBefore": 80,
      "beliefAfter": 30
    }
  ],
  "journalEntries": [
    { "body": "Free-form text for a page" }
  ]
}
"""

struct DataTransferSectionView: View {
    @Environment(\.notebookPalette) private var palette
    @Environment(\.modelContext) private var modelContext
    @Query private var thoughtRecords: [ThoughtRecord]
    @Query private var journalEntries: [JournalEntry]

    @State private var isExporting = false
    @State private var exportDocument = JSONTextDocument(text: "{}")
    @State private var showingImportFormat = false
    @State private var isImporting = false
    @State private var statusMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(t("data_section_title"))
                .font(.headline)
            HStack(spacing: 16) {
                Button(t("data_export_action")) {
                    exportDocument = JSONTextDocument(text: DataTransfer.export(thoughtRecords: thoughtRecords, journalEntries: journalEntries))
                    isExporting = true
                }
                Button(t("data_import_action")) {
                    showingImportFormat = true
                }
            }
            if let statusMessage {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundStyle(palette.inkFaded)
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: exportDocument,
            contentType: .json,
            defaultFilename: "three-column-method-export"
        ) { result in
            switch result {
            case .success:
                statusMessage = t("data_export_success")
            case .failure:
                statusMessage = t("data_export_failed")
            }
        }
        .sheet(isPresented: $showingImportFormat) {
            ImportFormatSheet(onChooseFile: {
                showingImportFormat = false
                isImporting = true
            })
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.json]
        ) { result in
            handleImport(result)
        }
    }

    private func handleImport(_ result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let accessed = url.startAccessingSecurityScopedResource()
            defer { if accessed { url.stopAccessingSecurityScopedResource() } }
            let text = try String(contentsOf: url, encoding: .utf8)
            let imported = try DataTransfer.parseImport(text)
            for record in imported.thoughtRecords {
                modelContext.insert(record)
            }
            for entry in imported.journalEntries {
                modelContext.insert(entry)
            }
            statusMessage = t("data_import_success", imported.thoughtRecords.count, imported.journalEntries.count)
        } catch {
            statusMessage = t("data_import_failed")
        }
    }
}

private struct ImportFormatSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onChooseFile: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(t("data_import_format_intro"))
                        .font(.body)
                    Text(importFormatExample)
                        .font(.system(.footnote, design: .monospaced))
                    Text(t("data_import_format_note"))
                        .font(.footnote)
                    Text(t("data_import_format_distortion_codes"))
                        .font(.footnote)
                    Text(CognitiveDistortion.allCases.map(\.rawValue).joined(separator: ", "))
                        .font(.system(.footnote, design: .monospaced))
                }
                .padding()
            }
            .navigationTitle(t("data_import_format_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(t("cancel_desc")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(t("data_import_choose_file"), action: onChooseFile)
                }
            }
        }
    }
}
