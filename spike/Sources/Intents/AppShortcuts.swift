import AppIntents

struct SpikeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: HelloWorldIntent(),
            phrases: ["Say hello in \(.applicationName)"],
            shortTitle: "Hello World",
            systemImageName: "hand.wave"
        )
    }
}
