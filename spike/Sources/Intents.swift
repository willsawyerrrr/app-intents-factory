import AppIntents

struct ScriptEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Script"
    static let defaultQuery = ScriptQuery()

    var id: String
    var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "\(id)") }
}

struct ScriptQuery: EntityStringQuery {
    func entities(for identifiers: [String]) async throws -> [ScriptEntity] {
        ScriptStore.names().filter(identifiers.contains).map(ScriptEntity.init)
    }

    func entities(matching string: String) async throws -> [ScriptEntity] {
        ScriptStore.names().filter { $0.localizedCaseInsensitiveContains(string) }.map(ScriptEntity.init)
    }

    func suggestedEntities() async throws -> [ScriptEntity] {
        ScriptStore.names().map(ScriptEntity.init)
    }
}

struct RunScriptIntent: AppIntent {
    static let title: LocalizedStringResource = "Run Script"
    static let description = IntentDescription("Runs a JavaScript file from the app's Documents folder by name.")

    @Parameter(title: "Name") var name: String
    @Parameter(title: "Input") var input: String?

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let result = try await ScriptRunner.run(name: name, input: input)
        return .result(value: result.output, dialog: IntentDialog(stringLiteral: result.output))
    }
}

struct RunSavedScriptIntent: AppIntent {
    static let title: LocalizedStringResource = "Run Saved Script"
    static let description = IntentDescription("Runs a script chosen from the list of available scripts.")

    @Parameter(title: "Script") var script: ScriptEntity
    @Parameter(title: "Input") var input: String?

    static var parameterSummary: some ParameterSummary {
        Summary("Run \(\.$script) with \(\.$input)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let result = try await ScriptRunner.run(name: script.id, input: input)
        return .result(value: result.output, dialog: IntentDialog(stringLiteral: result.output))
    }
}

struct SpikeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RunScriptIntent(),
            phrases: ["Run a script in \(.applicationName)"],
            shortTitle: "Run Script",
            systemImageName: "curlybraces"
        )
        AppShortcut(
            intent: RunSavedScriptIntent(),
            phrases: [
                "Run \(\.$script) in \(.applicationName)",
                "Run a saved script in \(.applicationName)",
            ],
            shortTitle: "Run Saved Script",
            systemImageName: "play.square"
        )
    }
}
