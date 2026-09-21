import AppIntents

struct SpikeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FetchPageTitleIntent(),
            phrases: ["Fetch a page title in \(.applicationName)"],
            shortTitle: "Fetch Page Title",
            systemImageName: "safari"
        )
        AppShortcut(
            intent: CreateTextFileIntent(),
            phrases: ["Create a text file in \(.applicationName)"],
            shortTitle: "Create Text File",
            systemImageName: "doc.text"
        )
    }
}
