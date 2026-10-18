import AppIntents

struct HelloWorldIntent: AppIntent {
    static let title: LocalizedStringResource = "Hello World"
    static let description = IntentDescription("Greets the given name.")

    @Parameter(title: "Name") var name: String

    static var parameterSummary: some ParameterSummary {
        Summary("Say hello to \(\.$name)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let greeting = "Hello, \(name)!"
        return .result(value: greeting, dialog: "\(greeting)")
    }
}
