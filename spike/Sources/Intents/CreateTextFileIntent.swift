import AppIntents
import UniformTypeIdentifiers

struct CreateTextFileIntent: AppIntent {
    static let title: LocalizedStringResource = "Create Text File"
    static let description = IntentDescription("Turns text into a `.txt` file that later actions can save or share.")

    @Parameter(title: "Text") var text: String
    @Parameter(title: "File Name", default: "Note") var fileName: String

    static var parameterSummary: some ParameterSummary {
        Summary("Create text file \(\.$fileName) from \(\.$text)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<IntentFile> & ProvidesDialog {
        let name = fileName.hasSuffix(".txt") ? fileName : "\(fileName).txt"
        let file = IntentFile(data: Data(text.utf8), filename: name, type: .plainText)
        return .result(value: file, dialog: "Created \(name).")
    }
}
