import AppIntents
import Foundation

struct FetchPageTitleIntent: AppIntent {
    static let title: LocalizedStringResource = "Fetch Page Title"
    static let description = IntentDescription("Returns the title of a web page.")

    @Parameter(title: "URL") var url: URL

    static var parameterSummary: some ParameterSummary {
        Summary("Fetch title of \(\.$url)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let (data, _) = try await URLSession.shared.data(from: url)
        let html = String(decoding: data, as: UTF8.self)
        guard let match = html.firstMatch(of: /(?is)<title[^>]*>(.*?)<\/title>/) else {
            throw PageTitleError.noTitle
        }
        let title = String(match.1).trimmingCharacters(in: .whitespacesAndNewlines)
        return .result(value: title, dialog: "\(title)")
    }
}

enum PageTitleError: LocalizedError {
    case noTitle

    var errorDescription: String? { "The page has no title." }
}
