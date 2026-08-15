import SwiftUI
import UniformTypeIdentifiers

/// A minimal `FileDocument` wrapping plain text, used to hand the export JSON to
/// `.fileExporter`. Import goes through `.fileImporter` (a URL, read manually)
/// rather than this type's `init(configuration:)`, since we need to run our own
/// `DataTransfer.parseImport` validation on the contents either way.
struct JSONTextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var text: String

    init(text: String) {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}
